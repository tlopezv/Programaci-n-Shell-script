# Propuesta de ejercicios

1. Analice el contenido de los scripts `/etc/profile` (leído en el arranque del sistema y común para todos los usuarios), `~/.bashrc`, `~/.bash_profile` (leídos al abrir una sesión con el usuario correspondiente, no es necesario que existan ambos) y modifíquelos convenientemente para definir los alias:

    * `alias red='ifconfig -a'`: para todos los usuarios del sistema.
    * `alias casa='echo $PWD'`: sólo para el usuario normal.
    * `alias sockets='netstat -l'`: sólo para el usuario root.

    Repita lo anterior pero utilizando funciones en vez de alias.

    `alias.sh`
~~~

# FAST: Definición de "alias" en los scripts usados en la apertura de sesiones de usuarios

# En /etc/profile
alias red='ifconfig -a'

# En /home/dit/.bashrc
alias casa='echo $PWD'

# En /root/.bashrc
alias sockets='netstat -l'

# Funciones equivalentes:
#  Nota: no debe definir alias y nombres de funciones con el mismo nombre simultáneamente,
#     si intenta ejecutar este script dará error.

# En /etc/profile
red() { ifconfig -a; }

# En /home/dit/.bashrc
casa() { echo $PWD; }

# En /root/.bashrc
# $@ permite añadir los argumentos pasados a la función a netstat
sockets() { netstat -l $@; }

~~~

> NOTA:
>> Comando `ifconfig`:
    
>>`ifconfig`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;muestra los detalles de todos los interfaces de red que se encuentren activos en nuestro sistema.

>>>La cantidad de información que obtenemos de cada adaptador de red es considerable:
* *Link encap*: indica el tipo de interfaz del adaptador de red. En nuestro caso, se trata de una interfaz Ethernet, que es la más frecuente.
* *direcciónHW*: muestra la dirección `MAC` (Media Access Control), también conocida como dirección física, del adaptador de red. Se trata de un valor único para cada tarjeta de red Ethernet.
* *Direc. inet*: Contiene la dirección `IP` del dispositivo para `TCP/IPv4`.
* *Difus*: muestra la dirección de `broadcast` para la red en la que nos encontramos.
* *Másc*: determina los bits que establecen el ámbito de la red
* *Dirección inet6*: Contiene la dirección `IP` del dispositivo para `TCP/IPv6`.
* *ACTIVO*: Indica que se han cargado los módulos del núcleo relacionados con la interfaz Ethernet.
* *DIFUSIÓN*: Informa de que el dispositivo admite difusión, necesaria para obtener una dirección `IP` a través de `DHCP` (El *protocolo de configuración dinámica de host* (en inglés: *Dynamic Host Configuration Protocol*, también conocido por sus siglas de `DHCP`)).
* *FUNCIONANDO*: Significa que la interfaz está preparada para recibir datos.
* *MULTICAST*: Indica que la interfaz `Ethernet` admite `multicasting` (un dispositivo puede enviar paquetes que tienen como receptores a varios adaptadores diferentes, que se encuentran a la espera)
* *MTU* (Las siglas `MTU` provienen de la expresión *Maximum Transmission Unit*.): Indica el tamaño de los paquetes enviados o recibidos por el adaptador de red. De forma predeterminada, su valor será *1500*
* *Métrica*: Muestra un número entero a partir de *0*. En caso de que existan varios adaptadores de red en el mismo equipo, se debería dar preferencia al adaptador que tenga un valor menor en este parámetro. No obstante, en `GNU/Linux` se utiliza el valor de métrica obtenido de la tabla de enrutamiento.
* *Paquetes RX*: Indica el número de paquetes recibidos hasta el momento por el adaptador. También incluye los siguientes datos:
    * *errores*: Indica el número de paquetes recibidos con errores (`CRC` inválido).
    * *perdidos*: Muestra el número de paquetes que se han perdido.
    * *overruns*: Contiene el número de paquetes que han excedido la capacidad de la cola de entrada.
    * *frame*: Identifica los paquetes descartados por tener una longitud errónea (que no es múltiplo de *8*).
* *Paquetes TX*: Indica el número de paquetes enviados hasta el momento por el adaptador. Además de los datos errores, perdidos y overruns explicados arriba, se incluye un valor para carrier, que identifica problemas con la señal, indicando un posible error en el cable o en el conector usado.
* *colisiones*: Este campo representa las colisiones que sufren los paquetes cuando son transmitidos por la red. Si el valor es mayor que cero, indica que la red está congestionada.
* *long.colaTX*: Es la longitud de la cola de transmisión del adaptador.
* *Bytes RX*: Indica la cantidad total de datos recibidos, medidos en Bytes y en MegaBytes.
* *Bytes Tx*: Igual que el anterior, pero con los datos enviados.

>>`ifconfig en0`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;muestra únicamente la información de dicho adaptador `en0`.

>>`sudo ifconfig en0 down`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;deshabilitar el adaptador de red `en0`.

>>`ifconfig -a`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;si quisiéramos mostrar todos los adaptadores, incluidos los deshabilitados, bastaría con usar la opción -a

>>`sudo ifconfig en0 up`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Para volver a habilitar el adaptador de red deshabilitado `en0`

>>`sudo ifconfig en0 192.168.1.10`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Asignar una nueva dirección IP al adaptador de red `en0`

>>`sudo ifconfig en0 netmask 255.255.255.0`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;asignar una nueva máscara de red al adaptador `en0`

>>`sudo ifconfig en0 broadcast 192.168.1.255`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;asignar una nueva dirección de difusión (broadcast) al adaptador de red `en0` 

>>`sudo ifconfig en0 192.168.1.10 netmask 255.255.255.0 broadcast 192.168.1.255`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Las tres operaciones anteriores en un solo paso

>>`sudo ifconfig en0 mtu 9000`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;El tamaño en octetos de los paquetes más grandes que se transmiten. El valor predeterminado es *1500*, pero si quisiéramos cambiarlo por *9000*

---

>> Comando `netstat`: 

>>`netstat`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;consultar información relativa a las conexiones de red

>>`netstat -a`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;consultar todas las conexiones relacionadas con los puertos activos en el sistema, independientemente de que se estén escuchando o no.

>>`netstat -A inet`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;consultar las conexiones para el protocolo *TCP/IPv4*.

