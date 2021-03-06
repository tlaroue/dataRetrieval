% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/importWQP.R
\name{importWQP}
\alias{importWQP}
\title{Basic Water Quality Portal Data parser}
\usage{
importWQP(obs_url, zip = FALSE, tz = "")
}
\arguments{
\item{obs_url}{character URL to Water Quality Portal#' @keywords data import USGS web service}

\item{zip}{logical to request data via downloading zip file. Default set to FALSE.}

\item{tz}{character to set timezone attribute of datetime. Default is an empty quote, which converts the 
datetimes to UTC (properly accounting for daylight savings times based on the data's provided tz_cd column).
Possible values to provide are "America/New_York","America/Chicago", "America/Denver","America/Los_Angeles",
"America/Anchorage","America/Honolulu","America/Jamaica","America/Managua","America/Phoenix", and "America/Metlakatla"}
}
\value{
retval dataframe raw data returned from the Water Quality Portal. Additionally, a POSIXct dateTime column is supplied for 
start and end times, and converted to UTC. See \url{http://www.waterqualitydata.us/portal_userguide.jsp} for more information.
}
\description{
Imports data from the Water Quality Portal based on a specified url.
}
\examples{
# These examples require an internet connection to run

## Examples take longer than 5 seconds:
\dontrun{
rawSampleURL <- constructWQPURL('USGS-01594440','01075', '', '')

rawSample <- importWQP(rawSampleURL)

rawSampleURL_Zip <- constructWQPURL('USGS-01594440','01075', '', '', TRUE)
rawSample2 <- importWQP(rawSampleURL_Zip, zip=TRUE)

STORETex <- constructWQPURL('WIDNR_WQX-10032762','Specific conductance', '', '')
STORETdata <- importWQP(STORETex)
}
}
\seealso{
\code{\link{readWQPdata}}, \code{\link{readWQPqw}}, \code{\link{whatWQPsites}}
}

