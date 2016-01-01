#
# general purpose utils
#
closedevs <- function()
{
    while (dev.cur() > 1) { dev.off() }
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
