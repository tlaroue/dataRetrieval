## ----openLibrary, echo=FALSE------------------------------
library(xtable)
options(continue=" ")
options(width=60)
library(knitr)


## ----include=TRUE ,echo=FALSE,eval=TRUE-------------------
opts_chunk$set(highlight=TRUE, tidy=TRUE, keep.space=TRUE, keep.blank.space=FALSE, keep.comment=TRUE, tidy=FALSE,comment="")
knit_hooks$set(inline = function(x) {
   if (is.numeric(x)) round(x, 3)})
knit_hooks$set(crop = hook_pdfcrop)

bold.colHeaders <- function(x) {
  x <- gsub("\\^(\\d)","$\\^\\1$",x)
  x <- gsub("\\%","\\\\%",x)
  x <- gsub("\\_"," ",x)
  returnX <- paste("\\multicolumn{1}{c}{\\textbf{\\textsf{", x, "}}}", sep = "")
}
addSpace <- function(x) ifelse(x != "1", "[5pt]","")
library(dataRetrieval)

## ----workflow, echo=TRUE,eval=FALSE-----------------------
#  library(dataRetrieval)
#  # Choptank River near Greensboro, MD
#  siteNumber <- "01491000"
#  ChoptankInfo <- readNWISsite(siteNumber)
#  parameterCd <- "00060"
#  
#  #Raw daily data:
#  rawDailyData <- readNWISdv(siteNumber,parameterCd,
#                        "1980-01-01","2010-01-01")
#  
#  # Sample data Nitrate:
#  parameterCd <- "00618"
#  qwData <- readNWISqw(siteNumber,parameterCd,
#                        "1980-01-01","2010-01-01")
#  
#  pCode <- readNWISpCode(parameterCd)
#  

## ----tableParameterCodes, echo=FALSE,results='asis'-------
pCode <- c('00060', '00065', '00010','00045','00400')
shortName <- c("Discharge [ft$^3$/s]","Gage height [ft]","Temperature [C]", "Precipitation [in]", "pH")

data.df <- data.frame(pCode, shortName, stringsAsFactors=FALSE)

print(xtable(data.df,
       label="tab:params",
       caption="Common USGS Parameter Codes"),
       caption.placement="top",
       size = "\\footnotesize",
       latex.environment=NULL,
       sanitize.text.function = function(x) {x},
       sanitize.colnames.function =  bold.colHeaders,
       sanitize.rownames.function = addSpace
      )


## ----tableStatCodes, echo=FALSE,results='asis'------------
StatCode <- c('00001', '00002', '00003','00008')
shortName <- c("Maximum","Minimum","Mean", "Median")

data.df <- data.frame(StatCode, shortName, stringsAsFactors=FALSE)

print(xtable(data.df,label="tab:stat",
           caption="Commonly used USGS Stat Codes"),
       caption.placement="top",
       size = "\\footnotesize",
       latex.environment=NULL,
       sanitize.colnames.function = bold.colHeaders,
       sanitize.rownames.function = addSpace
      )


## ----getSite, echo=TRUE, eval=FALSE-----------------------
#  siteNumbers <- c("01491000","01645000")
#  siteINFO <- readNWISsite(siteNumbers)

## ----siteNames3, echo=TRUE, eval=FALSE--------------------
#  comment(siteINFO)

## ----getSiteExtended, echo=TRUE, eval=FALSE---------------
#  # Continuing from the previous example:
#  # This pulls out just the daily, mean data:
#  
#  dailyDataAvailable <- whatNWISdata(siteNumbers,
#                      service="dv", statCd="00003")
#  
#  

