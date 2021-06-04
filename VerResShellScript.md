# Programación Shell-script en Linux (Versión resumida)

El intérprete de comandos o shell es un programa que permite a los usuarios interactuar con el sistema, procesando las órdenes que se le indican. 

La gran mayoría de los shells derivados del Bourne Shell, tales como `bash`, `dash` o `ksh`, den soporte a este estándar POSIX (mientras que los derivados del `csh` **no**).

Nos centraremos en la sintaxis de shell propuesta por el estándar `POSIX IEEE 1003.2`

## Estructura básica de shell-scripts. Invocación

`script_ejemplo.sh`

~~~~
#!/bin/dash                         <<-- Shebang
# Esto no se interpreta             <<-- Comentarios
echo Hola                           <<-- Contenido
ps w
echo "Proceso lee el script: $$"
~~~~

El `shebang` permite especificar el intérprete de comandos con el que deseamos que sea interpretado el resto del script cuando se usa invocación implícita (ver más adelante). Debe ser la 1ª línea del script, puede haber espacios entre `#!` y el ejecutable del shell. De no indicarlo, en la invocación implícita, se usará el mismo shell desde el que se invocó el script.

Existen 3 formas de invocar un script:

1. Explícita: escribiendo explícitamente qué shell se desea invocar y pasando como argumento el nombre del script, cargándose en memoria un nuevo proceso para dicho shell (se ignora el `shebang`).

      `/bin/sh script_ejemplo.sh`

      `/bin/dash script_ejemplo.sh`

      `/bin/bash script_ejemplo.sh`

2. Implícita: invocando al script como si fuera un ejecutable, lo que requiere asignar permisos de ejecución al script. Se lee el `shebang` para determinar qué shell deberá usarse para leer el script, cargándose en memoria un proceso hijo (subshell) para dicho shell.

      `./script_ejemplo.sh`

    > NOTA: Compruebe que el fichero `script_ejemplo.sh` tiene permisos de ejecución generales (si no los tuviese, para asignárselos bastaría ejecutar `chmod +x script_ejemplo.sh`).

3. Implícita con `.` (equivale a importar): el script será interpretado por el mismo proceso del shell responsable de la línea de comandos desde la que se está invocando el script (luego aquí no se abre ningún subshell). Consecuentemente, en este caso también se ignora el `shebang`.

      `.  script_ejemplo.sh`

## Sintaxis de Shell-scripts

### Entrecomillado y carácter de escape

Cuando queremos utilizar un carácter especial del shell o una palabra reservada del lenguaje sin que sea interpretada como tal o prevenir una expansión o sustitución indeseada, haremos uso de:

* El carácter de escape `\` : indica que el siguiente carácter debe preservar su valor literal. El carácter de escape se elimina de la línea una vez procesado. Si aparece al final de una línea, significa *"continuación de línea"* e indica que el comando continúa en la siguiente línea (puede ser utilizado para dividir líneas muy largas).

* Comillas simples `' '` : todo texto *‘entrecomillado’* con comillas simples mantendrá su valor literal, no se producirá ninguna expansión ni sustitución y será considerado como una única palabra.

* Comillas dobles `"`: es equivalente a usar comillas simples, salvo que en este caso sí se hacen expansiones y sustituciones (todas menos las expansiones de tilde y ruta y la sustitución de alias que veremos más adelante).

___

Ejecute los siguientes comandos en el terminal y analice los resultados:

~~~~
cd
echo $PWD
echo \$PWD
echo '$PWD'
echo "$PWD"
echo hola \> a y b
#se crea el fichero a
echo hola > a y b   
ls
cat a
#se crea el fichero 'a y b'
echo hola >"a y b"   
ls
cat a\ y\ b
~~~~

___

### Parámetros y variables

Se pueden crear y utilizar variables, que aquí se llaman parámetros:

#### Variables


|  Operaciones básicas con las variables:      |               |         |
|----------------------------------------------|---------------|---------|
|  Sólo Definición                             |  `VAR=""`     | `VAR=`  |
|  Definición y/o Inicialización/Modificación  |  `VAR=valor`  |         |
|  Expansión (Acceso a Valor)                  |  `$VAR`       | `${VAR}`|
|  Eliminación de la variable                  |  `unset VAR`  |         |


* Las variables sólo existen en el proceso shell en que son definidas (locales al proceso).

* Las variables sólo son accesibles desde el momento de su definición hacia abajo del script. En el estándar POSIX todas las variables son globales, aunque existen variantes (como `bash`) que permiten la creación de variables locales a las funciones.

* Se crean al asignarles la primera vez un valor.

* Al definir una variable sin inicialización, su valor por omisión es la cadena nula.
      
   `VAR=`

   `VAR=""`

* Con el comando `set` (sin argumentos) puede ver todas las variables (y funciones) definidas en el shell actual.

* Linux es *"case sensitive"*. `VAR` y `var` serán tomadas como dos variables independientes.

* 1er carácter: una letra o el carácter de subrayado `_`.

* 2º y posteriores caracteres: una letra, dígito o el carácter de subrayado.

* No incluir ningún espacio ni antes ni después del signo `=`. El shell podría interpretarlo como un comando.

* El valor de una variable siempre es tomado por el shell como una cadena de caracteres.

* Si el valor de una variable contiene caracteres especiales, espacios, u otros elementos que puedan ser malinterpretados por el shell, tendrá que ir entrecomillado o deberá incluir el carácter de escape donde sea necesario.

* El uso de las llaves `{}` sólo es necesario si justo tras el nombre de la variable se desean escribir más caracteres, sin añadir ningún espacio antes. Se verá más adelante con más detalle.

___

Mire el contenido del script `script_variables.sh`, que deberá contener lo siguiente:

`script_variables.sh`

~~~~
echo "Mal definida":
echo "(orden no encontrada)":
VAR = 1
echo "Variables bien definidas:"
VAR=1
VAR1=2
var=3
echo "Variables: $VAR $VAR1 $var"
echo "Variable VAR: $VAR"
echo "Variable VAR1: $VAR1"
echo "VAR seguida de 1: ${VAR}1"
echo "Comillas dobles: $VAR"
echo 'Comillas simples: $VAR'
echo "Valor: $VAR-1"
~~~~
                  
