# Programación Shell-script en Linux

> NOTA: Esto es sólo un resumen, el texto original está en <http://trajano.us.es/~fjfj/shell/shellscript.htm>

El intérprete de comandos o shell es un programa que permite a los usuarios interactuar con el sistema, procesando las órdenes que se le indican. 

Comandos invocables desde el shell:

 * Internos.- corresponden en realidad a órdenes interpretadas por el propio shell (desde la línea de comandos)
 * Externos.- corresponden a ficheros ejecutables externos al shell (shell-script o "guión de órdenes" es un fichero de texto que contiene un conjunto de comandos y órdenes interpretables por el shell)

Existen múltiples implementaciones de shell:

1. `sh` (Bourne Shell) A partir de él han surgido múltiples shells:
   * `bash` Se caracteriza por una gran funcionalidad adicional a la del Bourne Shell. Como ficheros personales de los usuarios emplea `$HOME/.bashrc` y `.bash_profile`.
   * `dash` (Debian almquist shell), derivado directo de ash, se caracteriza por ser mucho más ligero (depende de menos bibliotecas) y rápido que otros shells, tales como `bash`, aunque con menos características funcionales. El fichero personal del usuario es `$HOME/.profile`.
   * `ksh` (Korn shell): destaca por sus funciones avanzadas para manejar archivos, pudiendo competir con lenguajes de programación especializados tales como `awk` o `perl`.
> Todos los sistemas Unix tienen, al menos, una implementación del Bourne Shell (o un shell compatible con él). En Linux, no existe ninguna implementación del Bourne Shell, manteniéndose la entrada  /bin/sh (así como su manual man sh) como un enlace simbólico a una implementación de shell compatible.
2. `csh` (C shell): caracterizado por presentar una sintaxis muy parecida a la del lenguaje de programación C. Como shell derivados destaca `tcsh`.
> Para intentar homogeneizar esta diversidad de shells, el IEEE definió un estándar de "intérprete de comandos" bajo la especificación POSIX 1003.2 (también recogida como ISO 9945.2). La gran mayoría de los shells derivados del Bourne Shell, tales como `bash`, `dash` o `ksh`, den soporte a este estándar POSIX (mientras que los derivados del `csh` **no**).

___
1. Ejecute el comando *ls -l /bin/sh* para comprobar el enlace simbólico a otro shell deribado. Al igual que ejecutando el comando *man sh*
2. Ejecute el comando *ls -l /bin/bash* para comprobar que el sistema dispone de dicho shell. Y el comando *bash -version* para comprobar su versión.
3. La mayoría de los shell-scripts implicados en el proceso de arranque del sistema se encuentran en la carpeta */etc/init.d/*. Por ejemplo, mire el contenido del fichero */etc/init.d/rc* (encargado del arranque de los servicios) y compruebe cómo la primera línea de dicho script es *#!/bin/sh*.
4. Analice el fichero */etc/passwd* y compruebe cómo los usuarios *dit* y *root* tienen asignado el shell *bash*. Abra una consola de comandos con el usuario *dit* y ejecute el comando *ps ax | grep bash*, comprobando cómo el proceso del intérprete de comandos usado efectivamente corresponde al shell *bash* (proceso -bash). Abra una sesión con el usuario *root* y realice la misma prueba, comprobando cómo igualmente se está usando *bash*.
___

Nos centraremos en la sintaxis de shell propuesta por el estándar `POSIX IEEE 1003.2`

## Estructura básica de shell-scripts. Invocación

Un shell-script puede ser un simple fichero de texto que contenga uno o varios comandos. Es habitual que los shell scripts tengan la extensión ".sh".

`script.sh`

~~~~
echo "Contenido carpeta personal:"
ls ~/
~~~~

___

1. Compruebe que el fichero `script.sh` tiene permisos de ejecución generales (si no los tuviese, para asignárselos bastaría ejecutar `chmod +x script.sh`).
2. Invoque el script para que sea interpretado, usando por ejemplo el comando:
`./script.sh`
---

Además de comandos, los shell-scripts pueden contener otros elementos, aportados por el shell para mejorar la funcionalidad de los scripts. De forma resumida, la estructura básica de un shell-script es la siguiente:

`script_ejemplo.sh`

~~~~
#!/bin/dash                         <<-- Shebang
# Esto no se interpreta             <<-- Comentarios
echo Hola                           <<-- Contenido
ps w
echo "Proceso lee el script: $$"
~~~~

Como contenido del script pueden utilizarse múltiples elementos (comandos, variables, funciones, estructuras de control, comentarios,...) que se analizarán en el siguiente apartado.

