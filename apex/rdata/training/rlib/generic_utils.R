#
# general purpose utils
#
closedevs <- function()
{
    while (dev.cur() > 1) { dev.off() }
}

closealldevs <- function()
{
    closedevs()
}

mysrc <- function(file)
{
    closealldevs()
    source(file=file, echo=TRUE, max.deparse.length=10000)
}

lnrow <- function(dfrm) 
{
    lapply(dfrm, nrow)
}

lncol <- function(dfrm) 
{
    lapply(dfrm, ncol)
}

lclass <- function(dfrm) 
{
    lapply(dfrm, class)
}

lhead <- function(dfrm) 
{
    lapply(dfrm, head)
}

lnames <- function(dfrm) 
{
    lapply(dfrm, names)
}
#
# estimate for e using monte-carlo. just choose a value for N.
#
# from R-bloggers
#
mc_e <- function(N=100000)
{
    1/mean(N*diff(sort(runif(N+1))) > 1)
}
#
# convert time string to unix time, and vice-versa
#
#	Code	Meaning			Code	Meaning
#	%a	Abbreviated weekday	%A	Full weekday
#	%b	Abbreviated month	%B	Full month
#	%c	Locale-specific 
#			date and time	%d	Decimal date
#	%H	Decimal hours (24 hour)	%I	Decimal hours (12 hour)
#	%j	Decimal day of the year	%m	Decimal month
#	%M	Decimal minute		%p	Locale-specific AM/PM
#	%S	Decimal second		%U	Decimal week of the year 
#						(starting on Sunday)
#	%w	Decimal Weekday 
# 			(0=Sunday)	%W	Decimal week of the year 
#						(starting on Monday)
#	%x	Locale-specific Date	%X	Locale-specific Time
#	%y	2-digit year		%Y	4-digit year
#	%z	Offset from GMT		%Z	Time zone (character)
#
datetime_to_tstamp <- function(datetime,
                               format = "%Y/%m/%d %H:%M:%S",
                               tz = Sys.timezone())
{
    return(as.numeric(strptime(datetime, format=format, tz=tz)));
}
#
tstamp_to_datetime <- function(tstamp,
                               format = "%Y/%m/%d %H:%M:%S",
                               tz = Sys.timezone())
{
    return(as.POSIXct(tstamp, origin="1970-01-01", tz=tz));
}
#
# list function which uses globs instead if regular expression
#
lf <- function(globpat="*",env.pos=1)
{
    return(ls(pattern=glob2rx(pattern=globpat),
              envir=as.environment(env.pos)))
}
#
