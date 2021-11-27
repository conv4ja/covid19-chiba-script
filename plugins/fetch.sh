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
data_dir=${1:-.}

for source_uri in \
https://www.pref.chiba.lg.jp/shippei/press/2019/documents/${now}kansensya.xlsx; \
do
	file_name=${data_dir:?data_dir not specified}/${source_uri##*/}
	curl \
		--progress-bar \
		-L $source_uri \
		-o ${file_name:?file_name is not specified} \
		>&2 || throw cannot fetch $source_uri
	sleep 1
done
echo ${file_name}
