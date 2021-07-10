#!/bin/bash
#SBATCH -N 2
#SBATCH -n 32
#SBATCH -t 50:00:00
#SBATCH -p parallel
#SBATCH -A cphg-millerlab

module load star/2.7.2b

STAR --runMode genomeGenerate \
--genomeDir ./genome_index \
--genomeFastaFiles ./UCSC_hg38.fa \
--sjdbGTFfile ./gencode.v37.annotation.gtf
