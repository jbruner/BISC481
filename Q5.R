######
# Jordan Bruner jbruner@usc.edu
# 10-21-16
# BISC481 Homework 3 - Question #5
######

## install packages and initialize
install.packages("ggplot2")
install.packages("grid")
library(ggplot2)
library(grid)

## plot visual theme/details
my.theme <- theme(
  plot.margin = unit(c(0.1, 0.5, 0.1, 0.1), "cm"),
  axis.text = element_text(colour="black", size=12),
  axis.title.x = element_text(colour="black", size=12),
  axis.title.y = element_text(colour="black", size=12),
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  panel.background = element_blank(),
  axis.line = element_line(colour = "black"),
  axis.text = element_text(colour ="black"),
  axis.ticks = element_line(colour = "black")
)

## enter data from Question #4 answers with 1-mer model results as data1 values 
# on the X-axis and 1-mer+shape results as data2 values on the Y-axis
data1 <- c(0.7752518, 0.785396, 0.7777121)
data2 <- c(0.8626773, 0.8642745, 0.8545602)

## generate the plot
ggplot() +
  geom_point(aes(x = data1, y = data2), color = "red", size=1) +
  geom_abline(slope=1) + geom_vline(xintercept=0) + geom_hline(yintercept=0) +
  coord_fixed(ratio = 1, xlim = c(0,1), ylim = c(0,1)) +
  scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0)) +
  my.theme
