# Bloque 3. Introduccion a Shell Script

## Operadores relacionales aritméticos
- lt (<)
- gt (>)
- le (<=)
- ge (>=)
- eq (==)
- ne (!=)

## Operadores para comparar cadenas
`s1 = s2`

*s1 coincide con s2*

`s1 != s2`

*s1 no coincide con s2*


## Bucles
- for
~~~
    for VARIABLE in SERIE;
    do
        bloque de comandos
    done
~~~
Ejemplo:
~~~
    for i in 1 2 3 4 5;
    do
        echo $i
    done
~~~
`SALIDA. 1 2 3 4 5`

*echo  ---> imprime por pantalla*

*$algo ---> imprime el valor de  la variable algo, lo que hay contenido*

- while
~~~~~
    while condición
    do 
        bloque de comandos
    done
~~~~~~
Ejemplo:
~~~
    #!/bin/bash
    NUM=0
    while [ $NUM -le 10 ]; do
        echo "\$NUM:$NUM"
        let NUM=$NUM+1
    done
~~~

`SALIDA.    NUM:0  NUM:1  NUM:2  NUM:3  NUM:4  NUM:5  NUM:6  NUM:7  NUM:8  NUM:9  NUM:10`

*let  ---> nos permite operar sobre una variable*
Ejemplo:
~~~
    let NUM=$NUM+1
~~~
*Cojeme el contenido de NUM y me lo incrementas en 1*

*Equivalente a:*
~~~
    let NUM+=1
~~~



## Condicionales
- (opción 1)
~~~~
if [ valor1 condición valor2 ]
then 
    bloque de comandos
else
    bloque de comandos
fi
~~~~
- (opción 2)
~~~~
if [ valor1 condición valor2 ]
then
    bloque de comandos
elsif [ condición ]
    then
        bloque de comandos
    fi
fi
~~~~
Ejemplo:

Ejecutamos poniendo 

*prueba.sh cool*
~~~~
#!/bin/bash
if [ "$1" = "cool" ]
then
    echo "Cool Beans"
else
    echo "Not Cool Beans"
fi
~~~~
`IMPRIMIRÍA POR PANTALLA . Cool Beans`

*$1 ---> sería el parámetro pasado "cool"*

Si ejecutaramos poniendo

*prueba.sh hola*

`IMPRIMIRÍA POR PANTALLA . Not Cool Beans`

## Lectura de parámetros por teclado
~~~~
echo "Introduce un valor por teclado`
read variable`
~~~~

~~~~~
read -p "Introduce un valor por teclado" variable
~~~~~

*¿Podemos hacerlo con más de una variable?*

`read -p "Introduce dos valores por teclado" variable1 variable2`

## Lectura de parámetros en la ejecución del Script

*$posicionDeLaVariableALeer*

Ejemplo:

Ejecutamos poniendo 

*prueba.sh hola*

~~~~
#!/bin/bash
echo $1
~~~~

`Salida por pantalla .` 

`hola`

Ejemplo:

Ejecutamos poniendo 

*prueba.sh hola adios*

*--------- ---- -----*

posicion0 posicion1 posicion2 

~~~~
#!/bin/bash
echo $1
echo $2
~~~~

`Salida por pantalla .` 

`hola`

`adios`

## Número de argumentos totales

`$#`

##  Echo

`echo -n`--> *elimina el INTRO del final*

~~~~
$ echo -h "hola"
$ echo "adios"
~~~~

`IMPRIMIRÍA POR PANTALLA .` 

`hola adios`

- Opción **-e** *Indicamos que se interpreten los carácteres con "\\"*
- Opción **-E** *Indicamos que no se interpreten los carácteres con "\n"*

\n *para hacer un intro*

`$ echo -e 'ejemplo\nintro'`

`IMPRIMIRÍA POR PANTALLA .` 

`ejemplo`

`intro`

\t *para un tabulador:*

`$ echo -e 'tab\ttab'`

`IMPRIMIRÍA POR PANTALLA .` 

`tab	tab`


Aclaración sobre el ECHO:

Podemos usar "" -> se suelen utilizar cuando no metemos variables

Podemos usar '' -> cuando metemos variables para imprimir su valor

-----
-----

# Comandos de Shell

## CAT

