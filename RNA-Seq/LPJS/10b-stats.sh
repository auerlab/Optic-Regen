#!/bin/sh -e

printf "Total features:\n"
wc -l Results/10-fasda-kallisto/*.txt

printf "\nFeatures with P-values < 0.05:\n"
for file in Results/10-fasda-kallisto/*.txt; do
    printf "$(awk '$8 < 0.05' $file | wc -l) $file\n"
done
