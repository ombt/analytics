#
# 11.12 - finding best power transformation (box-cox procedure)
#
# want to improve linear model by applying a power 
# transformation to the response variable.
#
# use box-cox procedure
#
# library(MASS)
# m <- lm(y ~ x)
# boxcox(m)
#
 
x <- 10:100
eps <- rnorm(length(x), sd=5)
y <- (x+eps)^(-1/1.5)

# model using linear (it's not of course).
m <- lm(y ~ x)
summary(m)

# plot is overloaded, so for a model argument is really calls,
# plot.lm(...) which has a "which" argument. do this to get
# the help text:
#
# > ?plot.lm
#
# which says:
#
#     Six plots (selectable by ‘which’) are currently available: a plot
#     of residuals against fitted values, a Scale-Location plot of
#     sqrt(| residuals |) against fitted values, a Normal Q-Q plot, a
#     plot of Cook's distances versus row labels, a plot of residuals
#     against leverages, and a plot of Cook's distances against
#     leverage/(1-leverage).  By default, the first three and ‘5’ are
#     provided.
#
#Usage:
#
#     ## S3 method for class 'lm'
#     plot(x, which = c(1:3, 5), 
#          caption = list("Residuals vs Fitted", "Normal Q-Q",
#            "Scale-Location", "Cook's distance",
#            "Residuals vs Leverage",
#            expression("Cook's dist vs Leverage  " * h[ii] / (1 - h[ii]))),
#          panel = if(add.smooth) panel.smooth else points,
#          sub.caption = NULL, main = "",
#          ask = prod(par("mfcol")) < length(which) && dev.interactive(),
#          ...,
#          id.n = 3, labels.id = names(residuals(x)), cex.id = 0.75,
#          qqline = TRUE, cook.levels = c(0.5, 1.0),
#          add.smooth = getOption("add.smooth"), label.pos = c(4,2),
#          cex.caption = 1)
##     
#Arguments:
#
#       x: ‘lm’ object, typically result of ‘lm’ or ‘glm’.
#
#   which: if a subset of the plots is required, specify a subset of the
#          numbers ‘1:6’.
#

par(mfrow=c(1,3))

plot(m, which=1)
library(MASS)

bc = boxcox(m)

which.max(bc$y)

lambda <- bc$x[which.max(bc$y)]
lambda

z <- y^lambda
z

m2 = lm(z ~ x)
summary(m2)
plot(m2, which=1)

# or

m2 = lm(I(y^lambda) ~ x)

#
# 11.13 - forming confidence intervals for regression coefficients.
#
# m <- lm(y ~ x1 + x2)
# confint(m)
#

x1 = 1:100
length(x1)
x2 = x1^2
length(x2)

y = 5*x1 + 8*x2 + 100 + rnorm(100, sd=100)

m = lm(y ~ x1 + x2)

m$coefficients

confint(m)
confint(m, level=0.99)

#
# 11.14 - plot residuals
#
# m <- lm(y ~ x)
# plot(m, which=1)
#
#

x1 = 1:100
length(x1)
x2 = x1^2
length(x2)

y = 5*x1 + 8*x2 + 100 + rnorm(100, sd=100)

m = lm(y ~ x1 + x2)

x11()
plot(m, which=1)