>>`netstat -A inet -e`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;si necesitamos un mayor nivel de detalle.

>>`netstat -l`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mostrar únicamente los puertos que están escuchando.

>>`netstat -p`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Si lo que necesitamos es relacionar los puertos que se están usando con los procesos que los utilizan.

>>`netstat -t`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;filtrar los resultados para que aparezcan únicamente aquellos que estén relacionados con el protocolo *TCP*.

>>`netstat -u`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mostrar únicamente los resultados relacionados con *UDP*.

>>`netstat -s`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Cuando necesitamos conocer el número de conexiones activas, los intentos de conexión fallidos, el número de paquetes erróneos que se han recibido, etc.

2. Cree los siguientes scripts:
    * `variables.sh`: debe inicializar las variables `CONFIG='-a'`, `ARP='-n'` y `ROUTE`.
    * `funciones.sh`: debe definir las funciones `arranque_red()` (encargada de *activar* la tarjeta `"eth0"`), `parada_red()` (encargada de *desactivar* la tarjeta `eth0`) y `estado_red()` (encargada de ejecutar los comandos `ifconfig`, `arp` y `route` aplicándoles los parámetros pasados a la función en los argumentos `1`, `2` y `3`, respectivamente).
    * `script1.sh`: debe importar las variables y funciones definidas por los dos scripts anteriores. Mostrará al usuario un menú en el que le pregunte si desea arrancar la red (invocando la función `arranque_red()`), pararla (función `parada_red()`) o mostrar su estado (función `estado_red()`). Debe comprobar si alguna de las variables  `CONFIG`, `ARP` y `ROUTE` es nula y, en caso de serlo, permitirle al usuario escribir interactivamente (mediante la función `read`) los parámetros con los que invocar el comando correspondiente.

    `variables.sh`

~~~
#!/bin/sh

# FAST: Variables importadas desde el script "script1.sh"


CONFIG="-a"
ARP="-n"
ROUTE=""


# Con ese valor de la variable "ARP", si se usase:
# echo $ARP
# El comando "echo" interpretaria el valor de ARP como el parametro "-n" ("echo -n", no hacer salto de línea)
# luego no se imprimiria en pantalla "-n" (valor de "ARP"). Para imprimir el valor de ARP en pantalla,
# cuando este tiene un valor que puede ser interpretado por "echo" como un parámetro (como "-n"),
# podría usarse, por ejemplo:
# a) En "bash":
#    echo -e "$ARP\0000"
#    Para que "-n" se imprima y no se interprete como parametro, es necesario incluirlo entre comillas con algun
#    caracter adicional). Valdria un simple espacio. El hecho de usar el caracter ASCII NULO "000" (el parametro "-e" hace que
#    "\0xxx" sea interpretado como un caracter ASCII en octal) es que es no imprimible, por lo que no afecta a la salida.
#    De este modo, si por ejemplo se ejecuta:
#    echo -n -e "$VAR\0000"; echo "cadena"
#    se obtiene la salida correcta "-ncadena"
#    El problema es que el parametro "-e" no es estandar.

~~~

   `funciones.sh`

~~~
#!/bin/sh

# FAST: Funciones importadas desde el script "script1.sh"

IFACE="eth0"
DIR="/sbin"
DIR_USR="/usr/sbin"

arranque_red()
{
  echo "Reactivando la interfaz ${IFACE}..."
  ${DIR}/ifdown ${IFACE}
  ${DIR}/ifup ${IFACE}
  echo "Pulse intro para continuar..."
  read REPLY
}


parada_red()
{
  echo "Desactivando la interfaz ${IFACE}..."
  ${DIR}/ifdown ${IFACE}
  echo "Pulse intro para continuar..."
  read REPLY
}


estado_red()
{
  echo "Estado de la configuración actual de la red"
  echo "Configuración de la red (comando \"ifconfig $1\"):"
  ${DIR}/ifconfig $1
  echo
  echo
  echo "Pulse intro para continuar..."
  read REPLY
  echo "Tabla ARP (comando \"arp $2\"):"
  ${DIR_USR}/arp $2
  echo
  echo
  echo "Pulse intro para continuar..."
  read REPLY
  echo "Tabla de Encaminamiento (comando \"route $3\"):"
  ${DIR}/route $3
  echo
  echo
  echo "Pulse intro para continuar..."
  read REPLY
}
~~~

   `script1.sh`
~~~
#!/bin/sh

# FAST: Script para la administración básica del estado de la red

# La linea siguiente permite invocar "script1.sh" con ruta absoluta, ademas de relativa
DIRRAIZ=`dirname $0`

# Para los scripts "variables.sh" y "funciones.sh" se asume que estan en el mismo directorio que "script1.sh"
# Si estuviesen en otro directorio, bastaria indicarlo explicitamente
# Las comillas son necesarias por si una de las carpetas de "DIRRAIZ" contiene espacios
. "${DIRRAIZ}/variables.sh"
. "${DIRRAIZ}/funciones.sh"

# Comprueba si una variable no tiene valor
#        comprobar_variable   par1  par2  par3
#   + "par1": nombre del comando que usa esa variable
#   + "par2": nombre de la variable
#   + "par3": valor actual de la variable a comprobar
#  Se usa la variable SALIDA de forma global para recuperar la salida de la función "return" solo
#  admite devolver valores numéricos
SALIDA=""
comprobar_variable()
{
  # echo "Comprobando variable \"$2\""

  if [ -z "$3" ]; then
    PREG=0
    while [ "0" -eq "${PREG}" ]; do
       PREG=1
       echo
       echo "La variable \"$2\" esta vacia"
       echo
       echo  "¿Desea indicar algun parametro para el comando \"$1\"? (S/N): "
       read RESP
       case ${RESP} in
          S | s)
              echo "Introduzca el parametro deseado para \"$1\": "
              read PAR
              SALIDA=$PAR
              ;;
           N | n)
              :
              ;;
          *)
              echo
              echo "Opcion incorrecta"
              echo
              echo "Pulse intro para continuar..."
              read REPLY
              PREG=0
              ;;
       esac
    done
  fi
}


clear
echo
echo "Aplicacion para la gestión básica del estado de la red"
echo

comprobar_variable "config" "CONFIG" $CONFIG
if [ -z $CONFIG ]; then CONFIG=$SALIDA; fi