## ----tablegda, echo=FALSE,eval=FALSE----------------------
#  tableData <- with(dailyDataAvailable,
#        data.frame(
#        siteNumber= site_no,
#        srsname=srsname,
#        startDate=as.character(begin_date),
#        endDate=as.character(end_date),
#        count=as.character(count_nu),
#        units=parameter_units,
#  #       statCd = stat_cd,
#        stringsAsFactors=FALSE)
#        )
#  
#  tableData$units[which(tableData$units == "ft3/s")] <- "ft$^3$/s"
#  tableData$units[which(tableData$units == "uS/cm @25C")] <- "$\\mu$S/cm @25C"
#  
#  
#  print(xtable(tableData,label="tab:gda",
#      caption="Reformatted version of output from \\texttt{whatNWISdata} function for the Choptank River near Greensboro, MD, and from Seneca Creek at Dawsonville, MD from the daily values service [Some columns deleted for space considerations]"),
#         caption.placement="top",
#         size = "\\footnotesize",
#         latex.environment=NULL,
#         sanitize.text.function = function(x) {x},
#         sanitize.colnames.function =  bold.colHeaders,
#         sanitize.rownames.function = addSpace
#        )
#  

## ----label=getPCodeInfo, echo=TRUE, eval=FALSE------------
#  # Using defaults:
#  parameterCd <- "00618"
#  parameterINFO <- readNWISpCode(parameterCd)

## ----label=getNWISDaily, echo=TRUE, eval=FALSE------------
#  
#  # Choptank River near Greensboro, MD:
#  siteNumber <- "01491000"
#  parameterCd <- "00060"  # Discharge
#  startDate <- "2009-10-01"
#  endDate <- "2012-09-30"
#  
#  discharge <- readNWISdv(siteNumber,
#                      parameterCd, startDate, endDate)

## ----label=getNWIStemperature, echo=TRUE, eval=FALSE------
#  siteNumber <- "01491000"
#  parameterCd <- c("00010","00060")  # Temperature and discharge
#  statCd <- c("00001","00003")  # Mean and maximum
#  startDate <- "2012-01-01"
#  endDate <- "2012-05-01"
#  
#  temperatureAndFlow <- readNWISdv(siteNumber, parameterCd,
#          startDate, endDate, statCd=statCd)
#  

## ----label=getNWIStemperature2, echo=FALSE, eval=TRUE-----
filePath <- system.file("extdata", package="dataRetrieval")
fileName <- "temperatureAndFlow.RData"
fullPath <- file.path(filePath, fileName)
load(fullPath)


## ----label=renameColumns, echo=TRUE-----------------------
names(temperatureAndFlow)

temperatureAndFlow <- renameNWISColumns(temperatureAndFlow)
names(temperatureAndFlow)


## ----label=attr1, echo=TRUE-------------------------------
#Information about the data frame attributes:
names(attributes(temperatureAndFlow))

statInfo <- attr(temperatureAndFlow, "statisticInfo")
variableInfo <- attr(temperatureAndFlow, "variableInfo")
siteInfo <- attr(temperatureAndFlow, "siteInfo")


## ----getNWIStemperaturePlot, echo=TRUE, fig.cap="Temperature and discharge plot of Choptank River in 2012.",out.width='1\\linewidth',out.height='1\\linewidth',fig.show='hold'----
variableInfo <- attr(temperatureAndFlow, "variableInfo")
siteInfo <- attr(temperatureAndFlow, "siteInfo")

par(mar=c(5,5,5,5)) #sets the size of the plot window

plot(temperatureAndFlow$Date, temperatureAndFlow$Wtemp_Max,
  ylab=variableInfo$parameter_desc[1],xlab="" )
par(new=TRUE)
plot(temperatureAndFlow$Date, temperatureAndFlow$Flow,
  col="red",type="l",xaxt="n",yaxt="n",xlab="",ylab="",axes=FALSE
  )
axis(4,col="red",col.axis="red")
mtext(variableInfo$parameter_desc[2],side=4,line=3,col="red")
title(paste(siteInfo$station_nm,"2012"))
legend("topleft", variableInfo$param_units, 
       col=c("black","red"),lty=c(NA,1),pch=c(1,NA))

## ----label=readNWISuv, eval=FALSE-------------------------
#  
#  parameterCd <- "00060"  # Discharge
#  startDate <- "2012-05-12"
#  endDate <- "2012-05-13"
#  dischargeUnit <- readNWISuv(siteNumber, parameterCd,
#          startDate, endDate)
#  dischargeUnit <- renameNWISColumns(dischargeUnit)

