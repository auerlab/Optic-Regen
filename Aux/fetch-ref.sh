#!/bin/sh -e

# release=$(../../RNA-Seq/Reference/reference-release)
release=104
# Used 99 for first ATAC run
# release=99
site=ftp://ftp.ensembl.org/pub/release-$release/fasta/danio_rerio/dna
curl --continue-at - --remote-name $site/CHECKSUMS $site/README

chr=1
while [ $chr -le 25 ]; do
    file=Danio_rerio.GRCz11.dna.chromosome.$chr.fa.gz
    printf "Downloading $file...\n"
    curl --continue-at - --remote-name $site/$file
    chr=$(( $chr + 1 ))
done