comprobar_variable "arp" "ARP" $ARP
if [ -z $ARP ]; then ARP=$SALIDA; fi

comprobar_variable "route" "ROUTE" $ROUTE
if [ -z $ROUTE ]; then ROUTE=$SALIDA; fi



MENU=0
while [ "0" -eq ${MENU} ]; do
  clear
  echo
  echo "Script de gestion basica del estado de la red."
  echo
  echo "Operaciones disponibles:"
  echo "1) Activar la interfaz de red ${IFACE}"
  echo "2) Desactivar la interfaz de red ${IFACE}"
  echo "3) Mostrar el estado de su configuracion de red"
  echo "4) Salir."
  echo
  echo "Opcion seleccionada: "
  read OPCION
  case ${OPCION} in
    1)
       arranque_red
       ;;
    2)
       parada_red
       ;;
    3)
      echo $CONFIG ${ARP} ${ROUTE}
       estado_red ${CONFIG} ${ARP} ${ROUTE}
       ;;
    4)
      MENU=1
       ;;
    *)
       echo
       echo "Opcion incorrecta"
       echo
       echo "Pulse intro para continuar..."
       read REPLY
       MENU=0
       ;;
   esac
done
~~~

> NOTA:
>> Comando `arp`:
    
>>`arp`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Address Resolution Protocol* Descubrir la dirección física o ó *MAC* de un dispositivo de nuestra red haciendo uso de su dirección *IP*. Muestra y manipula la tabla cache ARP del sistema.

>>`arp -n`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;mostrara direcciones IP en vez de nombres de nodos. 

>>`arp -a 192.168.1.3`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;se le especifica que solo muestre la entrada *ARP* para el nodo *192.168.1.3*. Si no se le especifica un nodo, mostrará todas las entradas *ARP* de la tabla cache (similar a ejecutar el comando `arp` *sin parámetros*).

>>`arp -d 192.168.1.3`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;la entrada del nodo *192.168.1.3* es eliminada de la tabla *ARP*.

>>`arp -s 192.168.1.3 11:11:11:11:11:11`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;añade a la tabla *ARP* una entrada para el nodo *192.168.1.3*

---

>> Comando `route`:
    
>>`route`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;consultar el contenido de la *tabla de enrutamiento* del sistema que contiene las direcciones de los nodos a los que podrán enviarse paquetes a través de la red.

>>`route -n`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;consultar el contenido de la *tabla de enrutamiento* del sistema.

>>>La información que nos ofrece el comando:

* *Destino*: Las redes o hosts a las que pueden ir destinados los paquetes. si su valor es *0.0.0.0* indica que el destino puede ser cualquiera.
* *Pasarela*: Las puertas de enlace que se utilizarán. Un valor *0.0.0.0* indicará cualquier red.
* *Genmask*: Las máscaras de red que se utilizarán en cada caso.
* *Indic*: Informa sobre el estado de la ruta. Una *U* significa que se encuentra activa, una *G* que utiliza una puerta de enlace y una *H* que el destino es un Host.
* *Metric*: Muestra la distancia al objetivo y suele medirse en saltos.
* *Ref*: Si la tabla de enrutamiento perteneciese a un router, aquí tendríamos el número de referencias que se le harían desde otros nodos. Cuando pertenece al núcleo del sistema operativo, su valor es cero.
* *Uso*: Cuenta las búsquedas para esa ruta.
* *Interfaz*: Identifica el adaptador de red al que estamos haciendo referencia. Si nuestro ordenador tuviese más de uno, aparecerían un nuevo conjunto de líneas en la tabla de enrutamiento para definir sus características.

>>`route -e`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;mostramos la *tabla de enrutamiento* en formato *hostname*.

>>`sudo route add -net 192.168.0.0 netmask 255.255.255.0 gw 192.168.1.1 dev enp0s3`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;añadir una nueva ruta estática para que todos los paquetes enviados a la red *192.168.0.0/24* sea dirigido a la interfaz  *enp0s3* y use la puerta de enlace *192.168.1.1*.

>>`sudo route del -net 192.168.0.0 netmask 255.255.255.0 gw 192.168.1.1 dev enp0s3`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Elimina la entrada anterior de la *tabla de enrutamiento*.

3. `script_copy.sh`: script que copie un fichero regular en otro, ambos pasados como argumentos. Si no se le pasan los argumentos, lo comprobará, y solicitará al usuario que los introduzca interactivamente.

    `script_copy.sh`

~~~
#!/bin/sh

# FAST: Script para la copia de un fichero en otro

ORIGEN=$1
DESTINO=$2
if [ "$#" -lt 2 ]
then
   printf "No ha usado la sintaxis completa: script_copy.sh [origen] [destino]\n"
   if [ -z "$ORIGEN"  ]
   then
      printf "Introduzca el fichero origen: "
      read ORIGEN
   fi
   if [ -z "$DESTINO"  ]
   then
      printf "Introduzca el fichero destino: "
      read DESTINO
   fi
fi

if [ ! -f "$ORIGEN" ]
then
       printf "\nEl fichero origen \"$ORIGEN\" no existe.\n\n"
elif [ -f "$DESTINO" ]
then
    PREG=0
    while [ "0" -eq ${PREG} ]; do
       PREG=1
       printf "¿Desea sobreescribirlo (S/N)? "
       read RESP
       case ${RESP} in
          S | s)
              printf "Realizando la copia: cp %s %s\n" $ORIGEN $DESTINO
              cp "$ORIGEN" "$DESTINO"
              ;;
           N | n)
              printf "\"%s\" no copiado" $ORIGEN
              exit 0
              ;;
          *)
              printf "\nOpción incorrecta\n\n"
              printf "Pulse intro para continuar..."
              read REPLY
              PREG=0
              ;;
       esac
    done
else
    printf "Realizando la copia: cp %s %s\n" $ORIGEN $DESTINO
    cp "$ORIGEN" "$DESTINO"
fi
~~~

> NOTA:
>> Comando `cp`:
    
>>`cp`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Copy Files* Copiar ficheros.

>>`cp fichero1 fichero2`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;copiar el *fichero1* en *fichero2*. Si *fichero2* no existía lo crea, y si existía lo sobreescribe.

