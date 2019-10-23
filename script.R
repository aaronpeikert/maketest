#! /usr/bin/Rscript --vanilla
args <- commandArgs(trailingOnly = TRUE)
if(length(args)==0L)stop("STOP! Please supply an argument.")

if(!require("pacman"))install.packages("pacman")
pacman::p_load(here, tidyverse, fs)

num <- as.numeric(read_file(args[[1]]))
dir_create(here("data", "results"))
cat(num*2, file = here("data", "results", basename(args[[1]])))
