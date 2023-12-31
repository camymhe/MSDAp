#' Import a label-free proteomics dataset from EncyclopeDIA
#'
#' This function imports peptide intensities, retention times and peptide-to-protein mappings from a 'Quant Report' .elib file generated by EncyclopeDIA.
#'
#' Because this 'Quant Report' does not contain confidence scores per peptide per individual sample, these can optionally be imported from the individual .elib files generated by EncyclopeDIA while processing the individual samples / raw files.
#' This will enable MS-DAP to discriminate between match-between-runs hits and peptides that were detected/identified in a sample, and consequently use this information in peptide filtering (for instance by removing peptides that are mostly based on MBR hits).
#'
#' @param file_quant_report the EncyclopeDIA 'Quant Report' .elib file
#' @param path_elib_rawfiles optional. the directory that contains the EncyclopeDIA .elib files matching each sample (mzML/dia input file to EncyclopeDIA)
#' @param confidence_threshold confidence score threshold at which a peptide is considered 'identified' (target value must be lesser than or equals)
#' @param return_decoys logical indicating whether to return decoy peptides. It doesn't work for current EncyclopeDIA datasets as these do not seem to contain decoys.
#' @importFrom RSQLite SQLite
#' @importFrom DBI dbIsValid dbExistsTable dbConnect dbListTables dbGetQuery dbDisconnect
#' @importFrom data.table as.data.table
#' @export
import_dataset_encyclopedia = function(file_quant_report, path_elib_rawfiles = NA, confidence_threshold = 0.01, return_decoys = FALSE) {
  reset_log()
  append_log("reading EncyclopeDIA elib ...", type = "info")

  # input validation
  check_parameter_is_string(file_quant_report)
  # will check for presence of file as well as .gz/.zip extension if file doesn't exist, will throw error if both do not exist
  file_quant_report = path_exists(file_quant_report, try_compressed = FALSE)

  ### extract individual peptide*sample confidence scores from .elib files matching every input sample
  peptide_confidence = peptide_confidence_unique_sample_id = NULL
  # this step is optional, check if a valid parameter was provided
  if(length(path_elib_rawfiles) == 1 && !is.na(path_elib_rawfiles) && is.character(path_elib_rawfiles)) {
    # find files with elib extension
    files = dir(path_elib_rawfiles, "\\.elib$", full.names = T, ignore.case = T)

    # input validation
    if (length(files) < 2) {
      append_log(paste("There must be at least 2 .elib files at 'path_elib_rawfiles' parameter (skip this optional  parameter if files are unavailable):", path_elib_rawfiles), type = "error")
    }


    for(filename in files) {
      append_log(paste("parsing EncyclopeDIA elib file:", filename, "..."), type = "progress")

      # connect to database  +  catch errors
      db = tryCatch(DBI::dbConnect(RSQLite::SQLite(), filename, synchronous = NULL), error=function(x) NULL)
      if(length(db) == 0 || !DBI::dbIsValid(db) || tryCatch({DBI::dbExistsTable(db,"test"); FALSE}, error=function(x){TRUE})) {
        append_log(paste("Input file is not an SQLite database (which the EncyclopeDIA elib file should be):", filename), type = "error")
      }

      # extract data from SQLite database
      p = as_tibble(tryCatch(DBI::dbGetQuery(db, 'SELECT SourceFile AS sample_id, PeptideModSeq AS sequence_modified, PeptideSeq AS sequence_plain, PrecursorCharge AS charge, QValue AS confidence, IsDecoy as isdecoy FROM peptidescores WHERE isdecoy = 0', error=function(x) NULL)))

      # check against empty result
      if (nrow(p) == 0) {
        append_log(paste("Empty SQLite database table 'peptidescores':", filename), type = "error")
      }

      # check against multiple sample_id (e.g.elib summarizes over multiple raw files)
      if(n_distinct(p$sample_id) != 1) {
        append_log(paste("Skipping input that contains summarized data (eg. a EncyclopeDIA 'chromatogram library' or 'Quant Report'):", filename), type = "warning")
      } else {

        # append to results
        peptide_confidence = bind_rows(peptide_confidence, p)

        # check against duplicates; user has multiple .elib files for one mzML input file so we don't know which holds the appropriate confidence scores  (perhaps the input path/directory holds results from multiple EncyclopeDIA runs with different parameters)
        idx_sample_id = match(p$sample_id[1], peptide_confidence_unique_sample_id$sample_id)
        if(!is.na(idx_sample_id)) {
          append_log(paste(filename, "is a redundant .elib file; contains peptide data for sample", p$sample_id[1], "that was already parsed before in", peptide_confidence_unique_sample_id$filename[idx_sample_id]), type = "error")
        }
        peptide_confidence_unique_sample_id = bind_rows(peptide_confidence_unique_sample_id, tibble(sample_id=p$sample_id[1], filename=filename))
      }
      rm(p)

      # close DB connection
      DBI::dbDisconnect(db)
    }
  } else {
    append_log("Input file path with EncyclopeDIA .elib files of individual samples was not provided, will infer confidence scores at peptide-level (from 'Quant Report') instead", type = "warning")
  }



  ### quant report
  append_log(paste("parsing EncyclopeDIA 'Quant Report' elib file:", file_quant_report, "..."), type = "progress")

  # connect to database  +  catch errors
  db = tryCatch(DBI::dbConnect(RSQLite::SQLite(), file_quant_report, synchronous = NULL), error=function(x) NULL)
  if(length(db) == 0 || !DBI::dbIsValid(db) || tryCatch({DBI::dbExistsTable(db,"test"); FALSE}, error=function(x){TRUE})) {
    append_log(paste("Input file is not an SQLite database (which the EncyclopeDIA elib file should be):", file_quant_report), type = "error")
  }

  # peptide*sample intensities
  peptides = as_tibble(tryCatch(DBI::dbGetQuery(db, 'SELECT SourceFile AS sample_id, PeptideModSeq AS sequence_modified, PeptideSeq AS sequence_plain, PrecursorCharge AS charge, RTInSecondsCenter AS rt, TotalIntensity AS intensity FROM peptidequants', error=function(x) NULL)))

  # check against empty result
  if (nrow(peptides) == 0) {
    append_log(paste("Empty SQLite database table 'peptidequants':", file_quant_report), type = "error")
  }

  # if there are confidence scores from individual .elib files, use those
  if(length(peptide_confidence) > 0) {
    # check against missing files
    sid_missing = setdiff(unique(peptides$sample_id), peptide_confidence$sample_id)
    if(length(sid_missing) > 0) {
      append_log(paste("Samples present in the 'Quant Report' .elib are missing from the set of individual sample .elib files in input directory:", paste(sid_missing, collapse=", ")), type = "error")
    }

    # check against redundant entries, don't trust DB table won't change in the future
    peptide_confidence = peptide_confidence %>% arrange(confidence) %>% distinct(sample_id, sequence_modified, charge, .keep_all = T)
    # join peptide confidences with main peptide quant results
    peptides = peptides %>% left_join(peptide_confidence %>% select(sample_id, sequence_modified, charge, confidence), by=c("sample_id", "sequence_modified", "charge"))
    # MBR hits won't have a confidence value, set to 1
    peptides$confidence[!is.finite(peptides$confidence)] = 1

  } else {
    # we have to make due with confidence scores from this .elib; join at peptide-level NOT at peptide*sample level (because such data is unavailable in a 'Quant Report')
    pepscores = as_tibble(tryCatch(DBI::dbGetQuery(db, 'SELECT PeptideModSeq AS sequence_modified, PrecursorCharge AS charge, QValue AS confidence FROM peptidescores', error=function(x) NULL)))
    # check against redundant entries, don't trust DB table won't change in the future
    pepscores = pepscores %>% arrange(confidence) %>% distinct(sequence_modified, charge, .keep_all = T)
    # join peptide confidences with main peptide quant results
    peptides = peptides %>% left_join(pepscores, by=c("sequence_modified", "charge"))
    # to be safe, just assume missing confidence values are actually "great confidence" because here we use peptide-level confidence values and every peptide should be present in the input table  (so most likely a technical error or fail assumption in our parsing of the .elib)
    peptides$confidence[!is.finite(peptides$confidence)] = 0
  }



  ### pep2prot
  pep2prot = as_tibble(tryCatch(DBI::dbGetQuery(db, 'SELECT PeptideSeq AS sequence_plain, ProteinAccession AS protein_id, isDecoy AS isdecoy FROM peptidetoprotein WHERE isdecoy = 0', error=function(x) NULL)))

  # close DB connection
  DBI::dbDisconnect(db)

  # check against empty result
  if (nrow(pep2prot) == 0) {
    append_log(paste("Empty SQLite database table 'peptidetoprotein':", file_quant_report), type = "error")
  }

  # stable sorting of protein_id to prevent different protein-groups with same proteins but in different order (e.g. one might end up with protein-group A;B;C, A;C;B and B;C;A). this implementation does maintain order as provided by upstream software at least (e.g. "expected" leading protein)
  uprot_ordered = pep2prot %>% distinct(protein_id) %>% pull()

  pep2prot = pep2prot %>%
    distinct_all() %>%
    arrange(match(protein_id, uprot_ordered)) %>%
    group_by(sequence_plain) %>%
    summarise(protein_id = paste0(protein_id, collapse=";") )

  # add protein_id and decoy flag to peptides tibble
  peptides = left_join(peptides, pep2prot, by="sequence_plain")

  peptides = peptides %>% mutate(
    # convert peptide RT from seconds to minutes
    rt = rt / 60,
    # decoys removed upsteam (they're not in quant reports anyway, so we ignore @ parsing code)
    isdecoy = F)



  ### to MS-DAP dataset
  # ! re-use our generic data table parser to ensure input data standardization and maintain consistency among all data parsing routines
  # functions include; enforce data types (eg; isdecoy as boolean), format data (eg; strip extensions from filenames) and remove invalid rows (eg; intensity=0)
  # also note that, at current default settings, this function selects the 'best' peptide_id for each sequence_modified (eg; if the same sequence was found with multiple charges)
  ds = import_dataset_in_long_format(x = peptides,
                                     attributes_required = list(sample_id = "sample_id",
                                                                protein_id = "protein_id",
                                                                sequence_plain = "sequence_plain",
                                                                sequence_modified = "sequence_modified",
                                                                charge = "charge",
                                                                rt = "rt",
                                                                isdecoy = "isdecoy",
                                                                intensity = "intensity",
                                                                confidence = "confidence"),
                                     confidence_threshold = confidence_threshold,
                                     return_decoys = return_decoys,
                                     do_plot = F) # data for Cscore histograms is not available in EncyclopeDIA, so disable plotting

  ds$acquisition_mode = "dia"
  return(ds)
}