El `shebang` permite especificar el intérprete de comandos con el que deseamos que sea interpretado el resto del script cuando se usa invocación implícita (ver más adelante). Debe ser la 1ª línea del script, puede haber espacios entre `#!` y el ejecutable del shell. De no indicarlo, en la invocación implícita, se usará el mismo shell desde el que se invocó el script.

Existen 3 formas de invocar un script:

1. Explícita: escribiendo explícitamente qué shell se desea invocar y pasando como argumento el nombre del script, cargándose en memoria un nuevo proceso para dicho shell (se ignora el `shebang`).

2. Implícita: invocando al script como si fuera un ejecutable, lo que requiere asignar permisos de ejecución al script. Se lee el `shebang` para determinar qué shell deberá usarse para leer el script, cargándose en memoria un proceso hijo (subshell) para dicho shell.

> NOTA: Tenga en cuenta que los shell-scripts son ficheros de texto leídos por el intérprete de comandos, esto es, se interpretan, NO se ejecutan.

3. Implícita con `.` (equivale a importar): el script será interpretado por el mismo proceso del shell responsable de la línea de comandos desde la que se está invocando el script (luego aquí no se abre ningún subshell). Consecuentemente, en este caso también se ignora el `shebang`.

> En los casos en los que se crean subshells, salvo que se fuerce lo contrario (con `su -c` por ejemplo), el subshell pertenecerá al mismo usuario al que pertenecía el shell padre que lo ha creado. El usuario al que pertenece el proceso shell que interpreta un script condiciona las operaciones que se podrán hacer desde dentro del script

___

1. En una consola de comandos ejecute el comando `ps w` y localice el proceso asociado al shell responsable de la línea de comandos desde la que está trabajando.

2. Invoque dicho script mediante los distintos métodos de invocación. Para cada uno de ellos, analice la salida obtenida para determinar en cada caso cuál es el proceso shell que está interpretando el script, el usuario al que pertenece dicho proceso y si se ha abierto un subshell o no:
   * Explícita:

      `/bin/sh script_ejemplo.sh`

      `/bin/dash script_ejemplo.sh`

      `/bin/bash script_ejemplo.sh`

   * Implícita con `"."`:

     `.  script_ejemplo.sh`

   * Implícita: compruebe que el script tiene permiso de ejecución y ejecútelo con:

     `./script_ejemplo.sh`

Modifique el script eliminando el `shebang`, y vuelva a ejecutarlo. Analice si hay alguna diferencia respecto a la ejecución anterior.

---

> NOTA: `bash` sigue el estándar POSIX, aunque también añade múltiples extensiones particulares.

`script_estandar.sh`

~~~
#!/bin/sh for VAR in 0 1 2 3
do
   echo $VAR
done
~~~            

`script_bash.sh`

~~~
#!/bin/bash
for ((VAR=0 ; VAR<4 ; VAR++ ))
do
   echo $VAR
done
~~~            
 
Ambos scripts realizan la misma funcionalidad, pero `script_estandar.sh` está escrito bajo la sintaxis POSIX, mientras que `script_bash.sh` utiliza una sintaxis no estándar soportada por `bash`.

---

1. Invoque el guión `script_estandar.sh` mediante los siguientes comandos, debiendo comprobar que todas funcionan correctamente y con igual resultado (la primera y segunda llamada realmente son la misma, usando el shell dash):

`/bin/sh    script_estandar.sh`

`/bin/dash  script_estandar.sh`

`/bin/bash  script_estandar.sh`

2. Ahora invoque el guión `script_bash.sh` mediante los siguientes comandos:

`/bin/dash  script_bash.sh`

`/bin/bash  script_bash.sh`

Podrá comprobar cómo, debido a la sintaxis no estándar del script, la segunda invocación funciona, pero la primera (que emplea dash) da un error de sintaxis.

---

## Sintaxis de Shell-scripts

Se describe el lenguaje de comandos shell definido en el estándar POSIX. Veremos el funcionamiento general del shell, así como su sintaxis.

### Funcionamiento general del shell

El lenguaje shell es un lenguaje interpretado, en el que se leen líneas de texto (terminadas en \n), se analizan y se procesan. Las líneas a interpretar son leídas de:

* La entrada estándar (teclado por defecto). En este caso el shell se dice que es un shell interactivo.
* Un fichero shell-script.
* Los argumentos, con la opción `-c` al ejecutar el shell. Ejemplo: `bash –c "ls –l"`

Con las líneas leídas, el shell realiza los siguientes pasos (en este orden):

1. Se dividen las líneas en distintos elementos: palabras y operadores. Los elementos se separan usando espacios, tabuladores y operadores. El carácter `#` sirve para incluir un comentario, que se elimina del procesamiento.

2. Se distingue entre comandos simples, comandos compuestos y definiciones de función.

