library(tidyverse)
library(readxl)
library(igraph)
library(STRINGdb)
library(dplyr)
library("AnnotationDbi")
library("org.Hs.eg.db")
set.seed(23094)

# Lectura del excel con los datos de las proteínas del interactoma
df <- read_excel("proteinas_humanas.xlsx")

# Ajuste del dataframe para su uso
colnames(df) <- df[1,]
df <- df[-1,]

# Añadir columna con el ENSEMBL ID
df$ensid = mapIds(org.Hs.eg.db,
                  keys=df$PreyGene, 
                  column="ENSEMBL",
                  keytype="SYMBOL",
                  multiVals="first")

# carga de la red de proteinas humans
string_db <- STRINGdb$new(version="11", species=9606, score_threshold=400, input_directory="" )

# mapeo de las proteínas de nuestro interactoma
protein_mapped <- string_db$map(df, "ensid", removeUnmappedRows = TRUE ) ## ERROR: numero incorrecto de dimensiones

# obtener el peso de las relaciones entre las proteinas


# filtrar a 900, para reducir el numero de proteinas