Compruebe que dispone del permiso de ejecución general. Invóquelo y analice su funcionamiento.

___

#### Variables del shell

Existe un conjunto de variables que afectan al funcionamiento del shell. Por ejemplo: `HOME`, `PATH`, `LANG`,...

Aquí vamos a destacar la variable `IFS` (Input Field Separators). El valor de esta variable es una lista de caracteres que se emplearán en el proceso de división de campos realizado tras el proceso de expansión (que se verá más adelante) y por el comando `read`. El valor por defecto es `<espacio><tab><nueva-línea>`.

#### Parámetros posicionales


Son los parámetros de la línea de comandos con la que se ha invocado al script (equivalen a la variable `argv` de `C`). Están denotados por un número y para obtener su valor se emplea `$X` o `${X}` para los parámetros del `1` al `9` y `${X}` para parámetros mayores (números de más de un dígito). Se pueden modificar con los comando `set` (los crea) y `shift` (los desplaza de posición).


#### Parámetros especiales

|  Parámetro especial  |  Valor  |
|----------------------|---------|
|  `$*`                | Se expande a todos los parámetros posicionales desde el 1. Si se usa dentro de comillas dobles, se expande como una única palabra formada por los parámetros posicionales separados por el primer carácter de la variable `IFS` (si la variable `IFS` no está definida, se usa el espacio como separador y si está definida a la cadena nula, los campos se concatenan).  |
|  `$@`                |  Se expande a todos los parámetros posicionales desde el 1, como campos separados, incluso aunque se use dentro de comillas dobles.  |
|  `$0`                |  Nombre del shell o shell-script que se está ejecutando.  |
|  `$-` (guion)        |  Opciones actuales del shell (modificables con el comando `set`). Consulte las opciones disponibles con el comando `man dash` .  |
|  `$#`                |  Nº de argumentos pasados al script (no incluye el nombre del script).  |
|  `$?`                |  Valor devuelto por el último comando, script, función o sentencia de control invocado. Recuerde que, en general, cualquier comando devuelve un valor. Usualmente, cuando un comando encuentra un error devuelve un valor distinto de cero.  |
|  `$$`                |  PID del proceso shell que está interpretando el script. |
|  `$!`                |  PID del último proceso puesto en segundo plano.  |

---

Mire el contenido del script `script_var-shell.sh`, que deberá contener lo siguiente:

`script_var-shell.sh`

~~~
#!/bin/sh
echo \$@=$@
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
~~~

Compruebe que dispone del permiso de ejecución. Invóquelo el comando y analice la salida:

`./script_var-shell.sh arg1 arg2`

---

#### Exportación de variables

Cuando un proceso (proceso padre, como por ejemplo el shell) ejecuta otro proceso (proceso hijo, otro programa o script), el proceso padre, además de los parámetros habituales ( `argc` y `argv` en `C`), le pasa un conjunto de variables de entorno al proceso hijo (cada lenguaje de programación tiene su método propio para obtenerlas y modificarlas). Las variables de entorno pasadas pueden ser utilizadas por el proceso hijo para modificar su comportamiento.

El comando interno del shell `export` permite que una variable (previamente definida o no) sea configurada para que su valor sea copiado a los procesos hijos que sean creados desde el shell actual (por ejemplo otros shell).

`export VAR`

`export VAR=valor`

En este último caso, sí es posible añadir un espacio antes o después del signo `=`.

Debe advertirse que *"exportación"* significa *"paso de parámetros por valor"*. El proceso hijo **no** puede crear ni modificar variables del proceso padre.

---

Mire el contenido de los siguientes scripts en su sistema:

`script_padre.sh`

~~~
#!/bin/bash
export VAR=a
echo $VAR
ps w
./script_hijo.sh
echo $VAR
~~~

`script_hijo.sh`

~~~
#!/bin/sh
echo $VAR
VAR=b
echo $VAR
ps w
~~~

Compruebe que dispone del permiso de ejecución. Ejecute el comando:

`./script_padre.sh`

Analice el resultado.

---

No debe confundirse la exportación con la invocación de shell-scripts mediante el mecanismo implícito basado en `.`. En este caso no hay ninguna copia de variables por valor, simplemente el script invocado es interpretado por el mismo shell.

---

Mire el contenido de los siguientes scripts en su sistema:

`script1.sh`

~~~
#!/bin/bash
VAR=a
echo $VAR
ps w
. script2.sh
echo $VAR
~~~

`script2.sh`

~~~
#!/bin/sh
echo $VAR
VAR=b
echo $VAR
ps w
~~~

Compruebe que dispone del permiso de ejecución general. Ejecute el siguiente commando y analice el resultado:

`./script1.sh`

---

En los S.O.'s Linux suele ser habitual encontrar scripts que se dedican exclusivamente a contener la inicialización de un conjunto de variables, o la definición de un conjunto de funciones. Otros scripts del sistema hacen uso del mecanismo de invocación implícito basado en `.`, para cargar o importar las variables o funciones definidas en dichos scripts.

`cont_func.sh`

~~~
#!/bin/sh
fun1(){...}
fun2(){...}
#...
~~~

`cont_var.sh`

~~~
#!/bin/sh
VARa=1
VARb=2
#...
~~~

`script_sistema.sh`

~~~
#!/bin/sh
. /dir/cont_var.sh
. /dir2/cont_fun.sh
fun1 $VARb
#...
~~~

___


### Expansiones y sustituciones

Existen los siguientes tipos de expansiones y sustituciones (que desarrollaremos más adelante):

1. Expansión de `~` (virgulilla o tilde de la ñ).
2. Expansión de parámetros o variables.
3. Sustitución de comando.
4. Expansión aritmética.
5. Expansión de ruta.

Aparte de estas expansiones está el concepto de `alias` que se utiliza para crear sinónimos de comandos.

#### Expansión de ~

Las apariciones de la virgulilla (o tilde de la ñ) dentro de una línea, que no se encuentren entrecomilladas, se expanden de la siguiente manera:

