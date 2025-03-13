#!/bin/sh -e

proper_name=Reference/cdna.sh
if [ $0 != "$proper_name" ]; then
    printf "$0 must be run as $proper_name\n"
    printf "from inside the Reference directory.\n"
    exit 1
fi

# Need GTF for kallisto quant --genomebam in any case
Reference/fetch-gtf.sh

fetch=$(../../Common/find-fetch.sh)
build=$(../../Common/genome-build.sh)
species_prefix=$(../../Common/species-prefix.sh)
species_dir=$(../../Common/species-dir.sh)
release=$(../../Common/genome-release.sh)
awk=$(../../Common/find-awk.sh)
transcriptome=$(Reference/transcriptome-filename.sh)

# Can't guarantee this file will always be available.
# You may need to edit this.
cd Results/07-reference
cdna=$species_prefix$build.cdna.all.fa.gz
if [ ! -e $cdna ]; then
    $fetch ftp://ftp.ensembl.org/pub/release-$release/fasta/$species_dir/cdna/$cdna
else
    printf "$cdna already exists.  Remove and rerun to replace.\n"
fi

set -x
zcat $cdna | $awk -F : -f ../../Reference/keep-autosomes.awk > cdna-$transcriptome
