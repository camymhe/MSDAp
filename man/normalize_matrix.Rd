% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/util_normalization.R
\name{normalize_matrix}
\alias{normalize_matrix}
\title{Normalize a numeric matrix; in MS-DAP this is typically a peptide-level log2 intensity matrix}
\usage{
normalize_matrix(
  x_as_log2,
  algorithm,
  group_by_cols = NA,
  group_by_rows = NA,
  rollup_algorithm = "maxlfq"
)
}
\arguments{
\item{x_as_log2}{the numeric matrix, must be log2 transformed}

\item{algorithm}{the normalization algorithm to apply. Either one of the built-in options, see \code{\link{normalization_algorithms}} function focumentation, or the name of your custom normalization function (see GitHub documentation on custom normalization functions for more details)}

\item{group_by_cols}{a character array of the same length as the number of columns in the provided data matrix, describing the grouping of each column/sample}

\item{group_by_rows}{optionally, an array of grouping IDs for the rows. e.g. if input matrix is a peptide table these can be strings with protein-group identifiers. Required parameter for modebetween_protein normalization}

\item{rollup_algorithm}{optionally, the algorithm for combining peptides to proteins as used in normalization algorithms that require a priori rollup from peptides to a protein-level abundance matrix (e.g. modebetween_protein). Refer to \code{\link{rollup_pep2prot}} function documentation for available options and a brief description of each}
}
\description{
wrapper function around various normalization algorithms. In the results, log2 intensity values below 1 are thresholded at 1
}
\seealso{
\code{normalization_algorithms()} for available normalization algorithms and documentation.
}
