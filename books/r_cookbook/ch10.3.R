#
# 10.12 - plotting a line through (x,y) points
#
# plot(x,y,type="l")
#
# if the data is stored in a 2-column dataframe, then you 
# can do this:
#
# plot(dfrm, type="l")
#
par(mfrow=c(1,3))
plot(pressure)
plot(pressure, type="l")
plot(pressure, type="l")
points(pressure)

#
# 10.13 - changing line type, width, or color.
#
# line type:
#
# lty="solid" or lty=1 (default)
#
# line width:
#
# color:
#
#