>>`cp -r Fotos_movil /run/media/Datos`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;copia la carpeta *Fotos_movil* y todo su contenido (la opción **-r** o *“recursive”* indica que debe copiar la carpeta y el contenido de la misma) dentro de la ruta */run/media/Datos*.

>>`cp -r -u -v Fotos_movil /run/media/Datos`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;la opción **-u** (*“update“*) para que actualice el contenido en la carpeta destino y sólo copie aquellas fotos o datos que **no** estuvieran ya en el destino. Y con la opción **-v** (*“verbose“*) el comando muestra en pantalla las tareas que va realizando. También se pueden escribir las opciones del comando como: `cp -ruv Fotos_movil /run/mediaDatos`

4. `script_print.sh`: script que imprima en pantalla el contenido de un fichero de datos, o el contenido de todos los ficheros de un directorio, según se le pase como argumento un *fichero regular* o un *directorio*.

`script_print.sh`

~~~
#!/bin/sh

# FAST: Script para la impresion del contenido del fichero (o de los ficheros del
# directorio) pasado como argumento

clear

if [ -f $1 ]; then
 printf "Impresión en pantalla del fichero \"$1\":\n\n"
 cat $1 | more
elif [ -d $1 ]; then
 printf "Impresión en pantalla de los ficheros del directorio \"$1\":\n\n"
 cd $1; cat * | more
else
 printf "\"$1\" no es un fichero ni un directorio\n"
fi

~~~

5. `script_borrar.sh`: script que borre con confirmación todos los ficheros pasados como argumentos.

`script_borrar.sh`

~~~
#!/bin/sh

# FAST: Script para el borrado de los ficheros pasados como argumentos

# No hay ningún problema en usar comodines en los ficheros pasados, dado que son
# interpretados por el comando "rm"

for fichero in $*
do
   # El parametro "-i" obliga a pedir confirmación
   rm -i $fichero
done


# Solución alternativa
# while [ "$*" != "" ]
# do
# 	rm -i $1
# 	shift
# done
~~~

> NOTA:
>> Comando `rm`:
    
>>`rm`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;eliminar archivos de un directorio.

>>`rm -ir tmp`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;eliminará *reiterativamente* los contenidos de todos los subdirectorios en el directorio **tmp**, *pidiendo confirmación* para la eliminación de cada archivo, y después elimina el propio directorio **tmp**.

>> `rm -f tmp`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Elimina todos los archivos en un directorio sin preguntar al usuario.

6. `script_sesiones.sh`: script al que, pasándole el login de un usuario, devuelva cuántas sesiones tiene abiertas en el sistema.

`script_sesiones.sh`

~~~
#!/bin/sh

# FAST: Script que imprime el número de sesiones actuales del usuario pasado como argumento
if test -z "$1"; then
	set `id -un`  # $1=nombre del usuario actual
fi
sesiones=`who | grep -e "^$1 " | wc -l`
printf "El usuario \"%s\" tiene abiertas %d sesiones\n" $1 $sesiones
~~~

> NOTA:
>> Comando `id`:
    
>>`id`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;muestra el identificador actual y real de usuarios y grupos.

>>`id -u`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Muestra el **ID** del usuario efectivo como un número.

>>`id -u -n`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Muestra el *nombre* del usuario efectivo.

---

>> Comando `grep`:
    
>>`grep`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;selecciona y muestra las líneas de los archivos que coincidan con la cadena o patrón dados.

>>`grep -e "^hola " archivotexto`&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Busca en *archivotexto* el patrón (opción **-e**) *hola* y un espacio (patrón **^** significa que *empiece por*).

7. `script_mostrar.sh`: script que para cada argumento que reciba (puede recibir una lista de argumentos) realice una de las siguientes operaciones:
   * Si es un directorio, ha de listar los ficheros que contiene.
   * Si es un fichero regular, tiene que imprimir su contenido por pantalla.
   * En otro caso, debe indicar que no es ni un fichero regular ni un directorio (por ejemplo, un fichero de bloques o de caracteres del directorio */dev*).

`script_mostrar.sh`

~~~
#!/bin/sh

# FAST: Script para la impresion del contenido de los ficheros y listado de los directorios pasados como argumentos

clear

for fich in $*
do
   echo
   if [ -d "$fich" ]; then
      echo "Mostrando el listado del directorio \"$fich\":"
      ls -la "$fich" | more
   elif [ -f "$fich" ]; then
      echo "Mostrando el contenido del archivo \"$fich\":"
      cat "$fich"
   else
      echo "El parametro \"$fich\" no corresponde con ningun archivo ni directorio"
   fi
done

~~~

8. `script_ejecucion.sh`: script que asigne el permiso de ejecución a los ficheros regulares o directorios pasados como argumento (puede admitir una lista de ficheros).

`script_ejecucion.sh`

~~~
#!/bin/sh

# FAST: Script para la asignación del permiso de ejecución a los ficheros pasados como argumentos


for fich in $*
do
    if [ -f "$fich" ]; then
         echo "Asignando permiso de ejecución (de usuario) al fichero '$fich'..."
         chmod u+x "$fich"
    elif [ -d "$fich" ]; then
         echo "Asignando permiso de ejecución (de usuario) al directorio '$fich'..."
         chmod u+x "$fich"
    else
        echo "El parámetro '$fich' no corresponde con ningún fichero ni directorio"
    fi
done

~~~

9. `script_doble.sh`: script que pida un número por teclado y calcule su doble. Comprobará que el número introducido es válido y, antes de terminar, preguntará si deseamos calcular otro doble, en cuyo caso no terminará.

`script_doble.sh`

~~~
#!/bin/sh

# FAST: Script que calcula el doble de un número solicitado

#Función que comprueba si el valor del primer argumento es un número entero
comprueba_entero()
{
    echo $1 | grep -q "^-\?[0-9]\+$" 2>&1
    #devuelve 0 si $1 cumple el patrón del grep: comienza con un "-" opcional,
    # seguido de digitos del 0 al 9 y termina. En caso contrario devuelve 1
}