El comando **cat** concatena archivos y/o los muestra como salida.

1. Visualizar el fichero:

    `$ cat Madrigal.txt`

2. Visualiza los ficheros unos a continuación del otro:

    `$ cat Madrigal.txt Muerte.txt`

3. Visualiza el fichero y numera todas las líneas

    `$ cat -n Muerte.txt`

4. Visualizar el fichero pero paginándolo

    `$ cat Archivo.txt | less`

5. Redireccionar

    `$ cat> Madrigal.txt hola que tal estas`

6. Redireccionar sin sobreescribir lo que había

    `$ cat>> Madrigal.txt Adios`

7. Concatenar archivos

    `$ cat< Muerte.txt >> Madrigal.txt`

                Pos2            Pos1


**Madrigal.txt**

*hola*

**Muerte.txt**

*que tal*

**RESULTADO** en **Madrigal.txt**
 
~~~
hola
que tal
~~~

## CUT

Corta caracteres y campos. Se pueden usar delimitadores y otras opciones, para finalmente extraer las partes seleccionadas de cada fichero.

Vamos a trabajar cada una de las siguientes opciones a través del ejemplo:

`$ echo "Esto es una prueba, 1 2 3, probando`

`IMPRIMIRÍA POR PANTALLA .` 

`Esto es una prueba, 1 2 3, probando`

El comando **cut** nos ofrece los siguientes argumentos:

*-d*, delimiter=DELIM usa DELIM en vez de caracteres de tabulación para delimitar los campos.

*-f*, fields=LISTA selecciona solamente estos campos; también muestra cualquier línea que no tenga un carácter delimitador, a menos que se especifique la opción *-s*

`$ echo "Esto es una prueba, 1 2 3, probando" | cut -d "," -f 1`

`IMPRIMIRÍA POR PANTALLA .` 

`Esto es una prueba`

`$ echo "Esto es una prueba, 1 2 3, probando" | cut -d "," -f 2`

`IMPRIMIRÍA POR PANTALLA .` 

`1 2 3`

`$ echo "Esto es una prueba, 1 2 3, probando" | cut -d "," -f 3`

`IMPRIMIRÍA POR PANTALLA .` 

`probando`

*-c*, characters=LISTA selecciona solamente estos carácteres

¿Y si quisieramos sacar solamente unos carácteres en concreto? Usaremos el argumento *-c*:

`$ echo "Esto es una prueba, 1 2 3, probando" | cut -c 1-4`

`IMPRIMIRÍA POR PANTALLA .` 

`Esto`

`$ echo "Esto es una prueba, 1 2 3, probando" | cut -c 6-8`

`IMPRIMIRÍA POR PANTALLA .` 

`es`

`$ echo "Esto es una prueba, 1 2 3, probando" | cut -c 9-12`

`IMPRIMIRÍA POR PANTALLA .` 

`una`

`$ echo "Esto es una prueba, 1 2 3, probando" | cut -c 14-18`

`IMPRIMIRÍA POR PANTALLA .` 

`rueba`

`$ echo "Esto es una prueba, 1 2 3, probando" | cut -c 13-18`

`IMPRIMIRÍA POR PANTALLA .` 

`prueba`

*-help* muestra esta ayuda y finaliza

## LET

El comando **let** nos permite trabajar con variables numéricas en scripts.

`$ simple=4`

`$ let doble=simple*2`

Si después de ejecutar estas dos instrucciones en un terminal, hacemos un:

`$ echo $doble`

`IMPRIMIRÍA POR PANTALLA .`

`8`

EJEMPLITO: Hacer un bucle *while* que incremente el valor de una variable CONTADOR y vaya mostrando los valores de dicha variable:

~~~~
#!/bin/bash
VALOR=0
VALOR_MAXIMO=20

while [ $VALOR -lt $VALOR_MAXIMO ];
do
    let VALOR=VALOR+1
    echo 'El contador es' $VALOR
done
~~~~

----

*NOTA:* Los coamentarios en shell se ponen con *#*

----

## OPCIONES DE DIRECTORIO

Aquí el listado de las opciones:

*-d* ->> Comprobar si existe determinado directorio

*-f* ->> Comprobar si existe determinado archivo