|  Variables  |  Valor  |
|-------------|---------|
|  `~`        |  Se expande al valor de la variable `HOME` |
|  `~login`   |  Si *"login"* es un nombre de usuario del sistema, se expande a la ruta absoluta del directorio de inicio de sesión de ese usuario. Si no, no se expande.  |

#### Expansión de parámetros y variables

El formato general para incluir una expansión de variables o parámetros `${PAR}`

Las llaves pueden omitirse, salvo cuando se trate de un parámetro posicional con más de un dígito o cuando se quiera separar el nombre de la variable de otros caracteres.

`echo $PAR   #puede omitirse`

`echo ${10}   #no puede omitirse`

`${PAR}TEXTO  #no se omite`

|  Otros formatos  |  Valores por defecto  |
|------------------|-----------------------|
|  `${PAR:-alternativo}`  |  Valor de la variable. Si la variable no tiene ningún valor, la construcción se sustituye por el valor `alternativo`. |
|  `${PAR:=alternativo}`  |  Ídem al anterior, pero asignando el valor `alternativo` a la variable.  |
|  `${PAR%sufijo}`  |  Elimina el `sufijo` más pequeño del valor de la variable. `sufijo` es un patrón como los utilizados en la expansión de ruta. Si en vez de `%` se pone `%%` se elimina el sufijo más grande.  |
|  `${PAR#prefijo}` |  Elimina el `prefijo` más pequeño del valor de la variable. `prefijo` es un patrón como los utilizados en la expansión de ruta. Si en vez de `#` se pone `##` se elimina el prefijo más grande.  |


Ejemplos:

`script_expansion1.sh`

~~~
#!/bin/sh
VAR=1
echo $VAR
unset VAR
echo ${VAR:-2}
echo $VAR
FICH=fichero.c
echo ${FICH%.c}.o
~~~

`script_expansion2.sh`

