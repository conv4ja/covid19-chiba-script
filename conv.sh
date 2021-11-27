#!/bin/sh -ex

basedir=${0%/*}
PATH=${basedir:?basedir not set}/plugins:$PATH

[ ! -d $basedir/data ] && mkdir -vp $basedir/data 

case "$1" in
	all)
		fetch.sh $basedir/data | {
			read file_name
			conv.py ${file_name:?cannot parse file_name for conv.py!}
			fix.sh
		}
		;;
	fetch)
		fetch.sh $basedir/data
		;;
	target)
		conv.py ${1:?対象ファイル名を指定してください}
		fix.sh
		;;
	help|*)
		echo 'usage: ${0##*/} <all|fetch|target>'
		;;
esac
