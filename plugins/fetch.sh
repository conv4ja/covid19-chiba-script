#!/bin/sh -ex

throw(){ echo $*; exit 1; }

#set -o xtrace
year=2021
month=$(date +%m)
day=$(expr $(date +%d) - 1)
: ${now:=${month}${day}}
: ${now2:=${year}${month}0${day}}

base_uri=https://www.pref.chiba.lg.jp/shippei/press/2019/documents
fname=patients

for source_uri in \
https://www.pref.chiba.lg.jp/kenfuku/kansenshou/ncov/documents/${now}chibacoronadata.xlsx \
https://www.pref.chiba.lg.jp/shippei/press/2019/documents/${now}chibacoronashihyou.pdf \
https://www.pref.chiba.lg.jp/shippei/press/2019/documents/${now}kansensya.xlsx \
https://www.pref.chiba.lg.jp/kenfuku/kansenshou/ncov/documents/${now2}iryouken.xlsx \
https://www.pref.chiba.lg.jp/kenfuku/kansenshou/ncov/documents/${now2}shicyouson.xlsx \
https://www.pref.chiba.lg.jp/kenfuku/kansenshou/ncov/documents/${now}cluster.pdf \
https://www.pref.chiba.lg.jp/kenfuku/kansenshou/ncov/documents/${now}nendaibetsu.pdf 
do
	curl --progress-bar -L $source_uri -o ${1:-.}/${source_uri##*/}  || throw cannot fetch $source_uri
	sleep 1
done
