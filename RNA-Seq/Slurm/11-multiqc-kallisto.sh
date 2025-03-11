#!/bin/sh -e

if which srun > /dev/null; then
    srun=srun
else
    srun=''
fi

# multiqc: LC_ALL and LANG must be set to a UTF-8 character set
# in your environment in order for the click module to function.
export LC_ALL=en_US.UTF-8

cd Results/11-multiqc-kallisto
rm -rf *

$srun multiqc --version > ../../Logs/11-multiqc-kallisto/multiqc-version.txt 2>&1
$srun multiqc ../10-qc-kallisto 2>&1 | tee ../../Logs/11-multiqc-kallisto/multiqc.out

