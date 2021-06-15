#!/bin/sh

# Realizar un Shell Script de UNIX/Linux que simule el comando `find`. Podrá recibir de uno a tres parámetros:
# - En caso de ser uno, será el *fichero* a buscar en el *directorio actual*.
# - En caso de ser dos, será una de las siguientes opciones:
#    *  *Directorio* (ruta completa) y *fichero* a buscar en ella.
#    *  *Fichero* y opcion *“-s”*; buscará el fichero en la *ruta actual* y sus
# *subdirectorios*.
# - En caso de ser tres serán *directorio* (ruta completa), *fichero* y opcion *“-s”*; buscará
# el fichero en la ruta y sus subdirectorios. Ejemplos:
#    `Buscar fichero`
#    `Buscar directorio fichero`
#    `Buscar fichero -s`
#    `Buscar directorio fichero –s`

# Se valorará la eficiciencia y control de errores. No se podrá usar los comando `find` ni `ls`.

# Ejemplo de ejecución:
#   ./script_buscar.sh variables.sh -s
# Equivalente a:
#   find . -name 'variables*'

# Declaramos 3 variables que inicializaremos según el número de argumentos pasados
DIRECTORIO=
FICHERO=
OP_SUBD=

case $# in
    1)
        FICHERO="$1";
        DIRECTORIO=$(pwd);
        OP_SUBD=false; 
        ;;
    2)  
        if test "$2" = "-s"; then
            FICHERO="$1";
            DIRECTORIO=$(pwd);
            OP_SUBD=true;
        else
            FICHERO="$2";
            DIRECTORIO="$1";
            OP_SUBD=false;
        fi
        ;;
    3)
        FICHERO="$2";
        DIRECTORIO="$1";
        OP_SUBD=true;
        ;;
    *)
        echo "Número de parámetros incorrecto."
        exit 1;
esac

# Esto sería sin la opción de buscar en los subdirectorios

funcBuscar() {
    # Machacamos el valor de la variable DIRECTORIO con el parámetro pasado
    DIRECTORIO="$1"
    for VAR in "$DIRECTORIO"/*
    do
        if test -f "$VAR"; then
            # Comentar el "echo" de la siguiente línea si ya no se está depurando
            echo "Archivo regular: $VAR\t\tComparamos: ${VAR##*/} = $FICHERO";
            # "${VAR##*/}" Para quitar la parte de la ruta y dejar sólo el nombre del fichero
            if test "${VAR##*/}" = "$FICHERO"; then
                # Comentar el "echo" de la siguiente línea si ya no se está depurando
                echo "ENCONTRADO $FICHERO en $VAR";
                # Comentar el "echo" de la siguiente línea si ya no se está depurando
                echo "Pulse una tecla para salir...";
                read TECLA;
                exit 0;
            fi
        elif test -d "$VAR"; then
            echo "Directorio: $VAR";
            if test "$OP_SUBD" = "true"; then
                funcBuscar "$VAR";
            fi
        fi
    done
}

funcBuscar "$DIRECTORIO"