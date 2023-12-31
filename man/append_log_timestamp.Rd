% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/util_log.R
\name{append_log_timestamp}
\alias{append_log_timestamp}
\title{Append text to the log file and print to console, including a time duration}
\usage{
append_log_timestamp(s, start_time, type = "progress")
}
\arguments{
\item{s}{your message as a character string}

\item{start_time}{the start time, generated by Sys.time(), that will be compared to the current Sys.time()}

\item{type}{the type of message, typically "progress". See further append_log()}
}
\description{
Append text to the log file and print to console, including a time duration
}
