% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/filter_peptides.R
\name{filter_dataset}
\alias{filter_dataset}
\title{Filter dataset}
\usage{
filter_dataset(
  dataset,
  filter_min_detect = 1,
  filter_fraction_detect = 0,
  filter_min_quant = 0,
  filter_fraction_quant = 0,
  filter_min_peptide_per_prot = 1,
  filter_topn_peptides = 0,
  norm_algorithm = "",
  rollup_algorithm = "maxlfq",
  by_group = T,
  all_group = T,
  by_contrast = F
)
}
\arguments{
\item{dataset}{a valid dataset object generated upstream by, for instance, import_dataset_skyline}

\item{filter_min_detect}{in order for a peptide to 'pass' in a sample group, in how many replicates must it be detected?}

\item{filter_fraction_detect}{in order for a peptide to 'pass' in a sample group, what fraction of replicates must it be detected?}

\item{filter_min_quant}{in order for a peptide to 'pass' in a sample group, in how many replicates must it be quantified?}

\item{filter_fraction_quant}{in order for a peptide to 'pass' in a sample group, what fraction of replicates must it be quantified?}

\item{filter_min_peptide_per_prot}{in order for a peptide to 'pass' in a sample group, how many peptides should be available after detect filters?}

\item{filter_topn_peptides}{maximum number of peptides to maintain for each protein (from the subset that passes above filters, peptides are ranked by the number of samples where detected and their variation between replicates). 1 is default, 2 can be a good choice situationally. If set to 1, make sure to inspect individual peptide data/plots for proteins with 1 peptide.}

\item{norm_algorithm}{normalization algorithms. options; "", "vsn", "loess", "rlr", "msempire", "vwmb", "modebetween". Provide an array of options to run each algorithm consecutively}

\item{rollup_algorithm}{the algorithm for combining peptides to proteins as used in normalization algorithms that require a priori rollup from peptides to a protein-level abundance matrix (e.g. modebetween_protein). Refer to \code{\link{rollup_pep2prot}} function documentation for available options and a brief description of each}

\item{by_group}{within each sample group, apply the filter. All peptides that fail the filter in group g will have intensity value NA in the intensity_by_group column for the samples in the respective group}

\item{all_group}{in every sample group, apply the filter. All peptides that fail the filter in any group will have intensity value NA in the intensity_all_groups column for all samples}

\item{by_contrast}{should the above filters be applied to all sample groups, or only those tested within each contrast? Enabling this optimizes available data in each contrast, but increases the complexity somewhat as different subsets of peptides are used in each contrast and normalization is applied separately}
}
\description{
For each of the filters (by group, all groups, by contrast) an extra column will be appended to the dataset$peptides table that contains the intensity data for all peptides that pass these filters (\verb{name: intensity_<filter>}).
Optionally, you can apply normalization (recommended).
}
\details{
Note; this is built-in for \code{analysis_quickstart} so if you use that all-in-one function you don't have to perform all pipeline steps manually
}