## ----label=getQW, echo=TRUE, eval=FALSE-------------------
#  
#  # Dissolved Nitrate parameter codes:
#  parameterCd <- c("00618","71851")
#  startDate <- "1985-10-01"
#  endDate <- "2012-09-30"
#  
#  dfLong <- readNWISqw(siteNumber, parameterCd,
#        startDate, endDate)
#  
#  # Or the wide return:
#  # dfWide <- readNWISqw(siteNumber, parameterCd,
#  #       startDate, endDate, reshape=TRUE)
#  

## ----qwmeta, echo=TRUE, eval=FALSE------------------------
#  
#  comment(dfLong)
#  

## ----gwlexample, echo=TRUE, eval=FALSE--------------------
#  siteNumber <- "434400121275801"
#  groundWater <- readNWISgwl(siteNumber)

## ----peakexample, echo=TRUE, eval=FALSE-------------------
#  siteNumber <- '01594440'
#  peakData <- readNWISpeak(siteNumber)
#  

## ----ratingexample, echo=TRUE, eval=FALSE-----------------
#  ratingData <- readNWISrating(siteNumber, "base")
#  attr(ratingData, "RATING")
#  

## ----surfexample, echo=TRUE, eval=FALSE-------------------
#  surfaceData <- readNWISmeas(siteNumber)
#  

## ----label=getQWData, echo=TRUE, eval=FALSE---------------
#  specificCond <- readWQPqw('WIDNR_WQX-10032762',
#                  'Specific conductance','2011-05-01','2011-09-30')

## ----siteSearch, eval=FALSE-------------------------------
#  sites <- whatNWISsites(bBox=c(-83.0,36.5,-81.0,38.5),
#                        parameterCd=c("00010","00060"),
#                        hasDataTypeCd="dv")

## ----dataExample, eval=FALSE------------------------------
#  dischargeWI <- readNWISdata(service="dv",
#                             stateCd="WI",
#                             parameterCd="00060",
#                             drainAreaMin="50",
#                             statCd="00003")
#  
#  siteInfo <- attr(dischargeWI, "siteInfo")
#  

## ----NJChloride, eval=FALSE-------------------------------
#  
#  sitesNJ <- whatWQPsites(statecode="US:34",
#                         characteristicName="Chloride")
#  

## ----phData, eval=FALSE-----------------------------------
#  
#  dataPH <- readWQPdata(statecode="US:55",
#                   characteristicName="pH")
#  

## ----meta1, eval=FALSE------------------------------------
#  
#  attr(dischargeWI, "url")
#  
#  attr(dischargeWI, "queryTime")
#  
#  siteInfo <- attr(dischargeWI, "siteInfo")
#  

## ----meta2, eval=FALSE------------------------------------
#  
#  names(attributes(dischargeWI))
#  

## ----meta3, eval=FALSE------------------------------------
#  
#  siteInfo <- attr(dischargeWI, "siteInfo")
#  
#  variableInfo <- attr(dischargeWI, "variableInfo")
#  
#  

## ----meta5, eval=FALSE------------------------------------
#  comment(peakData)
#  
#  #Which is equivalent to:
#  # attr(peakData, "comment")

## ----helpFunc,eval = FALSE--------------------------------
#  ?readNWISpCode

## ----seeVignette,eval = FALSE-----------------------------
#  vignette(dataRetrieval)

## ----installFromCran,eval = FALSE-------------------------
#  install.packages("dataRetrieval")

## ----openLibraryTest, eval=FALSE--------------------------
#  library(dataRetrieval)

## ----label=getSiteApp, echo=TRUE, eval=FALSE--------------
#  availableData <- whatNWISdata(siteNumber, "dv")
#  dailyData <- availableData["00003" == availableData$stat_cd,]
#  
#  tableData <- with(dailyData,
#        data.frame(
#          shortName=srsname,
#          Start=begin_date,
#          End=end_date,
#          Count=count_nu,
#          Units=parameter_units)
#        )

## ----label=saveData, echo=TRUE, eval=FALSE----------------
#  write.table(tableData, file="tableData.tsv",sep="\t",
#              row.names = FALSE,quote=FALSE)

