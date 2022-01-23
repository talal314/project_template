library(tidyverse)
library(readxl)
library(igraph)
library(STRINGdb)
library(dplyr)
library("AnnotationDbi")
library("org.Hs.eg.db")
set.seed(23094)

# Lectura del excel con los datos de las proteínas del interactoma
df_original <- read_excel("results/proteinas_humanas.xlsx")

# Ajuste del dataframe para su uso
colnames(df_original) <- df_original[1,]
df_original <- df_original[-1,]
df <- as.data.frame(df_original[,3])

# Añadir columna con el ENSEMBL ID
df$ensid = mapIds(org.Hs.eg.db,
                  keys=df$PreyGene, 
                  column="ENSEMBL",
                  keytype="SYMBOL",
                  multiVals="first")

# carga de la red de proteinas humans
string_db <- STRINGdb$new(version="11", species=9606, score_threshold=400, input_directory="" )
#string.network <- string_db$get_graph()

# mapeo de las proteínas de nuestro interactoma
protein_mapped <- string_db$map(df, "PreyGene", removeUnmappedRows = TRUE ) 

# encontrar la subred con las interacciones
hits <- protein_mapped$STRING_id
#hits.network <- string_db$get_subnetwork(hits)

# obtener el peso de las relaciones entre las proteinas
interactions <- string_db$get_interactions(hits)

# filtrar a 900, para reducir el numero de proteinas
interactions_filtered <- interactions[interactions$combined_score > 900,] 

# sacar las proteinas de cada columna, y ponerlas juntas, sin que se repitan
from <- as.data.frame(interactions_filtered$from)
from <- from[!duplicated(from),]

to <- as.data.frame(interactions_filtered$to)
to <- to[!duplicated(to),]

proteins <- as.data.frame(append(from, to))
proteins <- proteins[!duplicated(proteins),]

# guardar la lista de proteinas
write.table(proteins, "results/human_proteins.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)











