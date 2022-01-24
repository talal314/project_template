args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("Necesita el archivo de red como argumento", call.=FALSE)
}else if (length(args)==1) {
  stop("Necesita nombre del fichero de salida como argumento", call.=FALSE)
}

library(tidyverse)
library(readxl)
library(igraph)
library(STRINGdb)
library(dplyr)
library("AnnotationDbi")
library("org.Hs.eg.db")
set.seed(23094)


proteinas_entrada <- args[1]
fichero_salida <- args[2]

#funciones
plot_graph <- function(graph, vertex_color="tomato"){
  V(graph)$label <- NA
  V(graph)$name <- NA
  V(graph)$size <- degree(graph)/10
  E(graph)$edge.color <- "gray80"
  E(graph)$width <- .2
  V(graph)$color <- vertex_color
  graph_attr(graph, "layout") <- layout_with_lgl
  plot(graph)
}

# Lectura del excel con los datos de las proteínas del interactoma
df_original <- read_excel(proteinas_entrada)

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

# mapeo de las proteínas de nuestro interactoma
protein_mapped <- string_db$map(df, "PreyGene", removeUnmappedRows = TRUE ) 

# encontrar la subred con las interacciones
hits <- protein_mapped$STRING_id
hits.network <- string_db$get_subnetwork(hits)
# plot the graph
png("resultados/01_plot_hits.png")
plot_graph(hits.network, 10)
dev.off()

# obtener el peso de las relaciones entre las proteinas
interactions <- string_db$get_interactions(hits)

# filtrar a 900, para reducir el numero de proteinas
interactions_filtered <- interactions[interactions$combined_score > 900,] 

# sacar las proteinas de cada columna, y ponerlas juntas, sin que se repitan
from <- as.data.frame(interactions_filtered$from)
from <- from[!duplicated(from),]

to <- as.data.frame(interactions_filtered$to)
to <- to[!duplicated(to),]

proteins_string <- as.data.frame(append(from, to))
proteins_string <- proteins_string[!duplicated(proteins_string),]

# transformar a genename
proteins <- c()
for (i in 1:length(proteins_string)){
  prot <- as.character(protein_mapped[protein_mapped$STRING_id==proteins_string[i],1])
  proteins <- c(proteins, prot)
}

# guardar la lista de proteinas
write.table(proteins, fichero_salida, quote = FALSE, row.names = FALSE, col.names = FALSE)











