% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/export_data_tables.R
\name{export_protein_abundance_matrix}
\alias{export_protein_abundance_matrix}
\title{Rollup and export to protein-level TSV table, applied to all peptide-level intensity data}
\usage{
export_protein_abundance_matrix(dataset, rollup_algorithm, output_dir)
}
\arguments{
\item{dataset}{your dataset}

\item{rollup_algorithm}{strategy for combining peptides to proteins. For valid options, see rollup_pep2prot()}

\item{output_dir}{output directory where all output files are stored, must be an existing directory}
}
\description{
generated a protein-level abundance matrix for each column in dataset$peptides that starts with "intensity"
}
