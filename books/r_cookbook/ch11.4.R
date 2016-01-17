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
# 


