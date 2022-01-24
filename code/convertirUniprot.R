args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("Necesita el archivo de red como argumento", call.=FALSE)
}else if (length(args)==1) {
  stop("Necesita nombre del fichero de salida como argumento", call.=FALSE)
}

library(readr)

proteinas_entrada <- args[1]
fichero_salida <- args[2]

data <- read_table(proteinas_entrada, col_names = FALSE)
colnames(data)[1] <- "GENENAME"

convertir <- function(gene_uniprot) {
  require(clusterProfiler)
  require(org.Hs.eg.db)
  gnm <-tryCatch(bitr(gene_uniprot, fromType="ALIAS", toType="UNIPROT", OrgDb="org.Hs.eg.db"),error=function(e){NA})
  gnm <- tryCatch(if(!is.na(gnm)){gnm <- gnm$UNIPROT},error=function(e){NA})
  
  return(as.character(gnm[1]))
}

data$UNIPROT <- sapply(data$GENENAME, convertir)

write.table(data$UNIPROT, fichero_salida, quote = FALSE, row.names = FALSE, col.names = FALSE)


