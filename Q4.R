######
# Jordan Bruner jbruner@usc.edu
# 10-21-16
# BISC481 Homework 3 - Question #4
######

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
fn_fasta <- paste0(workingPath, "Mad.txt.fa")
pred <- getShape(fn_fasta)

## Encode feature vectors
# if not including shape, remove 2nd parameter from function call on line 28
featureType <- c("1-mer", "1-shape")
featureVector <- encodeSeqShape(fn_fasta, pred, featureType)

## Build MLR model by using Caret
# Data preparation
fn_exp <- paste0(workingPath, "Mad.txt")
exp_data <- read.table(fn_exp)
df <- data.frame(affinity=exp_data$V2, featureVector)

# Arguments setting for Caret
trainControl <- trainControl(method = "cv", number = 10, savePredictions = TRUE)

# Prediction with L2-regularized
model <- train(affinity~., data = df, trControl=trainControl, 
                method = "glmnet", tuneGrid = data.frame(alpha = 0, lambda = c(2^c(-15:15))))

result <- model$results$Rsquared[1]
result

## record the result, then go to line 28 and remove the shape parameter to generate the model without shape
# then run the script from line 28 downwards to get the shapeless r^2
## after recording both models, go to lines 23 and 33 and change the name of the txt input according to the protein name
# then run the script from line 23 downwards to get the r^2 for that protein
