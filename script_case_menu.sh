#!/bin/sh
clear
SALIR=0
OPCION=0
while [ $SALIR -eq 0 ]; do
    echo "Menu:"
    echo "1) Opcion 1"
    echo "2) Opcion 2"
    echo "3) Salir"
    echo "Opcion seleccionada: "
    read OPCION
    case $OPCION in
        1) 
            echo "Opcion 1 seleccionada" ;;
        2)
            echo "Opcion 2 seleccionada" ;;
        3)
            SALIR=1 ;;
        *)
            echo "Opcion erronea";;
    esac
done