#!/bin/sh
echo \S@=$@
echo \$*=$*
echo \$0=$0
echo \$1=$1
echo \$2=$2
echo Cambio parametros posicionales
set uno dos tres
echo \$1=$1
echo \$2=$2
echo Desplazo
shift
echo \$1=$1
echo \$2=$2
echo \$-=$-
echo \$#=$#
echo \$?=$?
firefox &
ps w
echo \$$=$$
echo \$!=$!

# $- imprime El conjunto actual de opciones en su Shell actual.

# himBH significa que las siguientes opciones están habilitadas:

# H - histexpand
# m - monitor
# h - hashall
# B - braceexpand
# i - interactive