% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gene_idmapping.R
\name{protein2gene_by_symbol}
\alias{protein2gene_by_symbol}
\title{Map the the symbol column in a table to HGNC human gene IDs by matching official gene symbols and synonyms}
\usage{
protein2gene_by_symbol(x, hgnc)
}
\arguments{
\item{x}{a data.table with a column symbol}

\item{hgnc}{HGNC lookup table from \code{hgnc_lookuptable()}}
}
\description{
Map the the symbol column in a table to HGNC human gene IDs by matching official gene symbols and synonyms
}
