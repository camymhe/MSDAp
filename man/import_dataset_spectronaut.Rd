% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/parse_longformat_generic.R
\name{import_dataset_spectronaut}
\alias{import_dataset_spectronaut}
\title{Import a label-free proteomics dataset from Spectronaut}
\usage{
import_dataset_spectronaut(
  filename,
  confidence_threshold = 0.01,
  use_normalized_intensities = FALSE,
  use_irt = TRUE,
  return_decoys = FALSE,
  remove_shared_spectronaut_proteingroups = FALSE,
  do_plot = TRUE
)
}
\arguments{
\item{filename}{the full file path of the input file}

\item{confidence_threshold}{confidence score threshold at which a peptide is considered 'identified', default: 0.01 (target value must be lesser than or equals)}

\item{use_normalized_intensities}{use the abundance values as-is (recommended) or those normalized by Spectronaut}

\item{use_irt}{logical indicating whether to use standardized (IRT, EG.iRTEmpirical) or the empirical (EG.RTEmpirical) retention times}

\item{return_decoys}{logical indicating whether to return decoy peptides. Should be set to FALSE, and if enabled, make sure to manually remove the decoys from the peptides tibble before running the quickstart function!}

\item{remove_shared_spectronaut_proteingroups}{if the peptide-to-proteingroup assignments from Spectronaut are used as is (eg; you're not mapping the peptides to some spectral library downstream), you can remove peptides that map to multiple proteingroups}

\item{do_plot}{logical indicating whether to create QC plots that are shown in the downstream PDF report (if enabled)}
}
\description{
No particular settings are needed, a report with peptide abundances should be made that contains these columns: R.FileName, PG.ProteinGroups, EG.IsDecoy, EG.Library, EG.Qvalue, EG.iRTEmpirical, EG.Cscore, FG.Id, FG.MS2Quantity, FG.MS2RawQuantity
}