SEGUIR=0
while [ "$SEGUIR" -eq "0" ]; do
    clear
    printf "CALCULO DEL VALOR DOBLE DE UN NUMERO\n"
    # Recuerde que en las expresiones aritmeticas, las cadenas de caracteres
    # son interpretadas como el valor "0"
    printf "Introduzca un número entero: "
    read num
    if [ -z "$num" ]; then
        printf "No ha introducido ningún valor\n"
    elif ! comprueba_entero "$num"; then
	printf "El valor introducido no es un número entero\n"
    else
        printf "2 * %d = %d\n" $num $((2*$num))
    fi
    printf "\nSi desea calcular otro doble, escriba \"S\" [N]: "
    read RESP
    if [ "$RESP" != "S" -a "$RESP" != "s" ]; then
       SEGUIR=1
    fi
done

~~~

10. `script_tipos.sh`: script que devuelva el número de ficheros de cada tipo (ficheros regulares o directorios) que hay en una determinada carpeta, así como sus nombres. Tendrá un único argumento (opcional) que será la carpeta a explorar. Si se omite dicho argumento, se asumirá el directorio actual. Devolverá 0 (éxito) si se ha invocado de forma correcta o 1 (error) en caso contrario.

`script_tipos.sh`

~~~
#!/bin/sh

# FAST: Script que calcula el número de ficheros de cada tipo (regulares/directorios) en una carpeta

clear
DIR=$1
if [ -z "$DIR" ]; then
   printf "Sin argumentos. Usando el directorio actual '$(pwd)'\n"
   DIR=`pwd`
elif [ ! -d "${DIR}" ]; then
   printf "El parámetro introducido no corresponde con un directorio\n"
   exit 1
fi

printf "\nFicheros regulares/Directorios de la carpeta '$DIR':\n\n"

NFICH=0
NDIR=0
for arch in `ls "$DIR"`
do
    if [ -f "$DIR/$arch" ]; then
        NFICH=$(($NFICH+1))
        printf "Fichero regular: $arch\n"
    elif [ -d "$DIR/$arch" ]; then
        NDIR=$(($NDIR+1))
        printf "Directorio: $arch\n"
    fi
done

printf "\nRESUMEN:\n\
	  Número de ficheros regulares: $NFICH\n \
	  Número de directorios: $NDIR\n"

# Innecesario:
# exit 0

~~~

11. `script_user.sh`: script que reciba como argumento el login de un usuario e imprima por pantalla la siguiente información: login, nombre completo del usuario, directorio home, shell que utiliza, número de sesiones actualmente abiertas y procesos pertenecientes a dicho usuario. El script debe permitir las siguientes opciones:
   * `-p`: sólo muestra la información de los procesos.
   * `-u`: muestra toda la información excepto la referente a los procesos.
   * `--help`: muestra información de ayuda (uso del script).

El script debe comprobar si los argumentos pasados son correctos, así como la existencia del usuario indicado. Como código de error podrá devolver 0 (éxito), 1 (sintaxis de invocación errónea), 2 (usuario no existe).

`script_user.sh`

~~~
#!/bin/sh

# FAST: Script que imprime información del usuario pasado como argumento
# Sintaxis:
#   script_user.sh         user
#   script_user.sh  -p     user
#   script_user.sh  -u     user
#   script_user.sh  --help user
#
# + "-p": solo muestra la información de los procesos
# + "-u": mostrar toda la información salvo la referente a los procesos
# "--help": muestra la sintaxis de uso del script
# NOTA: Los parámetros pueden estar antes o después del "user"

#### VARIABLES ####
PARp="N"
PARu="N"
PARh="N"
USER="N"


#### FUNCIONES ####
# Función que permite obtener el nombre del script actual
# para cualquiera de las posibles formas de invocación
NOMBRE=""
nombre_script()
{
  # Esta función es opcional
  # Comprobamos si se ha usado ".  script" o "bash  script"
  NOMBRE=`basename $BASH_SOURCE 2> /dev/null`
  CHECK=$?
  if [ $CHECK -ne 0 ]; then
     # Si no se ha usado ". script", sino "script" o "/ruta/script"
     NOMBRE=`basename $0`
  fi
}

# Función que imprime la sintaxis de uso del script
ayuda()
{
   nombre_script
   cat <<- FIN
		Script que imprime información del usuario pasado como argumento

		Sintaxis:
		${NOMBRE}         user
		${NOMBRE}  -p     user
		${NOMBRE}  -u     user
		${NOMBRE}  --help user

		Parametros:
		  -p	 	solo muestra la información de los procesos
		  -u	 	mostrar toda la información salvo la referente a los procesos
		  --help	muestra la sintaxis de uso del script
		NOTA: Los parámetros pueden estar antes o después del "user"

	FIN

}


# Función que busca en el fichero pasado como primer argumento ($1) las lineas cuyo
# campo de la posición N=$2 (empezando por "0") tenga EXACTAMENTE el valor X=$3, usando el
# carácter o caracteres "S"=$4 como separador de campos.
# Devuelve en la variable global "LINEAS" las líneas que cumplan ese requisito
# Sintaxis:  buscar_lineas  "$VAR"         N     "X"       "S"
# Ejemplo:   buscar_lineas  "/etc/passwd"  "0"   "dit"   ":"

# Variable de entorno "IFS": permite indicar el separador entre campos (por ejemplo,
# entre los argumentos pasados a un script, una función o de un bucle "for i in CAMPOS")
# Si no esta definida, el separador adoptado por el interprete es un "espacio", una tabulación
# o un cambio de línea  (valor usado en general; por ejemplo, los argumentos pasados
# a un script se separan pos espacios)

LINEAS=""
buscar_lineas()
{
   # Reseteamos la variable de salida
   LINEAS=""
   # Para cada linea del fichero
   while read linea
   do
      IFS="$4"
      CONT=0
      # Para cada uno de los campos de la linea
      for palabra in $linea
      do
         # Buscamos el campo de la posición "N=$2" y comprobamos si
         # su valor es "X=$3". En caso afirmativo, añadimos la linea a "SAL"
         if [ $CONT -eq $2 -a "$palabra" = "$3" ]; then
             # En la variable "LINEAS" seguimos añadiendo el retorno de carro "\n"
             # Para separar las líneas
             LINEAS="$LINEAS\n$linea"
         fi
         CONT=$((CONT+1))
      done
   done < $1

   # NOTA: "$1" debe ser el nombre de un fichero

   # Eliminamos la variable IFS para que el shell vuelva a usar su valor por omisión
   unset IFS
}