*-w* ->> Comprobar si determinado archivo tiene permisos de escritura

*-x* ->> Comprobar si determinado archivo tiene permisos de ejecución

`if [ -w nombreFichero]` #Entraría en este *if* en el caso de que el nombre del fichero tengo permisos de escritura y ya haría dentro del *if* lo que fuese.

Ejemplo:

Ejecutamos poniendo 

*prueba.sh 1 2 3*
~~~~
#!/bin/bash
echo $#
~~~~

`SALE POR PANTALLA .`

`3`

## BC y SCALE

 Los comandos **bc** y **scale** para realizar operaciones con decimales

~~~~
#!/bin/bash
echo "scale=10; 10/3" | bc 
#resultado: 3.3333333333
~~~~

Esta operación vas a tratar la línea de comandos como si fuera una calculadora y con el **scale** me vas a mostrar 10 decimales

-----

`$*` Muestra todos los comandos metidos por la línea de comandos. Es una cadena que contiene todos los argumentos.

Por ejemplo si yo ejecuto el script así: 

`prueba.sh 1 2 3`

Lo que tendré dentro del script será:

`$* 1 2 3` 

-----

## SLEEP

**sleep** X: duerme el número de segundos indicados por la X

-----
*COMO RECORRER UN FICHERO*

Suponemos un fichero:


`Pepe:23`

`Paula:24`

`Juan:27`

~~~
echo "Nombre y edades"
echo "-----------"
for LINEA in `cat datos.txt` #LINEA guarda el resultado del fichero datos.txt
do
    NOMBRE=`echo $LINEA |cut -d ":" -f1` #Extrae el nombre 
    EDAD=`echo $LINEA | cut -d ":" -f2` #Exrae la edad
    echo "$NOMBRE tiene $EDAD años." # Muestra el resultado
done
~~~~

`Pepe:23`

`---- ---`

`f1      f2`

La *f* es de *field*, campo.

~~~
echo "Nombre y edades"
echo "-----------"

while read LINEA
do
    NOMBRE=`echo $LINEA |cut -d ":" -f1` #Extrae el nombre 
    EDAD=`echo $LINEA | cut -d ":" -f2` #Exrae la edad
    echo "$NOMBRE tiene $EDAD años." # Muestra el resultado
done < datos.txt
~~~~

------

## LS

Lista el contenido de los directorios (por defecto ordena la salida alfabéticamente).
Su sintaxis es de la forma:

`ls [opciones] [fichero...]`

Algunas de sus opciones son:

*-a* todos los archivos, incluso los que comienzan con punto (.).

*-A* Lista todos los ficheros en los directorios, excepto los que comienzan con punto (.) y los que comienzan con doble punto (..).

*-F* indica tipo: */* directorio, * ejecutable, *@* enlace simbólico.

*-h* indicará el tamaño en KB, MB, etc

*-l* listado en formato largo (o detallado).

*-S* clasifica los contenidos de los directorios por tamaños, con los ficheros más grandes en primer lugar.

*-r* invierte el orden de la salida.

*-R* Lista recursivamente los subdirectorios encontrados.

*-t* ordenar por fecha de última modificación.

*-u* ordenar por fecha de último acceso.

## AWK

Formato del comando:

`awk (patrón) (acción) fichero`

Ejemplo:

Tengo un fichero `fichero.txt` que contiene:

`1 a` 

`1 b` 

`2 c`

`2 d`

`3 e`

`3 e`

Usamos el siguiente comando

~~~~
awk '{print $1","}' fichero
~~~~

Nos devolvería la siquiente salida:

`1,`

`1,` 

`2,` 

`2,`

`3,`

`3,`

*El comando dice que saque lo que tienes en el campo uno y lo concatenas con una ","*

*En el ejemplo se está omitiendo el patrón*

Lee la entrada un renglón a la vez, cada renglón se compara con cada patrón en orden; para cada patrón que concuerde con el renglón se efectúa la acción correspondiente. Si se omite la acción, la acción por defecto consiste en imprimir los renglones que concordaron con el patrón y si se omite el patrón, la parte de la acción se hace en cada renglón de entrada. **awk** divide cada renglón de entrada en campos, (por defecto) cada campo estará separado por espacios, llama a los campos **$1**, **$2**, ...