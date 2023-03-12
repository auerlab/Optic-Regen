#!/bin/sh -e

if [ $0 != "Reference/build-genome.sh" ]; then
    cat << EOM

$0 must be run as Reference/build-genome.sh.

EOM
    exit 1
fi

fetch=$(../Common/find-fetch.sh)
species_prefix=$(../Common/species-prefix.sh)
species_dir=$(../Common/species-dir.sh)
build=$(../Common/genome-build.sh)
release=$(../Common/genome-release.sh)
genome=$(Reference/genome-filename.sh)
chromosomes=$(../Common/chrom-list.sh)

# Chromosome files
mkdir -p Results/07-reference
cd Results/07-reference
for chromosome in $chromosomes; do
    file=$species_prefix$build.dna.chromosome.$chromosome.fa.gz
    if [ ! -e $file ]; then
	while ! $fetch http://ftp.ensembl.org/pub/release-$release/fasta/$species_dir/dna/$file; do
	    printf "Fetch failed: Retrying...\n"
	done
    fi
    chromosome=$((chromosome + 1))
done

if [ ! -e $genome ]; then
    printf "Concatenating chromosome FASTAs...\n"
    for chrom in $chromosomes; do
	printf "$chrom "
	zcat $species_prefix$build.dna.chromosome.$chrom.fa.gz >> $genome
    done
    printf "\n"
else
    printf "Using existing $genome...\n"
fi

if [ ! -e $genome.fai ]; then
    printf "Creating index $genome.fai...\n"
    samtools faidx $genome      # Speed up gffread
fi
