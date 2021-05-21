#!/bin/sh -e

files=""
chr=1
while [ $chr -le 25 ]; do
    files="$files Danio_rerio.GRCz11.dna.chromosome.$chr.fa.gz"
    chr=$(( $chr + 1 ))
done
autosome_file=Danio_rerio.GRCz11.dna.autosomes.fa
if [ ! -e $autosome_file ]; then
    printf "Concatenating $files to $autosome_file...\n"
    gzcat $files > $autosome_file
fi
