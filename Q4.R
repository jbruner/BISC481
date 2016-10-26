######
# Jordan Bruner jbruner@usc.edu
# 10-21-16
# BISC481 Homework 3 - Question #4
######

# 4a Use the DNAshapeR package to generate a feature vector
# for “1-mer” sequence model and a feature vector for “1-mer+shape”
# model with respect to the datasets of Mad, Max and Myc. 

## install packages
# Bioconductor
source("https://bioconductor.org/biocLite.R")
biocLite()
# DNAShapeR
biocLite("DNAshapeR")
# Caret
install.packages("caret")

## initialize
library(DNAshapeR)
library(caret)
workingPath <- "/Users/jbruner/Downloads/BISC481-master/gcPBM/"

## Predict DNA shapes
# enter protein name to read from correct txt file
fn_fasta <- paste0(workingPath, "Myc.txt.fa")
pred <- getShape(fn_fasta)

## Encode feature vectors
# if not including shape, remove 2nd parameter from function call
featureType <- c("1-mer")
featureVector <- encodeSeqShape(fn_fasta, pred, featureType)

## Build MLR model by using Caret
# Data preparation
fn_exp <- paste0(workingPath, "Myc.txt")
exp_data <- read.table(fn_exp)
df <- data.frame(affinity=exp_data$V2, featureVector)

# Arguments setting for Caret
trainControl <- trainControl(method = "cv", number = 10, savePredictions = TRUE)

# Prediction with L2-regularized
model <- train(affinity~., data = df, trControl=trainControl, 
                method = "glmnet", tuneGrid = data.frame(alpha = 0, lambda = c(2^c(-15:15))))

result <- model$results$Rsquared[1]
result

#record the result, then go to line 32 and remove the shape parameter to generate the model without shape
#after recording both models, go to line 27 and change the name of the txt input according to the protein name
#be sure to also change the correct name when reaching line 37 after changing line 27
