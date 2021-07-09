#!/bin/bash

### UVA-CPHG MILLER LAB'S LEAFCUTTER PIPELINE ###

#Flags:
main_dir="/MAIN_PATH_TO_DATA_OR_SCRIPTS"
annotation_code="GRCh38.37"

#prefix.txt --> File with list of prefixes to name analyses. Ex: Ischemic_vs_Normal, Ischemic_vs_Nonischemic, Nonischemic_vs_Normal

module load gcc/7.1.0 openmpi/3.1.4 R/4.0.0 python/3.6.8

###################################################################################################################################################
### LEAFCUTTER STEP1: INTRON CLUTERING ####
cat ${main_dir}/prefix.txt | while read prefix || [[ -n $line ]];
do
    sbatch -A "GROUP" \
           -p parallel \
           -t 24:00:00 \
           --mem=25g \
           -N 2 \
           -n 20 \
           --wrap="python ${main_dir}/leafcutter_cluster_regtools.py -k \
                          -j ${main_dir}/${prefix}/${prefix}_juncfiles.txt \
                          -m 50 \
                          -l 100000 \
                          -p 0.001 \
                          -o ${prefix} \
                          -r ${main_dir}/${prefix}"
done
###################################################################################################################################################

###################################################################################################################################################
### LEAFCUTTER STEP2: DIFFERENTIAL SPLICING ANALYSIS ###
cat ${main_dir}/prefix.txt | while read prefix || [[ -n $line ]];
do
    sbatch -A "GROUP" \
           -p parallel \
           -t 24:00:00 \
           --mem=25g \
           -N 2 \
           -n 20 \
           --wrap="Rscript ${main_dir}/leafcutter_ds.R \
                           -e ${main_dir}/gencode.v37.exons.txt.gz \
                           -o ${main_dir}/${prefix} \
                           ${main_dir}/${prefix}_perind_numers.counts.gz \
                           ${main_dir}/${prefix}_group_file.txt"
done
###################################################################################################################################################

###################################################################################################################################################
### LEAFCUTTER STEP 3:  PREPARE LEAFCUTTER DS RESULTS FOR RDATA SUMMARY ###
cat ${main_dir}/prefix.txt | while read prefix || [[ -n $line ]];
do
    sbatch -A "GROUP" \
           -p parallel \
           -t 24:00:00 \
           --mem=25g \
           -N 2 \
           -n 20 \
           --wrap="Rscript ${main_dir}/prepare_results.R \
                           -m ${main_dir}/${prefix}_group_file.txt \
                           -c ${prefix}_ds \
                           ${main_dir}/${prefix}_perind_numers.counts.gz \
                           ${main_dir}/${prefix}_cluster_significance.txt \
                           ${main_dir}/${prefix}_effect_sizes.txt \
                           ${main_dir}/${annotation_code} \
                           -f 0.05 \
                           -o ${main_dir}/${prefix}.RData"
done
###################################################################################################################################################