3. Se realizan distintas expansiones y sustituciones (ver más adelante). Se detecta el comando a ejecutar y los argumentos que se le van a pasar.

4. Se realizan las redirecciones de entrada/salida y se eliminan los elementos asociados a las redirecciones de la lista de argumentos.

5. Se ejecuta el elemento ejecutable, que podría ser una función, un comando interno del shell, un fichero ejecutable o un shell-script, pasando los argumentos como parámetros posicionales (ver más adelante).

6. Opcionalmente, se espera a que termine el comando y se guarda el código de salida.

---

Escriba el contenido del script `script_estandar.sh` visto en el apartado 2 directamente en una consola de comandos.

---

### Entrecomillado y carácter de escape

El shell tiene una lista de caracteres que trata de manera especial (operadores) y una serie de palabras reservadas (palabras que tienen un significado especial para el Shell).

Cuando queremos utilizar un carácter especial del shell o una palabra reservada del lenguaje sin que sea interpretada como tal o prevenir una expansión o sustitución indeseada (las expansiones y sustituciones se verán en un apartado posterior) es necesario indicárselo al shell mediante las comillas (simples o dobles) o el carácter de escape.

* El carácter de escape `\` : indica que el siguiente carácter debe preservar su valor literal. El carácter de escape se elimina de la línea una vez procesado. Si aparece al final de una línea, significa *"continuación de línea"* e indica que el comando continúa en la siguiente línea (puede ser utilizado para dividir líneas muy largas).

* Comillas simples `' '` : todo texto *‘entrecomillado’* con comillas simples mantendrá su valor literal, no se producirá ninguna expansión ni sustitución y será considerado como una única palabra.

* Comillas dobles `"`: es equivalente a usar comillas simples, salvo que en este caso sí se hacen expansiones y sustituciones (todas menos las expansiones de tilde y ruta y la sustitución de alias que veremos más adelante).

El entrecomillado de una cadena vacía ( `''` o `"`) genera una palabra vacía (palabra que no tiene ningún carácter).

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

1. Si el nombre es un número se denominan parámetros posicionales.

2. Si el nombre es un carácter especial se denominan parámetros especiales.

3. El resto se denominan simplemente variables.

#### Variables

Operaciones básicas con las variables:


|  Sólo Definición                             |  `VAR=""`     | `VAR=`  |
|----------------------------------------------|---------------|---------|
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

Mire el contenido del script script_variables.sh, que deberá contener lo siguiente:

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

Aquí vamos a destacar la variable `IFS` (Input Field Separators). El valor de esta variable es una lista de caracteres que se emplearán en el proceso de división de campos realizado tras el proceso de expansión (que se verá más adelante) y por el comando `read`. El valor por defecto es `<espacio><tab><nueva-línea>`. Podrá ver un ejemplo de uso de esta variable cuando realice los ejercicios propuestos (ver solución a script_user.sh).


#### Parámetros posicionales


Son los parámetros de la línea de comandos con la que se ha invocado al script (equivalen a la variable `argv` de `C`). Están denotados por un número y para obtener su valor se emplea `$X` o `${X}` para los parámetros del `1` al `9` y `${X}` para parámetros mayores (números de más de un dígito). Se pueden modificar con los comando `set` (los crea) y `shift` (los desplaza de posición).


#### Parámetros especiales


Son parámetros identificados por un carácter especial creados por el Shell y cuyo valor no puede ser modificado directamente.

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

Cuando un proceso (proceso padre, como por ejemplo el shell) ejecuta otro proceso (proceso hijo, otro programa o script), el proceso padre, además de los parámetros habituales ( `argc` y `argv` en `C`), le pasa un conjunto de variables de entorno al proceso hijo (cada lenguaje de programación tiene su método propio para obtenerlas y modificarlas). Las variables de entorno pasadas pueden ser utilizadas por el proceso hijo para modificar su comportamiento. Por ejemplo, un programa en `C` puede usar la función `getenv` declarada en biblioteca estándar `stdlib.h` para obtener dichas variables (puede obtener más información ejecutando `man getenv`).

El comando interno del shell `export` permite que una variable (previamente definida o no) sea configurada para que su valor sea copiado a los procesos hijos que sean creados desde el shell actual (por ejemplo otros shell). Presenta la sintaxis:

`export VAR`

`export VAR=valor`

En este último caso, sí es posible añadir un espacio antes o después del signo `=`.

Debe advertirse que *"exportación"* significa *"paso de parámetros por valor"*, esto es, en el proceso hijo se creará una variable de igual nombre que en el shell padre, y con igual valor, pero serán variables independientes (esto es, la modificación de valor de la variable en el proceso hijo no afectará al valor de la variable en el shell padre). El proceso hijo **no** puede crear ni modificar variables del proceso padre.

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

