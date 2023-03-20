#!/bin/sh -e

if which srun > /dev/null; then
    srun=srun
else
    srun=''
fi

# multiqc: LC_ALL and LANG must be set to a UTF-8 character set
# in your environment in order for the click module to function.
export LC_ALL=en_US.UTF-8

cd Results/18-multiqc-hisat2
rm -rf *

$srun multiqc --version > ../../Logs/18-multiqc-hisat2/multiqc-version.txt 2>&1
$srun multiqc ../17-qc-hisat2 2>&1 | tee ../../Logs/18-multiqc-hisat2/multiqc.out

