#!/bin/bash

cd /Users/inma/Desktop/Biologia/final/project_template
echo "El directorio se ha cambiado a /Users/inma/Desktop/Biologia/final/project_template"

echo "Instalemos las librerías de Python que vamos a utilizar:"
pip install mysql-connector
pip install python-csv
pip install os-sys
echo "Librerías de Python instaladas."

echo "Instalemos las librerías R que vamos a utilizar:"
Rscript code/libraries.R
echo "Librerías de R instaladas."