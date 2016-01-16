#
# simple linear model
#
# yi = B0 + B0 + B1*Xi + ei
#
# given the data x,y.
#
# find best B0 and B1 which fit the data
#
# generalization.
#
# yi = B0 + b1*ui +b2*vi + b3*wi + ei
#
# u,v,w are predictors and y is the response
#
# build linear models using lm()
#
# returned object has bi's and statistics describing
# fit.
#
# some basic quesions:
#
# is the model statistically significant?
# check F statistic at the bottom of the summary.
#
# are the coefficients significant?
# check the t-statistics and the p-values in the summary, or check
# the confidence interval (recipe 11.13)
#
# is the model useful?
# check the R^2 near the bottom of the summary.
#
# does the model fit the data well?
# plot the residuals and check the regression diagnostics.
# recipes 11.14 and 11.15.
#
# does the data satisfy the assumptions behind a linear regression?
# check whether the diagnostics confirm that a linear model is reasonable
# for your data (recipe 11.13).
#
# ANOVA
#
# analysis of variance -
#
# regression creates models, but ANOVA evaluates the models.
#
# ANOVA is a family of techniques.
#
# one-way ANOVA:
#
# suppose you have data samples from several populations and you
# are wondering whether the populations have different means. 
# one-way ANOVA answers this question. 
#
# if the populations have normal distributions, then use the 
# oneway.test function (recipe 11.20); otherwise, use the
# nonparametric version, the kruskal.test function (recipe 11.23).
#
# model comparison:
#
# when you add or delete a predictor variable from a linear regression
# model, you want to know whether that change did or did not improve the
# model. the anova function compares two regression models and reports
# whether they are significantly different (recipe 11.24).
#
# ANOVA table:
#
# the anova function can construct the ANOVA table for a linear
# regression model, which includes the F statistic needed to 
# gauge the model's statistical significance (recipe 11.3). the
# important table is discussed in books on regression.
#
# refer to this PDF online.
#
# "Practical Regression and ANOVA using R" by Julian Faraway which
# is available at CRAN.
#

#
# 11.1 - preforming simple linear regression.
#
# you have two vectors, x, y containing points (xi, yi).
#
# do this:
#
# lm(y ~ x)
#

x = 1:20

y = 2*x + 20 + runif(20, min=-0.5, max=0.5)
model = lm(y ~ x)
model

y = 2*x + 20 + runif(20, min=-1.0, max=5)
model = lm(y ~ x)
model
# plot(model)

dfrm = data.frame(x=x,y=y)
dfrm

model = lm(y ~ x, data=dfrm)
model

#
# 11.2 - performing multiple linear regressions
#
# multiple predictor variable (u,v,w) and one respone variable y, and
# you want to perform a linear regression.
#
# do this:
#
# lm (y ~ u + v + w)
#

u = 1:20
v = seq(from=-100, to=100, length.out=20)
w = seq(from=-20, to=5, length.out=20)

y = 3*u + 4*v - w + runif(20, min=-0.2, max=0.2)

dfrm = data.frame(y=y, u=u, v=v, w=w)
dfrm

model = lm(y ~ u + v + w, data=dfrm)
model

# plot(model)

#
# 11.3 - getting regression statistics
#
# save results in a variable and use these functions
# to generate statistics:
#
# m = lm(y ~ u + v + w)
#
# anova(m)
# ANOVA table
#
# coefficients(m)
# model coefficients
#
# coef(m)
# same as above.
#
# deviance(m)
# residual sum of the squares.
#
# effects(m)
# vector of orthogonal effects
#
# fitted(m)
# vector of fitted y values.
#
# residuals(m)
# model residuals
#
# resid(m)
# same as above.
#
# summary(m)
# key statistics, such as R^2, F statistic, residual standard
# error (sigma).
#
# vcov(m)
# variance-covariance matrix of the main parameters
#


summary(model)
anova(model)
coefficients(model)
coef(model)
deviance(model)
effects(model)
fitted(model)
residuals(model)
resid(model)
vcov(model)

sqrt(sum((y-fitted(model))^2))

#
# 11.4 - understanding the regression summary
#
# summary(model)
#
# call:
# gives the model used in the regression.
#
# residuals statistics
# should be normally distributed. if the 1st Q is different
# from the 3rd Q, this indicates some skew. also the mean should
# be zero. if non-zero, then the curve is shifted.
#

u = 1:20
v = 1:20
w = 1:20

y = u + v*v + w*w*w + runif(20, min=-5, max=5)
y

dfrm = data.frame(y=y, u=u, v=v, w=w)
dfrm

model = lm(y~u+v+w, data=dfrm)
model
summary(model)

model = lm(y~u+v, data=dfrm)
model
summary(model)

model = lm(y~u, data=dfrm)
model
summary(model)

#
# Call:
#
# shows model used when calling lm().
#
# Residuals:
# 
# regression residuals should have a normal distribution with
# a mean of zero and Q1 and Q3 equidistant from the the mean.
#
# the sign of the median will show the skew of the distribution
# if any. 
#
# Coefficienst:
#
# will show each coefficient with the value derived using
# least-squares, also, t-value and Pr(>|t|) is shown. Pr values
# greater than 0.05 indicate the variable is NOT significant.
#
# flags:
# *** means 0<p<0.001
# ** means 0.001<p<0.01
# * means 0.01<p<0.05
# . means 0.05<p<0,1
# (blank) means 0.1<p<1.0
#
# residual standard error:
#
# standard deviation of rhe residuals.
#
# R^2 (coefficient of determinination)
#
# measure of model quality. bigger is better.
# use adjusted value.
#
# F statistic -
#
# model is significant of any of the coefficients is non-zero.
#

#
# 11.5 - performing a linear regression with out an intercept.#
#
# do this:
# lm(y ~ x + 0)
#
# yes, give lm) a zero to suppress the constant term.
#

x = 1:20
y = x*x

model = lm(y ~ x + 0)
model

summary(model)

#
# 11.6 - performing linear regression with interaction terms.
#
# lm(y ~ u*v)
#
# uses model
#
# yi = b1 + b1*ui + b2+vi + b3*ui*vi
#
# b3*ui*vi is called the interaction term.
#
# y ~ u*v*w
#
# use this model:
#
# yi = b0 + 
#      b1ui + b2vi + b3wi + 
#      b4uivi + b5uiwi + b6viwi + +
#      b7uiviwi + ei
#
# y ~ u + v + w + u:v:w
#
# uses this model:
#
# yi = b0 + b1ui + b2vi + b3wi + b4uiviwi + ei
#
# many different formulas can be defined.
#
# (u + v + ... + w)^2
#
# use all variables and their interaction terms,
#
# (u + v + ... + w)^3 
#
# use all variables, 1st order and 2nd order interactions.
#
# etc.
#
# x*(u + v + ... + w)
#
# same as x*u + x*v + ... + x*w and 
# same as x + u + v + ... + w + x:u + x:v ... x:w
#
# x:(u + v + ... w) 
#
# same as x:u + x:v + ... + x:w
#
# these are all the same:
#
# y ~ u*v
# y ~ u + v + u:v
# y ~ (u + v)^2
#
# all define this:
#
# yi = b0 + b1ui + b2vu +b3uivi + ei
#
#
#
# 
