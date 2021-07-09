#!/bin/bash

### UVA-CPHG MILLER LAB'S LEAFCUTTER FILE PREP PIPELINE ###

#Flags:
samples_list="/project/cphg-millerlab/CAD_QTL/coronary_QTL/transcriptome/LeafCutter/diff_splicing_analysis_finalrun"
BAM_dir="/project/cphg-millerlab/CAD_QTL/coronary_QTL/transcriptome/STAR_WASP/persample_2pass_run2"
JUNC_dir="/project/cphg-millerlab/CAD_QTL/coronary_QTL/transcriptome/LeafCutter/junc_files/unfiltered_junc"

##################################################################################################
### INDEX BAM FILES WITH SAMTOOLS ###
#module load samtools/1.10
#cat ${samples_list}/samples.txt | while read sample || [[ -n $line ]];
#do 
#    sbatch -A cphg-millerlab \
#           -p parallel \
#           -t 1:00:00 \
#           --mem=10g \
#           -N 2 \
#           -n 20 \
#           --job-name=${sample}_index_log.out \
#           --wrap="samtools index ${BAM_dir}/${sample}_Aligned.sortedByCoord.out.bam"
#done
##################################################################################################


##################################################################################################
### JUNCTION FILE CREATION ###
cat ${samples_list}/samples.txt | while read sample || [[ -n $line ]];
do
    sbatch -A cphg-millerlab \
           -p parallel \
           -t 1:00:00 \
           --mem=10g \
           -N 2 \
           -n 20 \
           --job-name=${sample}_junc_log.out \
           --wrap="regtools junctions extract \
                            -a 8 \
                            -m 50 \
                            -s 0 \
                            -M 100000 \
                            ${BAM_dir}/${sample}_Aligned.sortedByCoord.out.bam \
                            -o ${JUNC_dir}/${sample}.bam.junc" 
done
##################################################################################################


#Make sure to filter unwanted/unknown chromosomes from junc files and then gzip them
