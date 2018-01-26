library(plyr)

#Retrieve Data

data.adult <- read.csv("http://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data", header = F, strip.white = T)

names(data.adult) <- c("age", "workclass", "fnlwgt", "education", "education.num", "marital.status", "occupation", "relationship", "race", "sex", "capital.gain", "capital.loss", "hours.per.week", "native.country","earnings")

data.adult$fnlwgt <- NULL
data.adult$relationship <- NULL
data.adult$native.country <- NULL
data.adult$capital.loss <- NULL
data.adult$capital.gain <- NULL

#Recode workclass

data.adult$workclass <- mapvalues(data.adult$workclass,
                                  from = c("Federal-gov","Local-gov", "State-gov",
                                           "Self-emp-inc", "Self-emp-not-inc",
                                           "Never-worked", "Without-pay", "?"),
                                  to = c(rep("Government",3), rep("Self-employed",2), rep("No-sallary",2), NA))

#Recode marital.statuss

data.adult$marital.status <- mapvalues(data.adult$marital.status,
                                  from = c("Married-AF-spouse","Married-civ-spouse",
                                           "Divorced","Married-spouse-absent", "Separated"),
                                  to = c(rep("Married",2), rep("Divorced/Separated",3)))


#Recode occupation

data.adult$occupation <- mapvalues(data.adult$occupation, from = "?", to = NA)

#Recode race

data.adult$race <- mapvalues(data.adult$race, from = "Amer-Indian-Eskimo", to = "Other")

#Merge education and education.num

unique.education <- unique(data.adult[,c("education.num","education")])
levels.ordered <- as.character(unique.education$education[order(unique.education$education.num)])

data.adult$education <- as.factor(data.adult$education.num)

levels(data.adult$education) <- levels.ordered

data.adult$eduaction.num <- NULL


#Save data

# save(data.adult, file = "Path_to_application/rawdata_adult.rda")
save(data.adult, file = "rawdata_adult.rda")
