suppressPackageStartupMessages(library(shiny))
suppressPackageStartupMessages(library(jsonlite))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(highcharter))
suppressPackageStartupMessages(library(magrittr))
suppressPackageStartupMessages(library(shinyWidgets))



source_list <- list.files("functions", full.names = TRUE)
for(file in source_list) source(file)
