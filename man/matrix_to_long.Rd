% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/util_generic.R
\name{matrix_to_long}
\alias{matrix_to_long}
\title{wrapper function around tidyverse's gather to convert a matrix to long-format tibble}
\usage{
matrix_to_long(
  mat,
  value_name = "value",
  column_name = "sample",
  row_name = "sequence"
)
}
\arguments{
\item{mat}{a matrix}

\item{value_name}{target column name for the values}

\item{column_name}{target column name for the row names}

\item{row_name}{target column name for the column names}
}
\description{
NA values are removed from output
}