~~~
#!/bin/sh
VAR=1
echo $VAR
unset VAR
echo ${VAR:=2}
echo $VAR
FICH=/usr/bin/prueba
echo ${FICH##*/}
~~~

#### Sustitución de comando

Permite que la salida estándar de un programa se utilice como parte de la línea que se va a interpretar.

`$(comando)`

<code>\`comando\`</code>

El shell ejecutará `comando`, capturará su salida estándar y sustituirá `$(comando)` por la salida capturada.

Para almacenar en una variable el nombre de todos los ficheros con extensión .sh del directorio actual:

<code>VAR=\`ls *.sh\`</code>

Para matar el proceso con nombre `firefox-bin`:

`kill -9 $(pidof firefox-bin)`

#### Expansión aritmética

`$((expresión))`

Permite evaluar las cadenas indicadas en la expresión como enteros, admitiendo gran parte de los operadores usados en el lenguaje C, pudiendo usar paréntesis como parte de la expresión y el signo `-` para números negativos (a las cadenas que contengan letras se les asigna el valor `0`).

Tras la evaluación aritmética, el resultado vuelve a ser convertido a una cadena.

Si se usan variables en la expresión, no es necesario que vayan precedidas por el carácter `$` si ya contienen un valor entero válido (sí es necesario para los parámetros posicionales y especiales).

---

Mire el contenido del script `script_expansion3.sh`, que deberá contener lo siguiente:

`script_expansion3.sh`

~~~
#!/bin/sh
VAR=1
VAR=$VAR+1
echo $VAR
RES1=$(($VAR))+1
echo $RES1
VAR=1
RES2=$((VAR+1)) #VAR no necesita $
echo $RES2
VARb=b
echo $(($VARb+1)) #VARb necesita $
~~~

Compruebe que dispone del permiso de ejecución. Invóquelo mediante el comando:

`./script_expansion3.sh`

Analice el resultado.

---

#### Expansión de ruta

Los campos que incluyan los caracteres `*`, `?` y `[` (asterisco, interrogación y apertura de corchetes) no entrecomillados serán sustituidos por la lista de ficheros que cumplan ese patrón. Si no hay ningún fichero con ese patrón no se sustituye nada.

### Comandos del shell

Tipos de comandos (de menor a mayor nivel):

1. Comandos simples
2. Tuberías
3. Listas AND-OR
4. Listas
5. Listas compuestas
6. Comandos compuestos (o estructuras de control)
7. Definiciones de función

#### Comandos simples

Comando simple formado por:

`[VAR=v] [redir] [ejecutable argumentos] [redir]`

Pudiendo ser el `ejecutable` programas *"ejecutables"* (comandos internos y ejecutables externos) e *"interpretables"* (funciones).

En un mismo comando simple se puede hacer simultáneamente la *asignación de variables* **y** la *ejecución de un programa*. Cuando un comando simple no incluye un programa a ejecutar, la asignación de variables afecta a todo el shell, de lo contrario la asignación sólo afecta al programa que se va a ejecutar.

|  Ejemplo  |  Acciones que realiza  |
|-----------|------------------------|
|  `VAR=x`  |  Asigna el valor `x` a la variable `VAR` y afecta a todo el proceso shell actual  |
|  `VAR=x programa`  |  Asigna el valor `x` a la variable `VAR` y afecta solo al `programa`.  |
|  `VAR=y OTRA=z` |  Asigna el valor `y` a la variable `VAR` y el valor `z` a la variable `OTRA`, que afectan a todo el shell.  |
|  `VAR=x programa $VAR` |  Asigna el valor `x` a la variable `VAR` y afecta sólo al `programa`, al cual se le pasa como primer argumento `y`.  |
|  `echo $VAR` |  Se imprime `y` por pantalla.  |
|  `VAR=x > fichero programa`  |  Asignan el valor `x` a la variable `VAR` que afecta solo al `programa`. Se ejecuta el `programa` y la salida estándar se redirige al archivo `fichero`. La redirección se realiza independientemente de que aparezca antes o después del `programa`.  |
|  `VAR=x programa > fichero  #equivalente` |  Asignan el valor `x` a la variable `VAR` que afecta solo al `programa`. Se ejecuta el `programa` y la salida estándar se redirige al archivo `fichero`. La redirección se realiza independientemente de que aparezca antes o después del `programa`.  |


> NOTA: Si hubiera varias redirecciones se realizan en el orden de aparición en la línea, de izquierda a derecha.

#### Tuberías

Es una secuencia de uno o más comandos (simples o compuestos, pero no ningún tipo de lista) separados por el operador `|`.

La salida estándar de un comando se conecta a la entrada estándar del siguiente comando (cada comando se ejecuta en otro subshell simultáneamente).

`[ ! ] comando1 [ | comando2 … ]`

El carácter `!` que hace la *negación lógica* del valor devuelto por el último comando, de tal manera que el valor devuelto por la tubería sería `1` si el último comando devuelve `0`, o `0` en caso contrario.

#### Listas AND-OR

Una lista `AND` es una secuencia de *tuberías* (tenga en cuenta que una *tubería* puede ser sólo un *comando simple*) separadas por el operador `&&`.

`tuberia1 [ && tuberia2 …  ]`

Se van ejecutando las *tuberías* de izquierda a derecha hasta que una de ellas devuelva un valor **distinto** de *cero*. No se realiza ninguna expansión en una *tubería* hasta que el shell no determine que tiene que ejecutar dicha *tubería* (dependerá del resultado de la *tubería* anterior).

Una lista `OR` es una secuencia de tuberías separadas por el operador `||`.

`tuberia1 [ || tuberia2 … ]`

Se van ejecutando las *tuberías* de izquierda a derecha hasta que una de ellas devuelva un valor *cero*. No se realiza ninguna expansión en una *tubería* hasta que el shell no determine que tiene que ejecutar dicha *tubería*.

Una lista `AND-OR` es el resultado de combinar lista `AND` y/o `OR` en una misma línea. Los operadores `&&` y `||` se evalúan con la misma prioridad de izquierda a derecha.

`tuberia1 || tuberia2 && tuberia3`

#### Listas

##### Listas secuenciales

Se utiliza como separador el operador `;`. Se van ejecutando los distintos comandos secuencialmente (no se ejecuta un comando hasta que haya terminado el anterior). Cada lista `AND-OR` debe estar terminada por el operador `;` a excepción de la última donde es opcional.

`listaAND-OR1 [ ; listaAND-OR2 … ] [ ; ]`

##### Listas asíncronas

Se utiliza como separador el operador `&`. Se van ejecutando los distintos comandos sin esperar a que el comando anterior termine (ejecución en segundo plano). El formato es:

`listaAND-OR1 & [ listaAND-OR2 & ]`

En este caso, a menos que se haga una redirección explícita de la entrada estándar, si un programa en segundo plano lee de la entrada estándar recibirá un error de fin de fichero (EOF).

##### Listas mixtas

Son combinaciones de listas *secuenciales* y *asíncronas.* Por ejemplo:

`#asíncrona y secuencial`
`lANDOR1 & lANDOR2 [ ; ]`

`#secuencial y asíncrona`
`lANDOR1 ; lANDOR2 &`

`#asíncrona y secuencial`
`lANDOR1 & lANDOR2 & lANDOR3 ; lANDOR4`

`#secuencial, asíncrona, secuencial`
`lANDOR1 ; lANDOR2 & lANDOR3`

#### Listas compuestas

No es más que una secuencia de listas , separadas por el carácter de nueva línea (`intros`), terminada por el operador `;`, el operador `&`, el carácter de nueva línea (`intro`) o un comando compuesto. La utilidad de este tipo de listas se verá sobre todo cuando se expliquen los comandos compuestos.

---

Mire el contenido del script `script_operadores.sh`, que deberá contener lo siguiente:

`script_operadores.sh`

~~~
#!/bin/sh
head -1 /etc/passwd && echo "Sin error1A" || echo "Con error1B"
head -1 /nofile && echo "Sin error2A" || echo "Con error2B"
echo "Comando dividido \
en dos líneas"
echo "Sin escapado: $$"
echo "Con escapado: \$\$"
echo "N º de proceso del shell bash:" `pidof bash`
~~~

Compruebe que dispone del permiso de ejecución. Invóquelo y analice su funcionamiento.

---


#### Comandos compuestos o estructuras de control

En otros lenguajes de programación se conocen como *estructuras de control*. Si se hace una redirección a continuación del terminador, en la misma línea, esa redirección se aplicará a todos los comandos que se encuentre en ese comando compuesto, a menos que se haga otra redirección explícita en un comando en concreto.

##### Secuencial (agrupación de comandos)

Existen dos formas de agrupar comandos, con los siguientes formatos:

`( lista-compuesta )`

Se ejecuta la *lista compuesta* en un **subshell**. Los cambios que se produzcan en este **subshell** no afectarán al **shell actual**. Si la lista compuesta está terminada por el carácter de nueva línea, este carácter puede omitirse.

`{ lista-compuesta }`

Se ejecuta la lista compuesta en el **shell actual**. Recuerde que las listas compuestas están terminadas por los operadores `;`, `&` o *nueva línea* (el último comando debe estar separado de la llave de cierre por esos operadores).

En ambos casos, se permite añadir una *redirección* al final (detrás del `)` o `}`) que afectará a todos los comandos del grupo.

##### Condicional: if-elif-else

~~~
if lista-compuestaA1 then
    lista-compuestaB1
elif lista-compuestaA2 then
    lista-compuestaB2
...
else
  lista-compuestaN
fi
~~~

> ADVERTENCIA: `0` significa `verdadero` aquí

Si no quiere realizar ninguna operación en un determinado caso, puede utilizar el comando `:` (comando nulo).

|  Si `condicion` devuelve `0` si algo es *verdadero* y `1` si es *falso*  |  Equivalente  |
|------------------------------------------------------------------------------|---------------|
|  if condicion; then<br/>&nbsp;&nbsp;&nbsp;&nbsp;{&nbsp;comando1;&nbsp;comando2;&nbsp;}<br/>fi          |  if condicion; then<br/>&nbsp;&nbsp;&nbsp;&nbsp;comando1;&nbsp;comando2;<br/>  fi  |  
|  if condicion<br/>then<br/>&nbsp;&nbsp;&nbsp;&nbsp;comando1;<br/>&nbsp;&nbsp;&nbsp;&nbsp;comando2;<br/>fi  |  if condicion<br/>then<br/>&nbsp;&nbsp;&nbsp;&nbsp;comando1<br/>&nbsp;&nbsp;&nbsp;&nbsp;comando2<br/>fi  |
|  if condicion; then comando1; comando2; fi  |  |
|  if condicion; then { comando1; comando2; } fi  |  |


> NOTA: Recuerde que si usa las llaves, debe separarlas del resto de elementos.

Respecto a la `condición`; que puede usarse, basta cualquier lista compuesta que devuelva un valor (por ejemplo, pueden usarse los comandos internos `true` o `false`). El valor de una lista compuesta es el valor del último comando simple ejecutado en la lista compuesta.

Un programa habitual que se utiliza como condición es el programa `test`. El comando `test` se puede ejecutar de dos formas (ambas equivalentes):

`test expresion`

`[ expression ]  #los [] deben estar separados`

En la segunda forma los corchetes no son operadores ni indican que la expresión sea opcional, sino que realmente son el nombre del programa.

<table>
   <thead>
      <tr>
         <th>Tipo</th><th>Expresión</th><th>Verdadera sí (devuelve 0)</th>
      </tr>
   </thead>
   <tr>
      <td rowspan=6>Enteros (n1 y n2 se convierten a enteros)</td>
      <td><code>n1 -eq n2</code></td>
      <td>n1 = n2</td>
   </tr>
   <tr>
      <td><code>n1 -ne n2</code></td>
      <td>n1 ≠ n1</td>
   </tr>
   <tr>
      <td><code>n1 -gt n2</code></td>
      <td>n1 > n2</td>
   </tr>
   <tr>
      <td><code>n1 –ge n2</code></td>
      <td>n1 ≥ n2</td>
   </tr>
   <tr>
      <td><code>n1 -lt n2</code></td>
      <td>n1 < n2</td>
   </tr>
   <tr>
      <td><code>n1 -le n2</code></td>
      <td>n1 ≤ n2</td>
   </tr>
   <tr>
      <td rowspan=4>Cadenas</td>
      <td><code>"$VAR" = "cad"</code></td>
      <td>$VAR vale "cad". <strong>Es conveniente, pero no necesario, poner la variable entre comillas por si tuviera espacios o estuviese vacía, para que al expandirse no dé error de sintaxis.</strong></td>
   </tr>
   <tr>
      <td><code>"$VAR" != "cad"</code></td>
      <td>$VAR vale algo distinto de "cad".</td>
   </tr>
   <tr>
      <td><code>-z "$VAR"<br/>"$VAR"</code></td>
      <td>$VAR está vacía. Equivale a <code>"$VAR" = ""</code></td>
   </tr>
   <tr>
      <td><code>-n "$VAR"</code></td>
      <td>$VAR no está vacía. Equivale a <code>"$VAR" != ""</code> o <code>! -z</code></td>
   </tr>
   <tr>
      <td rowspan=11>Ficheros</td>
      <td><code>-e "$FILE"</code></td>
      <td>$FILE existe. Si se indica un enlace simbólico, será cierta sólo si existe el enlace simbólico y el fichero apuntado. Es conveniente que esté entre comillas por el mismo motivo anterior.</td>
   </tr>
   <tr>
      <td><code>-f "$FILE"</code></td>
      <td>$FILE existe y es regular. Si se indica un enlace simbólico, el tipo es el del fichero apuntado.</td>
   </tr>
   <tr>
      <td><code>-h "$FILE"</code></td>
      <td>$FILE existe y es un enlace simbólico</td>
   </tr>
   <tr>
      <td><code>-d "$DIR"</code></td>
      <td>$DIR existe y es un fichero de tipo directorio</td>
   </tr>
   <tr>
      <td><code>-p "$FILE"</code></td>
      <td>$FILE existe y es un fichero especial tubería (pipe)</td>
   </tr>
   <tr>
      <td><code>-b "$FILE"</code></td>
      <td>$FILE existe y es un fichero especial de bloques</td>
   </tr>
   <tr>
      <td><code>-c "$FILE"</code></td>
      <td>$FILE existe y es un fichero especial de caracteres</td>
   </tr>
   <tr>
      <td><code>-r "$FILE"</code></td>
      <td>$FILE existe y puede leerse</td>
   </tr>
   <tr>
      <td><code>-w "$FILE"</code></td>
      <td>$FILE existe y puede modificarse</td>
   </tr>
   <tr>
      <td><code>-x "$FILE"</code></td>
      <td>$FILE existe y puede ejecutarse</td>
   </tr>
   <tr>
      <td><code>-s "$FILE"</code></td>
      <td>$FILE existe y su tamaño es mayor de cero bytes</td>
   </tr>
</table>


Cualquiera de las condiciones anteriores puede ser precedida por el operador negación `!`, en cuyo caso la condición será cierta si no se satisface la comparación indicada. Por ejemplo, `! -d $DIR` se cumplirá si `$DIR` **NO** es un directorio.

| Condiciones múltiples |  Significado  |
|-----------------------|---------------|
|  `condicion1  -a condicion2` |  AND: Verdadero si ambas condiciones son verdaderas  |
|  `condicion1  -o condicion2` |  OR: Verdadero si se cumple alguna de las dos condiciones  |

---

Mire el contenido del siguiente script en su sistema y compruebe que tiene el permiso de ejecución:

`script_if.sh`

~~~
#!/bin/sh

FILE=/tmp/archivo
if [ -r $FILE -a ! -w $FILE ]; then
   echo Fichero $FILE existe y no es modificable
else
   echo Fichero no encontrado o es modificable
fi

VAR1=1; VAR2=1
if [ $(($VAR1)) -ne $(($VAR2)) ]; then
   echo Distintos
elif ls /; then
   :
fi
~~~

Ejecute los comandos siguientes y analice el resultado:

`rm –f /tmp/archivo`

`./script_if.sh`

Ejecute ahora los comandos siguientes y vuelva a analizar el resultado:

`touch /tmp/archivo`

`chmod –w /tmp/archivo`

`./script_if.sh`

---

##### Condicional: case


~~~
case cadena_texto in
  patron1) lista-compuesta1;;
  patron2) lista-compuesta2;;
  ...
  * ) lista-defecto [;;] #coincide con todo
