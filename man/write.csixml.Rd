% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/write.csixml.R
\name{write.csixml}
\alias{write.csixml}
\title{Write csdf object to a file in CSI XML format}
\usage{
write.csixml(x, file = "")
}
\arguments{
\item{x}{a \code{\linkS4class{csdf}} object}

\item{file}{a file to write to}
}
\description{
We write a text file directly without XML object to avoid memory overhead for
large datasets.
}
\examples{
Sys.setenv(TZ='GMT')
fpath <- system.file("extdata", "Station_Daily.dat", package="csdf")
obj <- read.toa5(fpath)
write.csixml(obj, "out.xml")
}

