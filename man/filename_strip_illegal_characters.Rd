% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/util_files.R
\name{filename_strip_illegal_characters}
\alias{filename_strip_illegal_characters}
\title{from filename minus extension, replace illegal characters (allowed are alphanumeric, underscore and dash)}
\usage{
filename_strip_illegal_characters(f, strict = FALSE, replacement = "_")
}
\arguments{
\item{f}{f can either be a filename or a full path}

\item{strict}{boolean, if TRUE; only allow alphanumeric, underscore and '-'}

\item{replacement}{string replacement value for removed characters}
}
\description{
from filename minus extension, replace illegal characters (allowed are alphanumeric, underscore and dash)
}
\examples{
\dontrun{
  # nothing to do
  filename_strip_illegal_characters("test.txt")
  filename_strip_illegal_characters("C:/temp/test.txt")
  # fix filename
  filename_strip_illegal_characters("C:/temp/test !~: file.txt", strict = F)
  # example emphasizes that this function only applies to filename
  filename_strip_illegal_characters("C:/temp/this is ok/not ok.txt", strict = T)
}
}
