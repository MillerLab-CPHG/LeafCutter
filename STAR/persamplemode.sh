#!/bin/bash

###2-pass mode for per-sample mode

fastq_dir="PATH_TO_FASTQ_FILES"
vcf_dir="PATH_TO_VCF_FILES_(ONE_PER_SAMPLE)"
out_dir="PATH_TO_OUPUT_DIRECTORY"

module load star/2.7.2b

#samples.txt: 1-column txt file with sample names
cat samples.txt | while read sample_name || [[ -n $line ]];
do
    sbatch -A "ALLOCATION" \
           -p parallel \
           -t 24:00:00 \
	   --mem=50g \
           -N 2 \
           -n 20 \
           --wrap="STAR --genomeDir ./genome_index \
                        --readFilesIn ${fastq_dir}/${sample_name}_1_val_1.fq.gz ${fastq_dir}/${sample_name}_2_val_2.fq.gz \
                        --readFilesCommand zcat \
                        --twopassMode Basic \
                        --sjdbGTFfile ./gencode.v37.annotation.gtf \
                        --outFileNamePrefix ${out_dir}/${sample_name}_ \
                        --outSAMtype BAM SortedByCoordinate \
                        --quantMode TranscriptomeSAM GeneCounts \
                        --outSAMunmapped Within \
                        --waspOutputMode SAMtag \
                        --varVCFfile ${vcf_dir}/${sample_name}.recode.vcf \
                        --outSAMattributes NH HI AS NM MD vW vA vG XS \
                        --outFilterType BySJout \
                        --outFilterMultimapNmax 20 \
                        --outFilterMismatchNmax 999 \
                        --outFilterMismatchNoverReadLmax 0.04 \
                        --alignIntronMin 20 \
                        --alignIntronMax 1000000 \
                        --alignSJoverhangMin 8 \
                        --alignSJDBoverhangMin 1 \
                        --sjdbScore 1 \
                        --limitBAMsortRAM 50000000000"                     
done



