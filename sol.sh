#!/bin/bash

if [ $# -lt 1 ]
then
	echo "Uso: $0 <aplicación>"
	exit 1
fi

PIDS=$(pidof $1)

if [ $? != 0 ] # No hay proceso para la aplicación: se lanza.
then
	$1 &
	exit 0
fi

WFILE=$(mktemp /tmp/solwXXXX)
wmctrl -pl | awk  -v pat="$PIDS" -f sol.awk > $WFILE

case "$(cat $WFILE | wc -l)" in
0) # Proceso sin ventana, no hacer nada
	;;

1|2) # Una sola ventana: se activa.
	wmctrl -ia $(head -1 $WFILE)
	;;

*) # Más de una ventana: hay que elegir qué ventana mostrar.
	V=$(cat $WFILE | \
     	 zenity --list --title "Elige ventana" --text=$1 \
       	     --column "Código" --column "Título" --hide-column=1)

	[ -n "$V" ] && wmctrl -ia $V # Si se ha elegido una ventana se muestra.
	;;
esac

rm -f $WFILE
