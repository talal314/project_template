# Instalación de librerías

install.packages("tidyverse")
install.packages("readxl")
install.packages("igraph")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("readr")

if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("STRINGdb")
BiocManager::install("clusterProfiler")
BiocManager::install("org.Hs.eg.db")
BiocManager::install("AnnotationDbi")


