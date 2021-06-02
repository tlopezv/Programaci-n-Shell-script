#!/bin/sh
echo Hola
set -xv
if true; then
    echo hola2
    ls /
fi
set +xv