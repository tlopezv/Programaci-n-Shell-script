#!/bin/sh

suma () {
    C=$(($1+$2))
    echo "Suma: $C"
    return $C
    echo "No llega"
}

suma 1 2
suma $1 $2 #suma los 2 primeros argumentos
echo "Valor devuelto: " $?