Por ejemplo, visualice el contenido del script del sistema encargado del arranque de los servicios `/etc/init.d/rc`. Observe cómo contiene las líneas:

`.  /etc/default/rcS`

`.  /lib/lsb/init-functions`

Visualice el contenido de esos archivos `rcS` e `init-functions` y compruebe cómo sólo contienen definiciones de variables y funciones (la sintaxis para la definición de las funciones se analizará más adelante), respectivamente. De hecho, todos los ficheros de la carpeta `/etc/default/` son scripts dedicados exclusivamente a contener la inicialización de variables, siendo importadas desde otros scripts del sistema. Por ejemplo, observe cómo:

La variable `VERBOSE` es inicializada en `rcS` y luego es usada por `rc`.
La función `log_failure_msg()` es definida en `init-functions` y luego es usada  por `rc`.

---

### Expansiones y sustituciones

Existen los siguientes tipos de expansiones y sustituciones (que desarrollaremos más adelante):

1. Expansión de `~` (virgulilla o tilde de la ñ).
2. Expansión de parámetros o variables.
3. Sustitución de comando.
4. Expansión aritmética.
5. Expansión de ruta.

Aparte de estas expansiones está el concepto de `alias` que se utiliza para crear sinónimos de comandos y sólo se realiza en el elemento ejecutable de la línea antes de cualquier otra expansión o sustitución. Su utilización es muy limitada y puede conseguirse un comportamiento similar usando funciones que permiten además parámetros (las funciones se verán más adelante). Puede ver los `alias` definidos usando el comando `alias`. Puede ver ejemplos de definición de alias en el fichero `~/.bashrc`.

1. Primero se hacen en orden las siguientes expansiones:
    * Expansión de ~.
    * Expansión de parámetros o variables.
    * Sustitución de comando.
   * Expansión aritmética.
2. Los campos generados en el primer paso son divididos utilizando como separadores los caracteres de la variable `IFS`. Si la variable `IFS` es nula (cadena nula) no se produce la división. Si la variable no está definida, se utilizan por defecto los caracteres espacio, tabulador y nueva línea.
3. Se realiza a continuación la última expansión:
4. Expansión de ruta.
5. Por último, se eliminan las comillas simples o dobles que existan y se utilicen como tal (no se eliminan las comillas que hayan perdido su significado especial, por ejemplo usando el carácter de escape).

Puede utilizar las expansiones en cualquier ubicación donde se pueda usar una cadena de texto (incluido el nombre de comandos), exceptuando las palabras reservadas del lenguaje (`if`, `else`, …).

#### Expansión de ~

Las apariciones de la virgulilla (o tilde de la ñ) dentro de una línea, que no se encuentren entrecomilladas, se expanden de la siguiente manera:

|  Variables  |  Valor  |
|-------------|---------|
|  `~`        |  Se expande al valor de la variable `HOME` |
|  `~login`   |  Si *"login"* es un nombre de usuario del sistema, se expande a la ruta absoluta del directorio de inicio de sesión de ese usuario. Si no, no se expande.  |

 
---

Comente la línea del script `script_var-shell.sh`, donde aparece la palabra *"firefox"*. Ejecute los siguientes comandos observando el valor de las variables posicionales:

`./script_var-shell.sh ~ ~root`

`./script_var-shell.sh ~noexiste ~dit`

___

#### Expansión de parámetros y variables

El formato general para incluir una expansión de variables o parámetros `${PAR}`

Las llaves pueden omitirse, salvo cuando se trate de un parámetro posicional con más de un dígito o cuando se quiera separar el nombre de la variable de otros caracteres.

`echo $PAR   #puede omitirse`

`echo ${10}   #no puede omitirse`

`${PAR}TEXTO  #no se omite`

Si la expansión de parámetros ocurre dentro de comillas dobles, sobre el resultado no se realizará la expansión de ruta ni la división de campos. En el caso del parámetro especial @, se hace la división de campos siempre.

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

La conversión de un número a un carácter puede realizarse con `$'\xxx'` (en `bash`) o con `'\xxx'` (en `dash`), ambos con comillas simples, pero ello no está recogido en el estándar POSIX.

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

___

Utilice el script `script_var-shell.sh`. Ejecute los siguientes comandos observando el valor de la variable especial @:

`./script_var-shell.sh s*_for?.sh`

`./script_var-shell.sh s*_for*.sh`

`./script_var-shell.sh s*_exp*.sh`

`./script_var-shell.sh s*_exp*[12].sh`

`./script_var-shell.sh s*_e*.sh`

___

### Comandos del shell