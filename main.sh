#!/bin/bash

SELLO=$1
ORIGEN=$2
DESTINO=$3
RUTA=`dirname $0`

if [ -z "$*" ]; then
	cat $RUTA/usage
	exit 1
fi

if [ ! -f $SELLO ]; then
	echo "Archivo '$SELLO' no existe"
	cat $RUTA/usage
	exit 2
fi

if [ ! -d $ORIGEN ]; then
	echo "Carpeta '$ORIGEN' no existe"
	cat $RUTA/usage
	exit 3
fi

if [ ! -d $DESTINO ]; then
	echo "Carpeta '$DESTINO' no existe"
	cat $RUTA/usage
	exit 4
fi

if [ $ORIGEN -ef $DESTINO ]; then
	echo "Las carpetas de origen y de destino son iguales"
	cat $RUTA/usage
	exit 5
fi

SELLOPDF=`mktemp /tmp/XXXXXXXX.pdf`
convert $SELLO -transparent white -background none $SELLOPDF
CARPETATMP=`mktemp -d`
PASSWD=`mktemp -u XXXXXXXXXXXXXXXXXXXXX`

ls $ORIGEN/*.pdf | while read archivo
do
	nm=`basename "$archivo"`
	echo "Estampando '$DESTINO/$nm'"
	pdftk "$archivo" stamp $SELLOPDF output "$CARPETATMP/$nm"
	echo "Bloqueando '$DESTINO/$nm'"
	pdftk "$CARPETATMP/$nm" output "$DESTINO/$nm" owner_pw $PASSWD
done

rm $SELLOPDF
rm -r $CARPETATMP



