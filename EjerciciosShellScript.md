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

>>`sudo route del -net 192.168.0.0 netmask 255.255.255.0 gw 192.168.1.1 dev enp0s3``&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Elimina la entrada anterior de la *tabla de enrutamiento*.

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