# Función que busca en la cadena pasada "LINEA=$1" el campo ubicado en
# la posición "N=$2" indicada, usando el carácter "S=$3" como separador de campos
# devolviendo el valor de dicho campo en la variable global "CAMPO"
# Sintaxis:  extraer_campo  "LINEA"   POS   "SEPARADOR"
# Ejemplo:   extraer_campo  "$LINEA"  2     ":"
CAMPO=""
extraer_campo()
{
    # Reseteamos la variable de salida
    CAMPO=""

    # Extraemos de dicha línea el valor del campo ubicado en la "posicion=$2"
    # Y lo devolvemos en la variable "CAMPO"
    IFS="$3"
    CONT=0
    for i in $1
    do
        if [ $CONT -eq $2 ]; then CAMPO=$i; fi
        CONT=$((CONT+1))
    done

    unset IFS
}


# Los datos del usuario (Nombre completo, HOME, shell, ...) se definen en /etc/passwd
# (esa información es impresa por comandos como "finger usuario"; también podría ser
# capturada de la salida de estos comandos insertándola en variables)
# Dichos campos se encuentran separados por el carácter ":"
# Para extraer dichos campos puede hacerse uso de la variable "IFS"

# La siguiente función se encarga de consultar el fichero "/etc/passwd" y guardar
# en la variable global "CAMPO" el valor del campo, del usuario paso como primer
# argumento, ubicado en la posicion indicado en el segundo argumento
# Sintaxis:                         datos_passwd   usuario   posicion
# Ejemplo (extraer HOME de afast):  datos_passwd   "afast"   5
#  POSICION    CAMPO
#    0		LOGIN
#    1		CLAVE
#    2		UID
#    3		GID
#    4		NOMBRE COMPLETO
#    5		HOME
#    6		SHELL
datos_passwd()
{
    SEPARADOR=":"

    # Pueden plantearse dos mecanismos para extraer esta información del fichero "passwd":
    # 1) Usando los comandos "grep" y "cut" ("cut" numera con "1" al primer campo, no con "0")
    #    CAMPO=`grep -e "^$1:.*" /etc/passwd | cut -d "${SEPARADOR}" -f $(($2+1)) -`

    # Si en lugar de buscar la línea de "/etc/passwd" por el usuario, se desee buscar por otro
    # campo, bastaría ajustar la expresión regular. Por ejemplo, para buscarla por el GID sería:
    # grep -e ".*:.*:.*:1000:.*" /etc/passwd


    # 2) Mediante funciones del shell y la variable "IFS":
    # Buscar la línea de /etc/passwd asociada al usuario $1 (resultado en variable "LINEAS")
    buscar_lineas  "/etc/passwd"  "0"   "$1"   "${SEPARADOR}"
    # De dicha línea del usuario $1, extraer el campo
    extraer_campo  "$LINEAS"  "$2"   "${SEPARADOR}"
}


#### CUERPO DEL SCRIPT ####

# Obtenemos los parámetros pasados en la invocación del script
NUMPARAM=0
for param in $*
do
   if    [ "$param" = "-p" ];     then
      PARp="S"
      NUMPARAM=$((NUMPARAM+1))
   elif  [ "$param" = "-u" ];     then
      PARu="S"
      NUMPARAM=$((NUMPARAM+1))
   elif  [ "$param" = "--help" ]; then
      PARh="S"
      NUMPARAM=$((NUMPARAM+1))
   else
      USER=$param
   fi
done

# Analizamos los parámetros detectados
# Solo debe haber un párametro, son incompatibles
if [ $NUMPARAM -gt 1 ]; then
   printf "\nDemasiados parámetros\n"
   ayuda
   exit 1
fi

# Comprobamos la existencia del usuario
id $USER > /dev/null 2>&1
if [ $? -eq 1 ]; then
    printf "\nEl usuario introducido como argumento no existe\n"
    exit 2
fi

# Procesamos los argumentos
# Parámetro de ayuda "--help"
if [ "$PARh" = "S" ]; then
   ayuda
   exit 0
fi

# Salida de información condicionada por los otros argumentos
printf "\nScript que imprime información del usuario pasado como argumento\n"
printf "\nUsuario indicado: $USER\n"

# Si NO se ha puesto "-p", se imprime la información propia del usuario
if [ "$PARp" = "N" ]; then
   # Obtenemos el nombre completo del usuario
   datos_passwd  $USER   4
   if [ $? -eq 0 ]; then
       NOMBRE_COMPLETO=$CAMPO
   else
       NOMBRE_COMPLETO="No obtenido"
   fi

   # Obtenemos el HOME
   datos_passwd  $USER   5
   if [ $? -eq 0 ]; then
       HOME_USER=$CAMPO
   else
       HOME_USER="No obtenido"
   fi

   # Obtenemos el SHELL por defecto
   datos_passwd  $USER   6
   if [ $? -eq 0 ]; then
       SHELL_USER=$CAMPO
   else
       SHELL_USER="No obtenido"
   fi

   # Imprimimos la informacion
   cat <<- FIN
	+ Login:               $USER
	+ Nombre completo:     $NOMBRE_COMPLETO
	+ Directorio "home":   $HOME_USER
	+ Shell por defecto:   $SHELL_USER
	+ Número de sesiones actualmente abiertas: `who | grep $USER | wc -l`

	FIN

fi

# Si NO se ha puesto "-u", se imprime la información de los procesos del usuario
if [ "$PARu" = "N" ]; then
    printf "\nProcesos pertenecientes al usuario $USER: \n"

    # Pueden plantearse dos mecanismos para extraer esta información del fichero "passwd":
    # 1) Usando el comando grep (la salida de "ps" usa espacios como separadores)
    #    ps aux | grep -e "^${USER} " | more

    # 2) Mediante funciones del shell y la variable "IFS":
    # Guardar la salida de "ps aux" en un fichero (la entrada estándar al "while" de
    # la funciones "buscar_lineas" debe ser un fichero)
    FICHERO_TMP="/tmp/procesos_${USER}_`date +%H:%M:%S_%d-%m-%Y`"
    ps aux > "${FICHERO_TMP}"

    # Buscar en ese fichero las líneas asociadas al usuario $USER (ubicado en el primer campo de cada línea)
    SEPARADOR=" "
    buscar_lineas  "${FICHERO_TMP}"  "0"   "$USER"   "${SEPARADOR}"

    # Borramos el fichero temporal
    rm -f ${FICHERO_TMP}

    # Obtenemos en "LINEAS" los procesos del usuario $USER. Los imprimimos
    echo $LINEAS

    # Respecto a la salida normal de "ps", se esta perdiendo la tabulación de las columnas
    # dado que los espacios se estan usando como separador "IFS"