esac
~~~

Asimismo, pueden usarse patrones múltiples mediante el operador `|` y opcionalmente pueden comenzar con el paréntesis:

`patronA  | patronB)`

`(patronA  | patronB)`

`(patronC)`

El doble punto y coma `;;` permite determinar el final de los elementos a interpretar cuando se cumpla su patrón asociado. Por ese motivo, el `;;` del último patrón puede omitirse.

<table>
   <tr>
      <td>
         <pre>
case cadena_texto in
  patron1)
       cmd1;
       cmd2;;
esac
         </pre>
      </td>
      <td>
         <pre>
case cadena_texto in
  patron1 )
       cmd1
       cmd2
esac
         </pre>
      </td>
   </tr>
   <tr colspan=2>
      <td><pre>case cadena_texto in patron1) cmd1; cmd2;; esac</pre></td>
   </tr>
   <tr colspan=2>
      <td><pre>case cadena_texto in (patron1) cmd1; cmd2; esac</pre></td>
   </tr>
<table>

---

1. Mire el contenido del siguiente script en su sistema y compruebe que tiene el permiso de ejecución:

`script_case.sh`

~~~
#!/bin/sh

case $1 in
    archivo | file)
        echo Archivo ;;
    *.c)
        echo Fichero C ;;
    *)
        echo Error
        echo Pruebe otro ;;
