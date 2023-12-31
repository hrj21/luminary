% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{u5plex}
\alias{u5plex}
\title{5-plex intelliframe}
\format{
An intelliframe object containing 5 analytes, 80 standard samples, 20
control samples, and 1820 unknown samples
\describe{
\item{@metadata}{A tibble of keyword-value pairs of instrument metadata.}
\item{@analytes}{A tibble of analyte metadata.}
\item{@expected}{A tibble containing the expected concentrations of analyte
standards.}
\item{@recovery}{A tibble containing the recovery values of analyte
standards (recovery = predicted / expected). }
\item{@recovery_avg}{A tibble of mean recovery values across replicates.}
\item{@well_data}{A tibble of predicted concentrations for all individual
wells.}
\item{@summary_data}{A tibble of mean predicted concentrations across all
replicates.}
\item{@curve_data}{A tibble of standard curve metadata.}
}
}
\usage{
u5plex
}
\description{
Data from a single, 5-plex xMAP experiment.
}
\keyword{datasets}
