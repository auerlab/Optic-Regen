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
#SBATCH --output=Data/1-trim/1a-merge-%A_%a.out
#SBATCH --error=Data/1-trim/1a-merge-%A_%a.err

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
for day in 0 2 4 12; do
    for rep in 1 2 3; do
	for end in 1 2; do
	    output=$merged/${day}ATAC-${rep}-R${end}.fastq.gz
	    if [ ! -e $output ]; then
		echo $output
		cat ${day}ATAC-${rep}_*_R${end}*.fastq.gz > $output
	    fi
	done
    done
done

# No d7 r1
for day in 7; do
    for rep in 2 3; do
	for end in 1 2; do
	    output=$merged/${day}ATAC-${rep}-R${end}.fastq.gz
	    if [ ! -e $output ]; then
		echo $output
		cat ${day}ATAC-${rep}_*_R${end}*.fastq.gz > $output
	    fi
	done
    done
done
exit

cat 0ATAC-1_*_R1*.fastq.gz > $merged/0ATAC-1-R1.fastq.gz
cat 0ATAC-1_*_R2*.fastq.gz > $merged/0ATAC-1-R2.fastq.gz
cat 0ATAC-2_*_R1*.fastq.gz > $merged/0ATAC-2-R1.fastq.gz
cat 0ATAC-2_*_R2*.fastq.gz > $merged/0ATAC-2-R2.fastq.gz
cat 0ATAC-3_*_R1*.fastq.gz > $merged/0ATAC-3-R1.fastq.gz
cat 0ATAC-3_*_R2*.fastq.gz > $merged/0ATAC-3-R2.fastq.gz

cat 2ATAC-1_*_R1*.fastq.gz > $merged/2ATAC-1-R1.fastq.gz
cat 2ATAC-1_*_R2*.fastq.gz > $merged/2ATAC-1-R2.fastq.gz
cat 2ATAC-2_*_R1*.fastq.gz > $merged/2ATAC-2-R1.fastq.gz
cat 2ATAC-2_*_R2*.fastq.gz > $merged/2ATAC-2-R2.fastq.gz
cat 2ATAC-3_*_R1*.fastq.gz > $merged/2ATAC-3-R1.fastq.gz
cat 2ATAC-3_*_R2*.fastq.gz > $merged/2ATAC-3-R2.fastq.gz

cat 4ATAC-1_*_R1*.fastq.gz > $merged/4ATAC-1-R1.fastq.gz
cat 4ATAC-1_*_R2*.fastq.gz > $merged/4ATAC-1-R2.fastq.gz
cat 4ATAC-2_*_R1*.fastq.gz > $merged/4ATAC-2-R1.fastq.gz
cat 4ATAC-2_*_R2*.fastq.gz > $merged/4ATAC-2-R2.fastq.gz
cat 4ATAC-3_*_R1*.fastq.gz > $merged/4ATAC-3-R1.fastq.gz
cat 4ATAC-3_*_R2*.fastq.gz > $merged/4ATAC-3-R2.fastq.gz

cat 7ATAC-2_*_R1*.fastq.gz > $merged/7ATAC-2-R1.fastq.gz
cat 7ATAC-2_*_R2*.fastq.gz > $merged/7ATAC-2-R2.fastq.gz
cat 7ATAC-3_*_R1*.fastq.gz > $merged/7ATAC-3-R1.fastq.gz
cat 7ATAC-3_*_R2*.fastq.gz > $merged/7ATAC-3-R2.fastq.gz

cat 12ATAC-1_*_R1*.fastq.gz > $merged/12ATAC-1-R1.fastq.gz
cat 12ATAC-1_*_R2*.fastq.gz > $merged/12ATAC-1-R2.fastq.gz
cat 12ATAC-2_*_R1*.fastq.gz > $merged/12ATAC-2-R1.fastq.gz
cat 12ATAC-2_*_R2*.fastq.gz > $merged/12ATAC-2-R2.fastq.gz
cat 12ATAC-3_*_R1*.fastq.gz > $merged/12ATAC-3-R1.fastq.gz
cat 12ATAC-3_*_R2*.fastq.gz > $merged/12ATAC-3-R2.fastq.gz

### RNASeq
cat 0RNA1_*R1*.fastq.gz > $merged/0RNA1-R1.fastq.gz
cat 0RNA1_*R2*.fastq.gz > $merged/0RNA1-R2.fastq.gz
cat 0RNA2_*R1*.fastq.gz > $merged/0RNA2-R1.fastq.gz
cat 0RNA2_*R2*.fastq.gz > $merged/0RNA2-R2.fastq.gz
cat 0RNA3_*R1*.fastq.gz > $merged/0RNA3-R1.fastq.gz
cat 0RNA3_*R2*.fastq.gz > $merged/0RNA3-R2.fastq.gz

cat 2RNA1_*R1*.fastq.gz > $merged/2RNA1-R1.fastq.gz
cat 2RNA1_*R2*.fastq.gz > $merged/2RNA1-R2.fastq.gz
cat 2RNA2_*R1*.fastq.gz > $merged/2RNA2-R1.fastq.gz
cat 2RNA2_*R2*.fastq.gz > $merged/2RNA2-R2.fastq.gz
cat 2RNA3_*R1*.fastq.gz > $merged/2RNA3-R1.fastq.gz
cat 2RNA3_*R2*.fastq.gz > $merged/2RNA3-R2.fastq.gz

cat 4RNA1_*R1*.fastq.gz > $merged/4RNA1-R1.fastq.gz
cat 4RNA1_*R2*.fastq.gz > $merged/4RNA1-R2.fastq.gz
cat 4RNA2_*R1*.fastq.gz > $merged/4RNA2-R1.fastq.gz
cat 4RNA2_*R2*.fastq.gz > $merged/4RNA2-R2.fastq.gz
cat 4RNA3_*R1*.fastq.gz > $merged/4RNA3-R1.fastq.gz
cat 4RNA3_*R2*.fastq.gz > $merged/4RNA3-R2.fastq.gz

cat 7RNA1_*R1*.fastq.gz > $merged/7RNA1-R1.fastq.gz
cat 7RNA1_*R2*.fastq.gz > $merged/7RNA1-R2.fastq.gz
cat 7RNA2_*R1*.fastq.gz > $merged/7RNA2-R1.fastq.gz
cat 7RNA2_*R2*.fastq.gz > $merged/7RNA2-R2.fastq.gz
cat 7RNA3_*R1*.fastq.gz > $merged/7RNA3-R1.fastq.gz
cat 7RNA3_*R2*.fastq.gz > $merged/7RNA3-R2.fastq.gz

cat 12RNA1_*R1*.fastq.gz > $merged/12RNA1-R1.fastq.gz
cat 12RNA1_*R2*.fastq.gz > $merged/12RNA1-R2.fastq.gz
cat 12RNA2_*R1*.fastq.gz > $merged/12RNA2-R1.fastq.gz
cat 12RNA2_*R2*.fastq.gz > $merged/12RNA2-R2.fastq.gz
cat 12RNA3_*R1*.fastq.gz > $merged/12RNA3-R1.fastq.gz
cat 12RNA3_*R2*.fastq.gz > $merged/12RNA3-R2.fastq.gz