esac
~~~

2. Ejecute los comandos siguientes y analice el resultado:

`./script_case.sh archivo`

`./script_case.sh file`

`./script_case.sh file.c`

`./script_case.sh file.c++`

---

##### Bucles incondicionales: for

~~~
for VAR in lista_valores; do
  lista-compuesta
done
~~~

<table>
   <tr colspan=2>
      <td><pre>for VAR in lista_valores; do lista-compuesta done</pre></td>
   <tr>
   <tr>
      <td>
         <pre>
for VAR
in lista_valores
do
  lista-compuesta
done
         </pre>
      </td>
      <td>
         <pre>
for VAR in lista_valores
do
  lista-compuesta
done
         </pre>
      </td>
   </tr>
</table>

`lista_valores` se corresponde con un conjunto de valores (tomándose cada valor como una cadena de caracteres que puede ser objeto de expansión y como caracteres de separación los caracteres definidos en la variable `IFS`). La estructura `for` define la variable `VAR` (si no ha sido previamente definida). Para cada uno de los valores del resultado de expandir `lista_valores`, la estructura inicializa la variable `VAR` con dicho valor y realiza una iteración (ejecutando `lista-compuesta`, en la cual suele ser habitual acceder al valor de la variable `VAR`).

Es posible omitir `in lista_valores`. Si se omite equivale a haber escrito: `in "$@"`

---

1. Ejecute el siguiente comando y compruebe como se puede utilizar una expansión de ruta dentro de un bucle `for`:

`for i in ~/.*; do echo Fichero oculto: $i; done`

2. Mire el contenido del siguiente script en su sistema, compruebe que tiene el permiso de ejecución, invóquelo y compruebe el contenido del fichero *"ficherosalida"* que crea:

`script_for1.sh`
~~~
#!/bin/sh

for i in 1 2 3; do
    echo "Iteracion: $i"
done > ficherosalida
~~~

`script_for2.sh`
~~~
#!/bin/sh

for file in `ls /`; do
    echo "Fichero: $file"
done
~~~ 

Mire el contenido del siguiente script en su sistema, compruebe que tiene el permiso de ejecución e invóquelo.

---

El comando `seq` presenta la sintaxis:

`seq   valor_inicial   valor_final`

siendo ambos valores números enteros. La salida del comando es la secuencia de números enteros entre ambos valores extremos indicados.

---

1. Ejecute el comando siguiente y observe su salida:

`seq 1 10`

2. Mire el contenido del siguiente script en su sistema, compruebe que tiene el permiso de ejecución general e invóquelo:

`script_for_seq.sh`
~~~
#!/bin/sh

for i in `seq 1 3`; do
    echo "Iteracion: $i"
done
~~~ 

Compruebe cómo se obtiene el mismo resultado que se tenía al invocar el fichero `script_for1.sh`.

---

##### Bucles condicionales: while y until

<table>
   <tr>
      <td>
         <pre>
while lista-comp-condicion do
  lista-compuesta
done
         </pre>
      </td>
   </tr>
   <tr>
      <td>
         <pre>
until lista-comp-condicion do
  lista-compuesta
done
         </pre>
      </td>
   </tr>
</table>

* `while` va iterando (interpreta la `lista-compuesta`) mientras se cumpla la condición indicada (`lista-comp-condicion` devuelve el valor `0`)
* `until` va iterando (interpreta la `lista-compuesta`) mientras **NO** se cumpla la condición indicada (`lista-comp-condicion` devuelve un valor **distinto** de `0`).

Así, por ejemplo, serían válidas y equivalentes las sintaxis siguientes, si la condición del `until` es la condición del `while` negada:

<table>
   <tr>
      <td>
         <pre>
while lista-comp-condW
do
   cmd1
   cmd2
done
			</pre>
      </td>
      <td>
         <pre>
until lista-comp-condU
do
   cmd1
   cmd2
done
         </pre>
      </td>
   </tr>
   <tr colspan=2>
      <td><pre>while lista-comp-condW ; do cmd1; cmd2; done</pre></td>
	</tr>	
   <tr>
      <td><pre>while lista-comp-condW ; do { cmd1; cmd2; } done</pre></td>
   </tr>
</table>
		
---

1. Mire el contenido del siguiente script en su sistema, compruebe que tiene el permiso de ejecución e invóquelo:

`script_while.sh`
~~~
#!/bin/sh

CONTADOR=0
while [ $CONTADOR – lt 3 ]; do
    echo "Contador: $CONTADOR "
    CONTADOR=$(($CONTADOR+1))
