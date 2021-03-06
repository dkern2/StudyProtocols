% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/WriteReport.R
\name{writeReport}
\alias{writeReport}
\title{Write a report summarizing all the results for a single database}
\usage{
writeReport(exportFolder, outputFile)
}
\arguments{
\item{exportFolder}{The path to the export folder containing the results.}

\item{outputFile}{The name of the .docx file that will be created.}
}
\description{
Write a report summarizing all the results for a single database
}
\details{
Requires that the \code{\link{createTableAndFigures}} has been executed first.
}