fi

~~~

12. `script_menu.sh`: script que ofrezca al usuario un menú (con una opción para salir) desde el que el usuario pueda seleccionar cual de los scripts anteriores (apartados "b)" a "k)") quiere utilizar.

`script_menu.sh`

~~~
#!/bin/sh

# FAST: Script con un menú para usar los demas scripts

# Asumimos que los demás scripts se encuentran en el mismo directorio que este
# y que poseen permiso de ejecución
# Obtenemos el directorio en que se encuentra el script actual
DIRRAIZ=`dirname $0`/

MENU=0
while [ "0" -eq ${MENU} ]; do
  OPCION=""
  ARCHIVOS=""
  USUARIO=""
  PARAMETROS=""
  clear
  cat << EOF
Menú de acceso a los demás scripts

Seleccione el script que desea usar:

 1) "script1.sh":          Administración básica del estado de la red
 2) "script_copy.sh":      Copia de un fichero en otro
 3) "script_print.sh":     Impresión del contenido de un fichero (o ficheros de un directorio)
 4) "script_borrar.sh":    Borrado de los ficheros indicados
 5) "script_sesiones.sh":  Número de sesiones actuales del usuario indicado
 6) "script_mostrar.sh":   Impresión del contenido de ficheros o listado de los directorios indicados
 7) "script_ejecucion.sh": Asignación del permiso de ejecucion a los ficheros indicados
 8) "script_doble.sh":     Calculo del valor doble de un numero
 9) "script_tipos.sh":     Calculo del numero de ficheros "regulares/directorios" en una carpeta
10) "script_user.sh":      Información del usuario indicado

 q) Salir.

Opcion seleccionada: 
EOF

  read OPCION
  echo
  case ${OPCION} in
    1)
      # No usamos ".  script" porque conlleva algunas dificultades:
      # 1º Estariamos usando el mismo espacio de variables para este script y para los invocados
      # 2º Si un script usa "exit", se saldrá de este script también
      "${DIRRAIZ}"script1.sh
      ;;
    2)
      "${DIRRAIZ}"script_copy.sh
      ;;
    3)
      echo "Introduzca el fichero o directorio a imprimir: "
      read ARCHIVOS
      "${DIRRAIZ}"script_print.sh ${ARCHIVOS}
      ;;
    4)
      echo "Introduzca los ficheros a borrar: "
      read ARCHIVOS
      "${DIRRAIZ}"script_borrar.sh ${ARCHIVOS}
      ;;
    5)
      echo "Introduzca el login del usuario cuyo Nº de sesiones desea conocer: "
      read USUARIO
      "${DIRRAIZ}"script_sesiones.sh ${USUARIO}
      ;;
    6)
      echo "Introduzca los ficheros o directorios a imprimir o listas: "
      read ARCHIVOS
      "${DIRRAIZ}"script_mostrar.sh ${ARCHIVOS}
      ;;
    7)
      echo "Introduzca los ficheros a los que asignar permiso de ejecución: "
      read ARCHIVOS
      "${DIRRAIZ}"script_ejecucion.sh ${ARCHIVOS}
      ;;
    8)
      "${DIRRAIZ}"script_doble.sh
      ;;
    9)
      echo "Introduzca la carpera de la que desea hacer el analisis: "
      read ARCHIVOS
      "${DIRRAIZ}"script_tipos.sh ${ARCHIVOS}
      ;;
    10)
      clear
      echo "Introduzca el usuario (con --help para más información): "
      read PARAMETROS
      "${DIRRAIZ}"script_user.sh ${PARAMETROS}
      ;;
    q)
       MENU=1
       exit 0
       ;;
    *)
       printf "\nOpción incorrecta\n\nPulse intro para continuar..."
       read REPLY
       MENU=0
       ;;
   esac
   echo
   echo "Pulse intro para continuar..."
   read REPLY
done

~~~


13. `script_puerto.sh`: script que reciba como argumento un número de puerto *TCP* (PUERTO) y comprobará si el valor es un número entero positivo en el rango *"[1, 1023]"*, de modo que:
   * Si es así: el script analizará si los puertos *TCP "PUERTO"* y *"PUERTO+1"* del equipo local se encuentran a la escucha. Tras ello, imprimirá un mensaje indicando el estado obtenido. Para ello, puede analizar la salida del comando `netstat`.
   * En otro caso: imprimirá por pantalla un mensaje indicando que el valor indicado no es un puerto de sistema.

`script_puerto.sh`

~~~
#!/bin/sh