done
~~~ 

2. Mire el contenido del siguiente script en su sistema, compruebe que tiene el permiso de ejecución e invóquelo:

`script_until.sh`
~~~
#!/bin/sh

CONTADOR=0
until [ $CONTADOR – ge 3]]; do
    echo El contador es $CONTADOR
    CONTADOR=$(($CONTADOR+1))
done
~~~
Podrá comprobar cómo ambos scripts devuelven la misma salida.

---

##### Ruptura de sentencias de control

`continue`: utilizado en estructuras de control repetitivas para detener la iteración actual y continuar con la siguiente. Su sintaxis es:

`continue  [n]`

El parámetro opcional `n` es un número entero positivo que permite especificar la estructura de control en la que se desea detener la iteración. Si se tienen varias estructuras de control anidadas, la estructura actual en la que se encuentra el continue corresponde a la estructura `1`; la estructura superior que engloba a ésta sería la estructura `2`, y así sucesivamente. Así, el valor de `n` referencia a la estructura de control en la que deseamos detener la iteración actual y continuar con la siguiente (por omisión, `"n=1"`).

`break`: utilizado en estructuras de control repetitivas para detener todas las iteraciones restantes de la estructura de control actual. Su sintaxis es:

`break  [n]`

El parámetro opcional `n` es un número entero positivo que permite indicar si se desean cancelar varias estructuras de control anidadas (por omisión, `"n=1"`, que referencia a la estructura actual en la que se encuentra el `break`).

#### Funciones

<table>
  <tr>
    <th>Definición</th>
    <td><code>fnombre() comando-compuesto [redir]</code></td>
  </tr>
  <tr>
    <th>Invocación</th>
    <td><code>fnombre  [arg1  arg2 … ]</code></td>
  </tr>
</table>

El paréntesis siempre debe estar vacío (sólo indica que se está definiendo una función). Pueden insertarse espacios antes, entre y después del paréntesis. El comando compuesto puede ser cualquier de los que se han visto (agrupación de comandos, estructuras condicionales, estructuras repetitivas). Opcionalmente pueden aplicarse redirecciones a la función (afecta a los comandos que contiene, salvo que contengan una redirección explícita).

<table>
   <tr>
      <td>
         <pre>
fnombre(){
  comando1
  comando2
}
			</pre>
      </td>
      <td>
         <pre>
fnombre(){
  comando1;
  comando2;
}
         </pre>
      </td>
   </tr>
   <tr colspan=2>
      <td><pre>fnombre() { comando1; comando2; }</pre></td>
	</tr>	
</table>

Los argumentos pasados a la función en su invocación son accesibles desde el cuerpo de la función mediante los parámetros posicionales `$1`, `$2`,..., `$9`, `${10}`,... Por tanto, dentro de la función, los parámetros posicionales **no** corresponden a los argumentos usados en la invocación del script.

Al igual que las variables, las funciones son:

* Locales: sólo existen en el proceso shell en que son definidas.
* Sólo son accesibles desde el momento de su definición hacia abajo del script, esto es, siempre deben definirse primero e invocarse después (no puede invocarse a una función que es definida más adelante).
* Dentro de la función son visibles todas las variables y funciones definidas antes de su invocación. Y las variables definidas dentro de la función son visibles fuera tras la invocación de la función.

Dentro del cuerpo de la función suele ser habitual el uso del comando `return`, el cual provoca la salida inmediata de la función con el valor de retorno (número) indicado:

`return  [n]`

Si no se indica ningún valor de retorno, la función devuelve el valor del último comando ejecutado. Como siempre, el valor devuelto por la función puede obtenerse con la variable `$?`. `return` también puede utilizarse para terminar un script invocado implícitamente con `.`.

---

1.Mire el contenido del siguiente script en su sistema, compruebe que tiene el permiso de ejecución,  invóquelo con 2 números enteros como argumentos y analice su funcionamiento :

`script_funcion.sh`
~~~
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
~~~

---

### Uso de comandos y aplicaciones

#### Comandos internos

* Especiales: un error producido al ejecutar este comando da lugar a que el *shell termine*. Por consiguiente, el script termina con un **error** y un valor de retorno *mayor de cero* .
* Regulares: el shell no tiene que terminar cuando se produce un error en estos comandos.

|  Comando interno especial  |  Descripción  |
|----------------------------|---------------|
|  `break`,`continue`, `export`, `return`, `unset`, `.` |  Se han descrito anteriormente.  |
|  `:` |  Comando nulo. Se suele utilizar en estructuras de control que requieren un comando para ser sintácticamente correctas, pero no se quiere hacer nada.  |
|  `eval` |  Permite crear comandos a partir de sus argumentos (ver más adelante)  |
|  `exec` |  Ejecuta comandos (sustituyendo al shell actual) y abre, cierra y copia descriptores de fichero  |
|  `exit` |  Provoca que el shell termine (ver más adelante)  |
|  `readonly` |  Permite hacer que una variable sea de sólo lectura (no admite asignaciones)  |
|  `set`  |  Establece opciones del proceso shell actual y modifica los parámetros posicionales.  |
|  `shift`  |  Elimina el número indicado de parámetros posicionales empezando desde el 1, desplazando el resto de parámetros a posiciones inferiores.  |
|  `times`  |  Muestra los tiempos de procesamiento del shell y sus procesos hijos.  |
|  `trap`  |  Permite atrapar o ignorar señales del sistema.  |

Como comandos internos regulares, el estándar define los siguientes:

<table>
  <tr>
    <th>Básicos regulares</th>
    <td><code>bg, cd, false, fg, jobs, kill, pwd, read, true, wait</code></td>
  </tr>
  <tr>
    <th>Para Profundizar regulares</th>
    <td><code>alias, command, fc, getopts, newgrp, umask, unalias</code></td>
  </tr>
</table>

##### Salida del proceso shell actual, exit

`exit [n]`

`exit` provoca la eliminación inmediata del proceso correspondiente al shell que está leyendo el script. El parámetro opcional es un número entero que corresponde al valor devuelto por el script. Si no se indica ningún parámetro, el valor devuelto por el script será el del último comando ejecutado.

