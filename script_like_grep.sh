#!/bin/sh

# Realizar un Shell Script de UNIX/Linux que simule el comando `grep`. Podrá recibir de uno a dos parámetros:
# - En caso de ser uno, será el *patron* a buscar en los ficheros del *directorio actual*.
# - En caso de ser dos, será como primer parámetro el "patron" a buscar y como segundo:
#    *  *fichero* en dónde buscar dicho patrón.
#    *  *directorio* en cuyos ficheros aunque esté en subdirectorios buscar dicho patrón

# Se valorará la eficiciencia y control de errores. No se podrá usar los comando `grep` ni `ls`.

# Ejemplo de ejecución:
#   ./script_like_grep.sh case aplicacion/
# Equivalente a:
#   grep -r case ./

# Declaramos 3 variables que inicializaremos según el número de argumentos pasados

PATRON=$1
DIRECTORIO=
FICHERO=

# Comprobamos que mínimo se ha pasado el patron
if [ $# -lt 1 ]
then
    echo "Número de parámetros incorrecto, mínimo hay que pasar 1 que será el patrón de búsqueda";
    echo -e "\tSíntasis:";
    echo -e "\t\t./script_like_grep.sh [patron]";
    echo -e "\t\t./script_like_grep.sh [patron] [fichero_OR_directorio]";
    exit 1;
fi

case $# in 
    1)
        PATRON="$1";
        DIRECTORIO=$(pwd);
        ;;
    2)
        PATRON="$1";
        if [ -d $2 ]
        then
            DIRECTORIO=$2;
        elif [ -f $2 ]
        then
            ARCHIVO=$2;
        else
            echo "El parametro \"$2\" no es ni un archivo ni un directorio, por favor vuelva a ejecutar el comando";
            exit 1;
        fi
        ;;
    *)
        echo "Este comando sólo admite como máximo 2 parámetros.";
        echo -e "\tSíntasis:";
        echo -e "\t\t./script_like_grep.sh [patron]";
        echo -e "\t\t./script_like_grep.sh [patron] [fichero_OR_directorio]";
        exit 1;
esac

funcBuscarPatronEnFich(){
    #echo "Inicio funcBuscarPatronEnFich >> \$1: $1";
    # Machacamos el valor de la variable ARCHIVO por el parámetro pasado en esta función
    ARCHIVO=$1;
    # Indicaremos el número de línea
    NUM_LINEA=0;
    #Leemos el fichero línea a línea
    while read LINEA
    do
        #guardamos el número de palabras de la línea para ir comparando cada una con el patrón
        #$NUM_PAL=$(echo $LINEA | wc -w);
        # NO hace falta
        # Actualizamos el número de línea
        NUM_LINEA=$(($NUM_LINEA+1));
        #echo "\$LINEA=$LINEA";
        #echo "\$NUM_LINEA=$NUM_LINEA";
        # Vamos comparando cada palabra de la línea actual con el patrón buscado
        for PALABRA in $LINEA
        do
            # Utilizamos variables auxiliares, para pasar tanto el patrón como la palabra tratada a minusculas antes de compararlas
            AUX_PAT=$(echo $PATRON | tr [:upper:] [:lower:]);
            AUX_PAL=$(echo $PALABRA | tr [:upper:] [:lower:]);
            #echo "Comparamos: $AUX_PAT = $AUX_PAL"
            if [ "$AUX_PAT" = "$AUX_PAL" ]
            then
                echo -e "\tEncontrado $PATRON en $ARCHIVO : línea $NUM_LINEA >> $LINEA";
            fi 
        done
    done < $ARCHIVO
    #echo "FIN funcBuscarPatronEnFich >> \$1: $1";
}

funcRecorrerDir(){
    #echo "Inicio funcRecorrerDir >> \$1: $1"
    # Machacamos el valor de la variable DIRECTORIO por el parámetro pasado en esta función
    DIRECTORIO=$1;
    for FILE in "$DIRECTORIO"/*
    do
        if [ -f $FILE ]
        then
            funcBuscarPatronEnFich $FILE
        elif [ -d $FILE ]
        then
            funcRecorrerDir $FILE
        fi
    done
    #echo "FIN funcRecorrerDir >> \$1: $1"
}

if [ "$DIRECTORIO" = "" ]
then
    funcBuscarPatronEnFich $ARCHIVO
else
    funcRecorrerDir $DIRECTORIO
fi