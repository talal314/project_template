args = commandArgs(trailingOnly=TRUE)

# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("Necesita el archivo de red como argumento", call.=FALSE)
}else if (length(args)==1) {
  stop("Necesita nombre del fichero de salida como argumento", call.=FALSE)
}

library(ggplot2)

farmacos <- args[1]
tipo <- args[2]

farmacos <- read.csv("results/farmacos_aprobados.csv", sep = ",")

# obtenemos el dataframe de los farmacos sin repeticiones
farmacos <- unique(farmacos[ , ])

# creamos un fichero con la lista de estos farmacos
write.table(farmacos$compound_name, paste("results/02_lista_farmacos_",tipo,".txt", sep = ""), quote = FALSE, row.names = FALSE, col.names = FALSE)

# evaluamos el tipo de los farmacos
farmacos_type <- farmacos$action_type
farmacos_exprementales_type <- farmacos_exprementales$action_type

# guardamos el diagrama
png(paste("results/03_tipo_farmacos_", tipo, ".png", sep = ""))
ggplot(data.frame(farmacos_type), aes(x=farmacos_type, fill = farmacos_type)) +
  xlab(paste("Tipo de los fármacos ",tipo)) +
  geom_bar()
dev.off()