if [ $# -eq 1 ]; then
    PUERTO=$1
    COMANDO="/bin/netstat -t -l -n"

    if [ $PUERTO -ge 1 -a $PUERTO -le 1023 ]; then
        for p in $PUERTO $((PUERTO+1)); do
            $COMANDO 2> /dev/null | grep ":$p" > /dev/null 2>&1
            [ $? = 0 ] && ESTADO="a la escucha" || ESTADO="NO a la escucha"
            echo Puerto TCP local \"$p\" $ESTADO
        done
    else
        echo El puerto indicado no es del sistema
    fi
else
    echo Uso $0 PUERTO_TCP_ENTRE_1_Y_1023
fi

~~~

14. `script_arp.sh`: script que reciba como argumento un número entero, guardándolo en la variable *POS_ARP*. El script comprobará si el valor de la variable *POS_ARP* es un número entero positivo, de modo que:
   * Si es así: el script calculará el número de entradas que actualmente tiene la caché *ARP* del equipo, guardándolo en la variable *NENTRADAS*. Si el valor de *POS_ARP* es mayor que *NENTRADAS*, imprimirá por pantalla un mensaje tal como: *Ninguna entrada en la posición POS_ARP*. En caso de que *POS_ARP* sea menor o igual que *NENTRADAS*, imprimirá por pantalla un mensaje con la posición de la entrada *ARP POS_ARP*, seguido del contenido de dicha entrada *ARP*.
   * En otro caso: Imprimirá por pantalla un mensaje indicando que el valor indicado no es un número entero: *Posición de entrada ARP no válida*

Se solicitan dos posibles soluciones:

   * `script_arp1.sh`: Basada en el comando `read` y *estructuras de control*.
   * `script_arp2.sh`: Analizando la salida del comando `arp` mediante comandos de análisis de texto.

`script_arp1.sh`

~~~
#!/bin/sh

NARP=$1

if [ $NARP -ge 1 ] 2> /dev/null; then
    # Calculamos el numero de entradas de la Tabla ARP
    NENTRADAS=$(($(/usr/sbin/arp -n 2> /dev/null | wc -l)-1))

    if [ $NARP -gt $NENTRADAS ]; then
        echo "Ninguna entrada ARP en la posicion \"$NARP\""
    else
        # Si la entrada pedida existe, se imprime
        # La entrada "N" se encuentra en la linea "N+1" de la salida de arp

        # Solucion A basada en estructuras de control
        LIN=0
        /usr/sbin/arp -n | while read linea ; do
            LIN=$((LIN+1))
            [ $LIN -eq $(($NARP+1)) ] && { 
		        echo "Entrada \"$NARP\" de la cache: "
                echo "$linea"; }
        done

    fi
else
    echo "Posicion de entrada ARP no valida"
fi

~~~

`script_arp2.sh`

~~~
#!/bin/sh

NARP=$1

if [ $NARP -ge 1 ] 2> /dev/null; then
    # Calculamos el numero de entradas de la Tabla ARP
    NENTRADAS=$(($(/usr/sbin/arp -n 2> /dev/null | wc -l)-1))

    if [ $NARP -gt $NENTRADAS ]; then
        echo "Ninguna entrada ARP en la posicion \"$NARP\""
    else
        # Si la entrada pedida existe, se imprime
        # La entrada "N" se encuentra en la linea "N+1" de la salida de arp

        # Solucion B basada en los comandos "head" y "tail"
        SAL=$(/usr/sbin/arp -n  2> /dev/null | head -n $(($NARP+1)) | tail -n 1)
        if ! [ -z "$SAL" ]; then
            echo "Entrada \"$NARP\" de la cache ARP:"
            echo "$SAL"
        else
            echo "Error"
        fi

    fi
else
    echo "Posicion de entrada ARP no valida"
fi

~~~

15. `script_param.sh`: Considere que en el shell actual se dispone de la variable:

`VAR="nombre=v1&edad=v2&tlf=v3"`

Escriba un shell-script que analice el valor de dicha variable y para cada uno de los parámetros extraiga su valor y lo imprima por pantalla. Por ejemplo, que la salida sea:

`Cadena analizada: nombre=v1&edad=v2&tlf=v3 nombre: v1, edad: v2, tlf: v3.`

Se solicitan dos posibles soluciones:
   * `script_param1.sh`: Usando la variable de entorno `IFS`.
   * `script_param2.sh`: Sin usar `IFS`.

`script_param1.sh`

~~~
#!/bin/sh
#Analisis de cadena tipo "nombre=valor1&edad=valor2&telefono=valor3"
NOMBRE=
EDAD=
TELEFONO=

asignaValor()
{
    CAMPO=$1
    VALOR=$2
    case $CAMPO in
	nombre)
	    NOMBRE=$VALOR;;
	edad)
	    EDAD=$VALOR;;
	telefono)
	    TELEFONO=$VALOR;;
    esac
}

QUERY_STRING=$1

# Contamos el número de parámetros y guardamos los dos primeros
IFS="&"      # Variable shell con el carácter de separación
for PAR in $QUERY_STRING
do
    # Extraemos el nombre y valor de los dos primeros parámetros
    IFS="="    # Carácter de separacion entre nombre y valor
    asignaValor $PAR
done

printf "Cadena analizada: '%s'\n" "$QUERY_STRING"
printf "Nombre: %s, Edad: %s, Teléfono: %s.\n"  "$NOMBRE" "$EDAD" "$TELEFONO"

~~~

`script_param2.sh`

~~~
#!/bin/sh
#Analisis de cadena tipo "nombre=valor1&edad=valor2&telefono=valor3"
NOMBRE=
EDAD=
TELEFONO=

asignaValor()
{
    CAMPO=$1
    VALOR=$2
    case $CAMPO in
	nombre)
	    NOMBRE=$VALOR;;
	edad)
	    EDAD=$VALOR;;
	telefono)
	    TELEFONO=$VALOR;;
    esac
}

CADENA_PROCESO=""
CADENA_PARA_ANALIZAR=$1
# El bucle se ejecuta mientras la cadana vaya cambiando en cada pasada
while [ "$CADENA_PROCESO" != "$CADENA_PARA_ANALIZAR" ]
do
    CADENA_PROCESO=$CADENA_PARA_ANALIZAR
    # Extraemos el nombre y valor de los dos primeros parámetros
    PAR=${CADENA_PROCESO%%&*} #quitamos desde el primer &
    asignaValor "${PAR%=*}" "${PAR#*=}"  #campo=valor
    #Actualizamos CADENA_PARA_ANALIZAR
    #quitamos hasta el primer & incluido
    CADENA_PARA_ANALIZAR=${CADENA_PROCESO#*&} 
done

printf "Cadena analizada: '%s'\n" "$1"
printf "Nombre: %s, Edad: %s, Teléfono: %s.\n"  "$NOMBRE" "$EDAD" "$TELEFONO"

~~~

---

## Ejercicio Extra

Realizar un Shell Script de UNIX/Linux que simule el comando `find`. Podrá recibir de uno a tres parámetros:
- En caso de ser uno, será el *fichero* a buscar en el *directorio actual*.
- En caso de ser dos, será una de las siguientes opciones:
   *  *Directorio* (ruta completa) y *fichero* a buscar en ella.
   *  *Fichero* y opcion *“-s”*; buscará el fichero en la *ruta actual* y sus
*subdirectorios*.
- En caso de ser tres serán *directorio* (ruta completa), *fichero* y opcion *“-s”*; buscará
el fichero en la ruta y sus subdirectorios. Ejemplos:
   `Buscar fichero`
   `Buscar directorio fichero`
   `Buscar fichero -s`
   `Buscar directorio fichero –s`

Se valorará la eficiciencia y control de errores. No se podrá usar los comando `find` ni `ls`.

`script_buscar.sh`

~~~

~~~

---