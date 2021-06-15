#!/bin/bash

if [ $# -ne 2 ]
then
    echo 'Tanto el patrón de búsqueda ($1) como el directorio ($2) deben ser ingresados al script "usogrep.sh" como argumentos.'
    echo -e '\tSintaxis:'
    echo -e '\t\tusogrep.sh ${Patrón_de_búsqueda} ${directorio}'
    exit 1
fi

# Patrón de búsqueda
PATRON=$1

# Directorio en donde buscar
DIRECTORIO=$2

# Búsqueda
grep -irq $PATRON "$DIRECTORIO"/*
# NOTA: Comando 'grep' selecciona y muestra las líneas de los archivos que coincidan con la cadena o patrón dados
#   -i  Ignora los cambios mayúsculas y minúsculas, las considera equivalentes.
#   -r  Lee iterativamente todos los archivos en los directorios y subdirectorios encontrados.
#   -q  Mostrar en modo silencioso, no muestra nada.
#   -l  Sólo el nombre de los ficheros que contienen las líneas seleccionadas se muestran por la salida estándar

if [ $? -eq 0 ]  # $?    Valor devuelto por el último comando. Si es 0 es que terminó correctamente
then
    LUGAR=$(grep -irl $PATRON "$DIRECTORIO"/*);
    echo "El patrón $PATRON fue localizado en $LUGAR";
else
    echo "No se encontró el patrón $PATRON en los archivos presentes dentro de $DIRECTORIO"
fi


