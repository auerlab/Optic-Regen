#!/bin/sh -e

##########################################################################
#   Script description:
#       Organize files and create directories needed for analysis
#
#       Link raw files to standardized names for that clearly describe
#       conditions and replicates, and are easily parsed by subsequent
#       scripts.
#
#       Researchers involved in sample-prep generally don't think about
#       how filename conventions impact bioinformatics analysis, so this
#       simple step can avoid confusion throughout the pipeline.  In
#       addition, linking this way can correct for sample mixups, etc.
#
#       Use links to preserve the original files and document the mapping.
#       
#   History:
#   Date        Name        Modification
#   2021-09-25  Jason Bacon Begin
##########################################################################

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

mkdir -p Data Logs
scripts=$(ls 0[2-9]-* 1[0-9]-*)
for script in $scripts; do
    stage=${script%.*}
    mkdir -p Data/$stage Logs/$stage
done

##############################################################################
# RNA-Seq:
#
#   7RNA3_GTTTCG_L006_R1_001.fastq.gz
#
#   The number before RNA in the filename (0,2,4,7,12) indicates
#   time in days.
#
#   The digit after RNA represents the replicate (1,2,3).
#
#   The digit after R is the read (1 = forward, 2 = reverse)
#
##############################################################################

cd Data
mkdir -p Raw-merged Raw-renamed
cd Raw-renamed
sample=1
time_step=1
for day in 0 2 4 7 12; do
    for rep in 1 2 3; do
	for read in 1 2; do
	    orig=$(ls ../../../Raw/BCAUAGANXX/${day}RNA${rep}_*_R${read}*.fastq.gz)
	    merged=../Raw-merged/${day}RNA-${rep}-merged-R${read}.fastq.gz
	    readable=sample$sample-rep$rep-time$time_step-R$read.fastq.gz
	    printf "$readable -> $merged\n"
	    if [ ! -e $merged ]; then
		cat $orig > $merged
	    fi
	    ln -sf $merged $readable
	done
	sample=$((sample + 1))
    done
    time_step=$((time_step + 1))
done