##### Entrada estándar a un shell-script, read

`read` lee una línea de la entrada estándar (teclado) y la guarda en variables. Solo funciona en shell interactivos (leyendo la entrada del teclado), de lo contrario no hace nada.

`read VAR1 [VAR2 …]`

Este comando espera a que el usuario introduzca una línea de texto incluyendo espacios (la entrada termina cuando el usuario pulsa la tecla *"Intro"*; la pulsación *"Intro"* no forma parte del valor asignado a la cadena). Esta línea se divide en campos (según la variable `IFS`). Tras ello, el comando define las variables dadas como argumentos, inicializándolas con los campos obtenidos en la división. Si hay más campos que variables, los campos restantes se asignan a la última variable. Si hay más variables que campos, las variables sobrantes reciben como valor la cadena vacía `""`.

Algunos intérpretes de comandos como `bash` añaden otras opciones a este comando, como la posibilidad de imprimir un mensaje usando la opción `-p`

---

Cree el script `script_read.sh` que contenga lo siguiente:

`script_read.sh`
~~~
echo " Introduzca una cadena "
read CAD
echo " Cadena introducida: $CAD "
~~~
Asígnele el permiso de ejecución general, invóquelo y analice su funcionamiento.

---

El comando `read` también puede ser útil, por ejemplo, para detener la interpretación del script hasta que el usuario pulse una tecla:

---

Cree el script `script_read_pause.sh` que contenga lo siguiente:

`script_read_pause.sh`
~~~
echo "Pulse intro para continuar..."
read CAD
echo " Continuamos... "
~~~

Asígnele el permiso de ejecución general, invóquelo y analice su funcionamiento.

---

Resulta habitual el uso de estructuras `while`, combinadas con `case` y `read`, para crear menús interactivos, permitiendo mantenerse dentro del menú.

---

1. Edite el script `script_case_menu.sh` para que tenga el siguiente contenido:

`script_case_menu.sh`

~~~
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
~~~

2. Ejecute el comando siguiente y seleccione las opciones del menú:

`script_case_menu.sh`

---

##### Construcción de comandos en tiempo de ejecución: eval

El comando `eval` construye un comando mediante la concatenación de sus argumentos (pueden ser variables, etc.) separados por espacios. Dicho comando construido es leído por el shell e interpretado. La sintaxis del comando es:

`eval [argumentos …]`

Un posible uso es la creación de referencias indirectas a variables (parecido a usar punteros en lenguaje de programación C). En la tarea siguiente se muestra esto.

---

Cree el script `script_eval.sh` que contenga lo siguiente:

`script_eval.sh`
~~~
#ejemplo de referencia indirecta con eval
VAR="Texto"
REF=VAR             #REF es una variable que vale VAR
eval OTRA='$'$REF   #equivale a ejecutar OTRA=$VAR
echo $OTRA          #se ha accedido al contenido de VAR a través de REF
~~~

Asígnele el permiso de ejecución, invóquelo y analice su funcionamiento.

---

#### Comandos externos

<table>
  <tr>
    <th>Básicos</th>
    <td><code>cat, chmod, chown, cmp, cp, date, dirname, echo, expr, printf</code></td>
  </tr>
  <tr>
    <th>Para Profundizar</th>
    <td><code>awk, basename, chgrp</code></td>
  </tr>
</table>

---

Busque información sobre el comando `echo` y `printf`. Ejecute los siguientes comandos y analice su funcionamiento:

`echo Uno`

`echo –n Uno; echo Dos`

`echo –e "Uno\nDos"`

`NOMBRE=Ana`

`printf "Hola %s. Adios %s\n" $NOMBRE $NOMBRE`

---


##  Depuración de shell-scripts


Si bien la programación de shell-scripts no se puede depurar fácilmente, los shells suelen ofrecer algunos mecanismos en este aspecto. En concreto, tanto `"bash"` como `"dash"` ofrecen los siguientes argumentos, que pueden usarse simultáneamente:

<table>
   <tr>
      <td><code>-x</code></td>
      <td>Traza: expande cada orden simple, e imprime por pantalla la orden con sus argumentos, y a continuación su salida.</td>
   </tr>
   <tr>
      <td><code>-v</code></td>
      <td>Verbose: Imprime en pantalla cada elemento completo del script (estructura de control, ...) y a continuación su salida.</td>
   </tr>
</table>

También es posible depurar sólo parte del script insertando en él los siguientes comandos (pueden usarse igualmente en la propia línea de comandos):

<table>
   <tr>
      <td><code>set -x<br/>set –xv</code></td>
      <td>Activa las trazas/verbose. Ubicarlo justo antes del trozo del script que se desea depurar.</td>
   </tr>
   <tr>
      <td><code>set +x<br/>set +xv</code></td>
      <td>Desactiva las trazas/verbose. Ubicarlo justo después del trozo del script que se desea depurar.</td>
   </tr>
</table>
 

---

1. Mire el contenido del siguiente script en su sistema y compruebe que tiene el permiso de ejecución general:

`script_depuracion.sh`
~~~
#!/bin/sh
echo Hola
if true; then
     echo hola2
     ls /
fi
~~~

2. Invoque dicho script con las siguientes opciones de depuración y analice la salida:

`/bin/bash       script_depuracion.sh`

`/bin/bash  -x   script_depuracion.sh`

`/bin/bash  -v   script_depuracion.sh`

`/bin/bash  -xv  script_depuracion.sh`

`/bin/dash  -x   script_depuracion.sh`

`/bin/dash  -v   script_depuracion.sh`

`/bin/dash  -xv  script_depuracion.sh`

3. Modifique el script para que tenga el siguiente contenido:

`script_depuracion2.sh`
~~~
#!/bin/sh
echo Hola
set -xv
if true; then
     echo hola2
     ls /
fi 
set +xv
~~~

4. Invoque dicho script con los siguientes comandos y analice la salida:

`script_depuracion2.sh`

`/bin/dash  script_depuracion2.sh`

`/bin/bash  script_depuracion2.sh`

[Propuesta de ejercicios](EjerciciosShellScript.md)