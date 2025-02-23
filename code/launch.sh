#!/bin/bash

cd /Users/inma/Desktop/Biologia/final/project_template
echo "El directorio se ha cambiado a /Users/inma/Desktop/Biologia/final/project_template"

echo "1. Mapeamos las proteínas humanas en String y sacamos un fichero con los ID de las proteínas, filtrando con combined_score > 900"
Rscript code/redString.R results/proteinas_humanas.xlsx results/human_proteins.txt
echo "Archivo results/human_proteins.txt creado"

echo "2. Transformamos el ID de las proteínas a Uniprot, para usarlos en Chembl DB"
Rscript code/convertirUniprot.R results/human_proteins.txt results/human_proteins_uniprot.txt
echo "Archivo results/human_proteins_uniprot.txt creado"

echo "3. Buscamos en Chembl los fármacos asociados a estas proteínas"
python3 code/consultarChembl.py results/human_proteins_uniprot.txt 4 results/farmacos_aprobados.csv
python3 code/consultarChembl.py results/human_proteins_uniprot.txt 3 results/farmacos_experimentales.csv
echo "Archivos results/farmacos_aprobados.csv y results/farmacos_experimentales.csv creados"

echo "4. Análisis de los resultados"
Rscript code/analisisResultados.R results/farmacos_aprobados.csv aprobados
Rscript code/analisisResultados.R results/farmacos_experimentales.csv experimentales
echo "Imágenes y gráficas creadas"