### Getting and Cleaning Data Course Project

This repository contains the following files for my course project:
* ReadMe.md 
* run_analysis.R
* CodeBook.md

#### run_analysis.R

This is the R code that implements all the required steps in the assignment. This R code was developed under Windows 8 and under R version 4.0.2. The code assumes that the additionally required packages (`dplyr` and `reshape2`) are installed, however if they are not, they can be installed by the code below.

<!-- -->

    install.packages("dplyr")
    install.packages("reshape2")
    
Once these packages are installed and run_analysis.R is saved locally into your R working directory (if you don't know your working directory path you can get it by typing `getwd()` in the R console) the code can be executed in R for example with the following command.

    source("run_analysis.R")

The code will generate a folder called `data` in the working directory, if there is not one yet. This folder will be used to download the data and unzip it and the final dataset will be written into it as well (`./data/tidy_data.txt`).

In case if you want to read the final data back into R, that can be done by the code below:

    tidy_data <- read.table("./data/tidy_data.txt", header = TRUE, sep = "", check.names = FALSE)


#### CodeBook.md

This file describes the variables, the data, and any transformations or work that you I performed during the project.