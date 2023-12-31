% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_normalization.R
\name{plot_foldchange_distribution_among_replicates}
\alias{plot_foldchange_distribution_among_replicates}
\title{Plot within-group foldchange distributions to assess outlier samples}
\usage{
plot_foldchange_distribution_among_replicates(peptides, samples)
}
\arguments{
\item{peptides}{peptide tibble, e.g. dataset$peptides, which must hold raw intensity data in "intensity" column and filtered and normalized data in the column "intensity_qc_basic"}

\item{samples}{sample tibble, e.g. dataset$samples}
}
\description{
Plot within-group foldchange distributions to assess outlier samples
}
\examples{
\dontrun{
  dataset = filter_peptides_by_group(
    dataset,
    colname="intensity_qc_basic",
    disregard_exclude_samples = FALSE,
    nquant=2,
    ndetect=1+is_dia_dataset(dataset),
    norm_algorithm = c("vsn", "modebetween_protein"),
    rollup_algorithm = "maxlfq"
  )
  l = plot_foldchange_distribution_among_replicates(mypeptides, dataset$samples)
  for(p in l$plotlist) print(p)
  print(l$tib_scores)
}
}
