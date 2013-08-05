#!/bin/bash

RUTA=`dirname $0`

IFS="
"

if [ $# -lt 3 ]; then
	cat $RUTA/usage
	exit 1
fi

SELLO="$1"

if [ -z "`file $SELLO | grep PNG`" ]; then
	echo "'$SELLO' no es una imagen PNG"
	cat $RUTA/usage
	exit 2
fi

argumentos=( "$@" )
num=$#
num=$(( num - 2 ))

DESTINO=${argumentos[ $num + 1 ]}

if [ ! -d "$DESTINO" ];then
	echo "'$DESTINO' no es una carpeta"
	cat $RUTA/usage
	exit 3
fi

for (( i = 1; i <= $num; i++ )); do
	ORIGEN="${argumentos[$i]}"
	nm=`basename "$ORIGEN"` 
	extension="${nm##*.}"
	if [ ! -f "$ORIGEN" ]; then
		echo "'$ORIGEN' no existe o es un directorio"	
	elif [ "$extension" != "pdf" ];then
		echo "'$ORIGEN' no es un archivo PDF"
	elif [ -z $(file "$ORIGEN" | grep "PDF document") ]; then
		echo "'$ORIGEN' no es un archivo PDF"
	else
		$RUTA/./pr.sh "$SELLO" "$DESTINO" "$ORIGEN"
	fi
done



