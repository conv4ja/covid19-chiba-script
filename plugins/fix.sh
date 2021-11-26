#!/bin/sh -ex
outdir=out
[ -d "$outdir" ] && mkdir -vp "$outdir"
sed -i -e s/\^,//g $outdir/data.csv
sed -i -e "s/\.[0-9]*//g" -e "s/^,/日付,/g"  $outdir/chiba-plain.csv
