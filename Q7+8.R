######
# Jordan Bruner jbruner@usc.edu
# 10-25-16
# BISC481 Homework 3 - Questions #7+8
######

## install packages
install.packages("caret")
install.packages("e1071")
install.packages("ROCR")
biocLite("Biostrings")

## initialization
library(Biostrings)
library(DNAshapeR)
library(caret)
library(ROCR)
workingPath <- "/Users/jbruner/Downloads/BISC481-master/CTCF/"

## generate bound data
boundFasta <- readDNAStringSet(paste0(workingPath, "bound_500.fa"))
sequences <- paste(boundFasta)
boundTxt <- data.frame(seq=sequences, isBound="Y")

## generate unbound data
nonboundFasta <- readDNAStringSet(paste0(workingPath, "unbound_500.fa"))
sequences <- paste(nonboundFasta)
nonboundTxt <- data.frame(seq=sequences, isBound="N")

## merge datasets
writeXStringSet( c(boundFasta, nonboundFasta), paste0(workingPath, "ctcf.fa"))
exp_data <- rbind(boundTxt, nonboundTxt)

## DNAshapeR prediciton
pred <- getShape(paste0(workingPath, "ctcf.fa"))

## generate plots of DNA shape parameters using characteristics of pred variable (Question #7)
plotShape(pred$MGW)
# plotShape(pred$ProT)
# plotShape(pred$Roll)
# plotShape(pred$HelT)

## encode feature vectors
featureType <- c("1-mer", "1-shape")
featureVector <- encodeSeqShape(paste0(workingPath, "ctcf.fa"), pred, featureType)
df <- data.frame(isBound = exp_data$isBound, featureVector)

## logistic regression parameters
trainControl <- trainControl(method = "cv", number = 10, 
                             savePredictions = TRUE, classProbs = TRUE)

## model prediction
model <- train(isBound~ ., data = df, trControl = trainControl,
               method = "glm", family = binomial, metric ="ROC")
summary(model)

## plot ROC
prediction <- prediction( model$pred$Y, model$pred$obs )
performance <- performance( prediction, "tpr", "fpr" )
plot(performance)

## calculate AUROC
auc <- performance(prediction, "auc")
auc <- unlist(slot(auc, "y.values"))
auc
