#
# 11.17 - testing residuals for autocorrelation 
#         (durbin-watson test)
#
# library(lmtest)
# 
# m <- lm(y ~ x)
# 
# dwtest(m)
# 
# if p < 0.05, then the residuals are correlated.
# if p > 0.05, then the residuals are not correlated.
#
# perform visual test using:
#
# acf(m)
#

library(lmtest)

x <- 1:101
y <- x[1:100] - x[2:101]

m <- lm(y ~ x[1:100])
m

summary(m)

dwtest(m)

# acf(m)

dwtest(m, alternative="two.sided")

#
# 11.18 - predicting new values from model
#
# m <- lm(y ~ u + v + w)
# preds <- data.frame(u=3.1, v=4.0, w=5.5)
# predict(m, newdata=preds)
#

u = 1:100
v = u^2
w = u^3

y = 3*u + 4*v +5*w + rnorm(100, sd=10)

m = lm(y ~ u + v + w)

u = 110:120
v = u^2
w = u^3

predict(m, newdata=data.frame(u=u,v=v,w=w))

#
# 11.19 - forming prediction intervals
#
# predicts confidence intervals for values generated using
# linear model.
#

# defaults to 95%
predict(m, newdata=data.frame(u=u,v=v,w=w), interval="prediction")

# using 99%
predict(m, 
        newdata=data.frame(u=u,v=v,w=w), 
        interval="prediction",
        level=0.99)

# if the response variable is NOT normally distributed, then
# use boostrap method (recipe 13.8)
#

#
# 11.20 - performing one-way anova
#
# data are divided into groups and are normally distributed. you
# want to test if the groups have significantly different means.
#
# use a factor to define groups:
#
# oneway.test(x ~ f)
#
# p < 0.05 means some of the groups have different means.
# p > 0.05 means no evidence to assume different means.
#
# this test assumes the variances are NOT the same.
# if the assumpion of the variances being the same is made,
# then you can use aov().

df1 = data.frame(x=(rnorm(100,mean=100,sd=5)+rnorm(100,sd=1)),
                 y="first")
df2 = data.frame(x=(rnorm(100,mean=105,sd=5)+rnorm(100,sd=1)),
                 y="second")
df3 = data.frame(x=(rnorm(100,mean=100,sd=5)+rnorm(100,sd=1)),
                 y="third")

df = rbind(df1,df2,df3)

df$y = as.factor(df$y)

oneway.test(x ~ y, data=df)

# try the same mean but with a large error term
df4 = data.frame(x=(rnorm(100,mean=100,sd=5)+rnorm(100,sd=50)),
                 y="fourth")

df = rbind(df1,df2,df4)

df$y = as.factor(df$y)

oneway.test(x ~ y, data=df)

# try the same mean but with a large error term off center
df5 = data.frame(x=(rnorm(100,mean=100,sd=5)+rnorm(100,mean=1,sd=2)),
                 y="fifth")
df = rbind(df1,df2,df5)
df$y = as.factor(df$y)
oneway.test(x ~ y, data=df)

df5 = data.frame(x=(rnorm(100,mean=102,sd=5)+rnorm(100,mean=5,sd=2)),
                 y="fifth")
df = rbind(df1,df2,df5)
df$y = as.factor(df$y)
oneway.test(x ~ y, data=df)

df = rbind(df1,df3)
df$y = as.factor(df$y)
oneway.test(x ~ y, data=df)

# assume the variances are the same
#

df1 = data.frame(x=(rnorm(100,mean=100,sd=5)+rnorm(100,sd=2)),
                 y="first")
df2 = data.frame(x=(rnorm(100,mean=105,sd=5)+rnorm(100,sd=1)),
                 y="second")
df3 = data.frame(x=(rnorm(100,mean=100,sd=5)+rnorm(100,sd=3)),
                 y="third")

df = rbind(df1,df2,df3)
df$y = as.factor(df$y)
m <- aov(x ~ y, data=df)
m
summary(m)

#
# 11.21 - creating interaction plot
#
# using a linear model, but changing one predictor can affect the
# value of another predictor. this is a non-linear affect even
# when the dependences are lineat since the predictors are NOT
# independent.
#
# library(faraway)
# data(rats)
# interaction(rats$poison, rats$treat, rats$time)
#

library(faraway)
data(rats)
interaction.plot(rats$poison, rats$treat, rats$time)

# the lines should be parallel. if not, then there may be an
# interaction. you still need to run a test though.

#
# 11.22 - finding differences between means of groups
#
# you have data divided into groups and ANOVA indicates the
# means are significantly different. you want to know the 
# differences in the means.
#
# m <- aov(x ~ f)
# TukeyHSD(m)
#
# p-values near zero mean the means are different.
#
# you can plot the results:
#
# plot(TukeyGSD(m))
#
# differences which do not contain zero in there confidence interval
# can be significant.
#

x11()

df = rbind(df1,df2,df3)
df$y = as.factor(df$y)
m <- aov(x ~ y, data=df)
m

tm <- TukeyHSD(m)
tm

plot(tm)

#
# 11,23 - robust ANOVA (kruskak-wallis test)
#
# data in groups and not normally distrivuted. you want to know if
# group medians are different. the data should have similar shapes.
#
# create a factor to separate the data and use this test which
# does NOT depend on normality.
#
# kruskal.test(x ~ f)
#
# p-value less than 0.05 means the means are different.
#

df4 = data.frame(x=(runif(100,min=50,max=150)+rnorm(100,sd=3)),
                 y="fourth")

df = rbind(df1,df2,df3,df4)
df$y = as.factor(df$y)

kruskal.test(x ~ y, data=df)

#
# 11.24 - comparing models by using ANOVA.
#
# m1 = lm(y ~ u)
# m2 = lm(y ~ u + v)
# m3 = lm(y ~ u + v + w)
#
# anova(m1,m2)
# anova(m2.m3)
#
# p < 0.05 means the models are different, that is, the 
# explanatory value is different.
#
# add terms to model, then run ANOVA. if the p-valud indicates
# the difference is not significant, then the extra terms have
# no extra explanatory value and they should not be included in
# the final model.
#

u = 1:100
v = u^2
w = u^3

y = u + 2*v + 3*w + rnorm(100,sd=5)

m1 = lm(y ~ u)
m2 = lm(y ~ u + v)
m3 = lm(y ~ u + v + w)
m4 = lm(y ~ w)
m5 = lm(y ~ v + w)

anova(m1,m2)
anova(m1,m3)
anova(m1,m4)
anova(m4,m5)
anova(m4,m3)

