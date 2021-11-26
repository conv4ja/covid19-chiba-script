#!/bin/sh -ex

basedir=${0%/*}
PATH=${basedir:?basedir not set}/plugins:$PATH

[ ! -d $basedir/data ] && mkdir -vp $basedir/data 

case "$1" in
	all)
		fetch.sh $basedir/data
		conv.py $basedir/data
		fix.sh
		;;
	fetch)
		fetch.sh $basedir/data
		;;
	conv)
		conv.sh $basedir/data
		fix.sh
		;;
	help|*)
		echo 'usage: ci.sh <all|fetch|conv>'
		;;
esac
