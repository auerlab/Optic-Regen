#!/bin/sh -e

for file in Results/09-remove-duplicates/*.bam; do
    printf "===\n$file\n\n"
    samtools view $file | tail -1
done | more
