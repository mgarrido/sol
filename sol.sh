#!/bin/bash

PID=$(ps ax -o "pid,comm" | grep $1$ | cut -d\   -f2)

echo PID: $PID

COUNT=$(echo $PID | wc -w)

#echo Hay $COUNT instancias

case "$COUNT" in
0)
	#echo hay que lanzar la app
	$1 &
	;;
1)
	#echo hay que enfocarla
	wmctrl -ia $(wmctrl -lp | fgrep $PID | cut -f1 -d\ )
	;;
*)
	#echo hay que sacar una lista
	;;
esac
