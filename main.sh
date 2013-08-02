#!/bin/bash

SELLO=$1
DESTINO=$2
ORIGEN=$3

RUTA=`dirname $0`

if [ -z "$*" ]; then
	cat $RUTA/usage
	exit 1
fi

if [ ! -f "$SELLO" ]; then
	echo "Archivo '$SELLO' no existe"
	cat $RUTA/usage
	exit 2
fi

#echo $ORIGEN
#if [ ! -d "$ORIGEN" ]; then
#	echo "Carpeta '$ORIGEN' no existe"
#	cat $RUTA/usage
#	exit 3
#fi

if [ ! -d "$DESTINO" ]; then
	echo "Carpeta '$DESTINO' no existe"
	cat $RUTA/usage
	exit 4
fi

if [ "$ORIGEN" -ef "$DESTINO" ]; then
	echo "Las carpetas de origen y de destino son iguales"
	cat $RUTA/usage
	exit 5
fi

SELLOPDF=`mktemp /tmp/ppdf_XXXXX.pdf`
convert $SELLO -transparent white -background none $SELLOPDF
CARPETATMP=`mktemp -d /tmp/ppdf_XXXXX`
PASSWD=`mktemp -u XXXXXXXXXXXXXXXXXXXXX`
PREFIJO=`mktemp -u XXXXX`

IFS="
"
shift
shift
ls -d "$@" 2> /dev/null | while read archivo
do
	if [ -d "$archivo" ]; then
		break
	fi
	nm=`basename "$archivo"`
	extension="${nm##*.}"
	nombresolo="${nm%.*}"
	ndestino="${nombresolo}_wm.$extension"
	echo "Estampando '$DESTINO/$ndestino"
	pdftk "$archivo" stamp $SELLOPDF output "$CARPETATMP/$ndestino" 2> /dev/null
	if [ $? -eq 0 ]; then
		echo "Bloqueando '$DESTINO/$ndestino'"
		pdftk "$CARPETATMP/$ndestino" output "$DESTINO/$ndestino" owner_pw $PASSWD 
	else
		echo "'$archivo' no es un archivo PDF o no existe"
	fi
done

rm $SELLOPDF
rm -r $CARPETATMP



