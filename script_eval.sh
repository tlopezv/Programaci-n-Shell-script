#ejemplo de referencia indirecta con eval
VAR="Texto"
REF=VAR             #REF es una variable que vale VAR
eval OTRA='$'$REF   #equivale a ejecutar OTRA=$VAR
echo $OTRA          #se ha accedido al contenido de VAR a través de REF