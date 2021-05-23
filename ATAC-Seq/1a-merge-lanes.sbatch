#!/bin/sh -e

##########################################################################
#   Script description:
#       Concatenate all files across lanes
#       
#   History:
#   Date        Name        Modification
#   2021-05-19  Jason Bacon Adapt from Andrea Rau's Optic Regen 2019
##########################################################################

#SBATCH --mem=100
#SBATCH --output=Data/1-trim/1a-merge-%j.out
#SBATCH --error=Data/1-trim/1a-merge-%j.err

usage()
{
    printf "Usage: $0\n"
    exit 1
}

##########################################################################
#   Main
##########################################################################

if [ $# != 0 ]; then
    usage
fi

cd ../Raw/BCAUAGANXX
merged=Merged-lanes
mkdir -p $merged

##########################################################################
#   gzip files can simply be contatenated without unzipping first
##########################################################################

# ATAC-Seq
for day in 0 2 4 7 12; do
    for rep in 1 2 3; do
	for paired_end in 1 2; do
	    atac_merged=$merged/${day}ATAC-${rep}-R${paired_end}.fastq.gz
	    if [ ! -e $atac_merged ]; then
		echo $atac_merged
		# No 7ATAC-1, so remove empty redirect output after failure
		if ! cat ${day}ATAC-${rep}_*_R${paired_end}*.fastq.gz > $atac_merged; then
		    rm $atac_merged
		fi
	    fi
	    rna_merged=$merged/${day}RNA-${rep}-R${paired_end}.fastq.gz
	    if [ ! -e $rna_merged ]; then
		echo $rna_merged
		cat ${day}RNA${rep}_*_R${paired_end}*.fastq.gz > $rna_merged
	    fi
	done
    done
done
