setClass("iso8601")
setAs("character", "iso8601", function(from) as.POSIXct(from, format="%Y-%m-%dT%H:%M:%S"))

#' Read Campbell Scientific XML
#'
#' @param file The name of the file containing the Campbell Scientific XML
#'   contents. This can contain \~ which is expanded to the user's home
#'   directory.
#'
#' @return an S4 class \code{\linkS4class{csdf}}
#' @export
#'
#'
#' @examples
#' Sys.setenv(TZ='GMT')
#' fpath <- system.file("extdata", "CSIXML_Station_Daily.dat", package="csdf")
#' obj <- read.csixml(fpath)
read.csixml <- function(file) {
  if(!requireNamespace("XML"))
    stop("Failed to load XML")
  doc <- XML::xmlParse(file)
  meta <- with(XML::xmlToDataFrame(homogeneous=TRUE, nodes=XML::getNodeSet(doc, "//head/environment")),
               data.frame(station=`station-name`,
                          model=model,
                          serial=`serial-no`,
                          os=`os-version`,
                          dld=`dld-name`,
                          signature=`dld-sig`,
                          table=`table-name`))
  variables0 <- as.data.frame(
    XML::xpathSApply(doc, "//head/fields/field", XML::xmlAttrs),
    stringsAsFactors=FALSE
  )
  vars <- as.character(variables0["name",])
  colnames(variables0) <- vars
  header <- cbind(
    data.frame(TIMESTAMP=c("TS", ""), RECORD=c("RN", "")),
    variables0[c("units", "process"),])
  idx <- which(grepl("_TM[xn]|TIMESTAMP$", vars))
  len <- length(idx)
  colClasses <- `names<-`(rep("numeric", length=length(vars)), vars)
  colClasses[idx] <- "iso8601"

  suppressWarnings(# In asMethod(object) : NAs introduced by coercion
    dat <- XML::xmlToDataFrame(colClasses=colClasses, homogeneous=TRUE,
                               nodes=XML::getNodeSet(doc, "//data/r"))
  )
  names(dat) <- vars

  left <- with(as.data.frame(
    t(XML::xpathSApply(doc, "//data/r", XML::xmlAttrs)),
    stringsAsFactors=FALSE
  ), {
    data.frame(TIMESTAMP=as(time, "iso8601"), RECORD=as.numeric(no))
  })

  new("csdf", data=cbind(left, dat), variables=header, meta=meta)
}
