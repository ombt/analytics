#
# 11.7 - selecting the best regression variables
#
x <- 1:50
y <- 5*x + 10 + rnorm(50, mean=0, sd=1)
xy.data <- data.frame(y=y, x=x)

m = lm(y ~ x, data=xy.data)
m

summary(m)


u <- 1:50
v <- (1:50)^2
y <- 5*u + 8*v + 10 + rnorm(50, mean=0, sd=1)
uvy.data <- data.frame(y=y, u=u, v=v)
uvy.data 

m = lm(y ~ u + v, data=uvy.data)
m

summary(m)

u <- 1:50
v <- (1:50)^2
w <- (1:50)^3
y <- 5*u + 8*v + 3*w + 10 + rnorm(50, mean=0, sd=50)

uvwy.data <- data.frame(y=y, u=u, v=v, w=w)
uvwy.data 

m = lm(y ~ u + v + w, data=uvwy.data)
m

summary(m)

u <- 1:50
v <- (1:50)^2
w <- (1:50)^3
#
# y <- 5*u + 8*v + 3*w + 10 + rnorm(50, mean=0, sd=50)
#
# remove w and check the significance
#
# y <- 5*u + 8*v + 3*w + 10 + rnorm(50, mean=0, sd=50)
y <- 5*u + 8*v + 10 + rnorm(50, mean=0, sd=50)

uvwy.data <- data.frame(y=y, u=u, v=v, w=w)
uvwy.data 

m = lm(y ~ u + v + w, data=uvwy.data)
m

summary(m)

# use the above to test selecting the best regression model
#
u <- 1:50
v <- (1:50)^2
w <- (1:50)^3
#
# remove w and check the significance
# y <- 5*u + 8*v + 3*w + 10 + rnorm(50, mean=0, sd=50)
#
y <- 5*u + 8*v + 10 + rnorm(50, mean=0, sd=50)

uvwy.data <- data.frame(y=y, u=u, v=v, w=w)
uvwy.data 

full.model <- lm(y ~ u + v + w, data=uvwy.data)
full.model
summary(full.model)

reduced.model <- step(full.model, direction="backward")
reduced.model
summary(reduced.model)


# use the above to test selecting the best regression model
#
u <- 1:50
v <- (1:50)^2
w <- (1:50)^3
#
# remove w and check the significance
# y <- 5*u + 8*v + 3*w + 10 + rnorm(50, mean=0, sd=50)
#
y <- 5*u + 8*v + 10 + rnorm(50, mean=0, sd=50)

uvwy.data <- data.frame(y=y, u=u, v=v, w=w)
uvwy.data 

min.model <- lm(y ~ 1, data=uvwy.data)
min.model
summary(min.model)

fwd.model <- step(min.model, 
                  direction="forward",
                  scope = " ~ u + v + w")
fwd.model
summary(fwd.model)

#
# 11.8 - regressing a subset of the data
#
# use lm() subset parameter to select part of the data
# set for regression.
#

u <- 1:50
v <- (1:50)^2
w <- (1:50)^3
loc <- c(rep("NJ",25), rep("IL", 25))

y <- 5*u + 8*v + 3*w + 10 + rnorm(50, mean=0, sd=50)

uvwy.data <- data.frame(y=y, u=u, v=v, w=w, loc=loc)
uvwy.data 

model <- lm(y ~ u + v + w, data=uvwy.data, subset=1:10)
model
summary(model)

model <- lm(y ~ u + v + w, data=uvwy.data, subset=1:25)
model
summary(model)

model <- lm(y ~ u + v + w, data=uvwy.data, subset=1:40)
model
summary(model)

logical.loc = uvwy.data$loc == "NJ"
model <- lm(y ~ u + v + w, data=uvwy.data, subset=logical.loc)
model
summary(model)

logical.loc = uvwy.data$loc == "IL"
model <- lm(y ~ u + v + w, data=uvwy.data, subset=logical.loc)
model
summary(model)

model <- lm(y ~ u + v + w, data=uvwy.data, subset=(loc=="NJ"))
model
summary(model)

model <- lm(y ~ u + v + w, data=uvwy.data, subset=(loc=="IL"))
model
summary(model)

#
# 11.9 - using an expression inside a regression formula
#
# use I(...)
#
# if you want to calculate this:
#
# yi = b0 + b1(ui + vi) + ei
#
# how would you write it?
#
# lm(y ~ u + v) ???
#
# No.
#
# yi = b0 + b1ui + b2ui^2 + ei
#
# try this:
#
# lm(y ~ u + u^2)
#
# no. this is an interaction term.
#
# gotta use I(...) operator.
#
# for:
# yi = b0 + b1(ui + vi) + ei
#
# use:
# lm(y ~ I(u + v))
#
# for:
# yi = b0 + b1ui + b2u1^2 + ei
#
# use:
# lm(y ~ u + I(u^2))
#
# all operators *,/,-,+,^ have special meanings in a
# regression expression, so you must use I(...) to
# escape the special meaning.
#

u <- 1:50
y <- 10 + u + u^2 + rnorm(50, mean=0, sd=1)

m <- lm(y ~ u + I(u^2))
m

summary(m)

predict(m, newdata=data.frame(u=51:60))

#
# 11.10 - regressing on a polynomial
#
# for example,
#
# lm(y ~ poly(x,3,raw=TRUE))
#
# regresses on this:
#
# yi = b0 + b1xi + b2xi^2 + b3xi^3 + ei
#
# lm(y ~ poly(x,3,raw=TRUE))
#
# is the same as:
#
# lm(y ~ x + I(x^2) + I(x^3))
#
# easier to use poly(...)
#

u <- 1:50
y <- 10 + u + u^2 + u^3 + rnorm(50, mean=0, sd=1)

m <- lm(y ~ u + I(u^2) + I(u^3))
m

m <- lm(y ~ poly(u,3,raw=TRUE))
m

# the two resuls above should be the same
# ... they are ...
#

#
# 11.11 - regressing on transformed data.
#
# suppose you want to use log(), then you can do
# this:
#
# lm(log(y) ~ x)
#
# if the model is:
#
# z = exp(b0 + b1t + e)
#
# then use:
#
# log(z) = b0 + b1t + e
#
# and this use this:
#
# m <- lm(log(z) ~ t)
#
# you can also do this:
#
# lm(sqrt(y) ~ x)
# lm(y ~ log(x))
# lm(log(y) ~ log(x))
#

x = 1:30
y = x*x

m1 = lm(y ~ x)
m1

m2 = lm(sqrt(y) ~ x)
m2

m3 = lm(log(y) ~ log(x))
m3

#

