#!/bin/bash

if [ $# -lt 1 ]
then
	echo "Uso: $0 <aplicación>"
	exit 1
fi

PSFILE=$(mktemp /tmp/solXXXX)

ps x -o "pid,comm" | grep -i " $1$" > $PSFILE

if [ $? != 0 ] # No hay proceso para la aplicación: se lanza.
then
	$1 &
	rm -f $PSFILE
	exit 0
fi

WFILE=$(mktemp /tmp/solwXXXX)

wmctrl -pl | sort -bg --key=3 | join -1 1 -2 3 $PSFILE - > $WFILE

case "$(cat $WFILE | wc -l)" in
0) # Proceso sin ventana, no hacer nada
	;;

1) # Una sola ventana: se activa.
	wmctrl -ia $(cut -f3 -d\  $WFILE)
	;;

*) # Más de una ventana: hay que elegir qué ventana mostrar.
	V=$(awk '{print $3; $1=$2=$3=$4=$5=""; sub(/^  */,"", $0); print $0}' $WFILE |\
     	    zenity --list --title "Elige ventana" --text=$1 \
       		--column "Código" --column "Título" --hide-column=1)

	[ -n "$V" ] && wmctrl -ia $V # Si se ha elegido una ventana se muestra.
	;;
esac

rm -f $PSFILE $WFILE
