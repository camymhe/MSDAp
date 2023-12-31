% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/util_log.R
\name{append_log}
\alias{append_log}
\title{This function is called throughout the pipeline to append messages to the log}
\usage{
append_log(s, type = "info", start_time = NULL)
}
\arguments{
\item{s}{your message as a character string}

\item{type}{the type of message. supported color-coding through logger.default: progress, info, warning, error. For the latter, an R error is thrown after logging!}

\item{start_time}{optionally, provide a start time generated by Sys.time() that should be compared to the current Sys.time()}
}
\description{
This function is called throughout the pipeline to append messages to the log
}
