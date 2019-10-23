#! /usr/bin/Rscript --vanilla
args <- commandArgs(trailingOnly = TRUE)
if(length(args)==0L)stop("STOP! Please supply an argument.")

if(!require("pacman"))install.packages("pacman")
pacman::p_load(here, tidyverse, fs)
dir_create(here("data", "settings"))
walk(seq_len(args[[1]]),
     ~cat(.x, file = here("data", "settings", paste0(.x, ".txt"))))
