% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sample_metadata.R
\name{sample_metadata_from_file}
\alias{sample_metadata_from_file}
\title{read sample metadata table from file and match it against provided sample IDs}
\usage{
sample_metadata_from_file(sample_id, filename, group_order = NA)
}
\arguments{
\item{sample_id}{character array representing sample IDs}

\item{filename}{full file path of the input file (eg; C:/temp/template_experiment1.xlsx)}

\item{group_order}{optionally, you can provide a preferred ordering of the sample groups as a character array}
}
\description{
note; user-facing function is import_sample_metadata()
}
