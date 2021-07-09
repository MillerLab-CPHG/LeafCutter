#!/bin/bash

### UVA-CPHG MILLER LAB'S LEAFCUTTER PIPELINE ###

#Flags:
main_dir="/project/cphg-millerlab/CAD_QTL/coronary_QTL/transcriptome/LeafCutter"
analysis="diff_splicing_analysis"
run_index="finalrun"
tissue="CA"
annotation_code="GRCh38.37"

#prefix.txt --> File with list of prefixes to name analyses. Ex: Ischemic_vs_Normal, Ischemic_vs_Nonischemic, Nonischemic_vs_Normal

module load gcc/7.1.0 openmpi/3.1.4 R/4.0.0 python/3.6.8

###################################################################################################################################################
### LEAFCUTTER STEP1: INTRON CLUTERING ####
#cat ${main_dir}/${analysis}_${run_index}/prefix.txt | while read prefix || [[ -n $line ]];
#do
#    step1_job_id_${prefix}=$(sbatch -A cphg-millerlab \
#                                    -p parallel \
#                                    -t 24:00:00 \
#                                    --mem=25g \
#                                    -N 2 \
#                                    -n 20 \
#                                    --wrap="python ${main_dir}/${analysis}_${run_index}/leafcutter_cluster_regtools.py -k \
#                                                   -j ${main_dir}/${analysis}_${run_index}/${prefix}/${prefix}_juncfiles.txt \
#                                                   -m 50 \
#                                                   -l 100000 \
#                                                   -p 0.001 \
#                                                   -o ${tissue}_${prefix} \
#                                                   -r ${main_dir}/${analysis}_${run_index}/${prefix}")
#done
###################################################################################################################################################

###################################################################################################################################################
### LEAFCUTTER STEP2: DIFFERENTIAL SPLICING ANALYSIS ###
cat ${main_dir}/${analysis}_${run_index}/prefix.txt | while read prefix || [[ -n $line ]];
do
    step2_${prefix}_job=$(sbatch -A cphg-millerlab \
                                    -p parallel \
                                    -t 24:00:00 \
                                    --mem=25g \
                                    -N 2 \
                                    -n 20 \
                                    --wrap="Rscript ${main_dir}/${analysis}_${run_index}/leafcutter_ds.R \
                                                    -e ${main_dir}/${analysis}_${run_index}/gencode.v37.exons.txt.gz \
                                                    -o ${main_dir}/${analysis}_${run_index}/${prefix}/${tissue}_${prefix} \
                                                    ${main_dir}/${analysis}_${run_index}/${prefix}/${tissue}_${prefix}_perind_numers.counts.gz \
                                                    ${main_dir}/${analysis}_${run_index}/${prefix}/${prefix}_group_file.txt")
done
###################################################################################################################################################

###################################################################################################################################################
### LEAFCUTTER STEP 3:  PREPARE LEAFCUTTER DS RESULTS FOR RDATA SUMMARY ###
cat ${main_dir}/${analysis}_${run_index}/prefix.txt | while read prefix || [[ -n $line ]];
do
    step3_${prefix}_job=$(sbatch -d afterok:$step2_${prefix}_job \
                                    -A cphg-millerlab \
                                    -p parallel \
                                    -t 24:00:00 \
                                    --mem=25g \
                                    -N 2 \
                                    -n 20 \
                                    --wrap="Rscript ${main_dir}/${analysis}_${run_index}/prepare_results.R \
                                                    -m ${main_dir}/${analysis}_${run_index}/${prefix}/${prefix}_group_file.txt \
                                                    -c ${tissue}_${prefix}_ds \
                                                    ${main_dir}/${analysis}_${run_index}/${prefix}/${tissue}_${prefix}_perind_numers.counts.gz \
                                                    ${main_dir}/${analysis}_${run_index}/${prefix}/${tissue}_${prefix}_cluster_significance.txt \
                                                    ${main_dir}/${analysis}_${run_index}/${prefix}/${tissue}_${prefix}_effect_sizes.txt \
                                                    ${main_dir}/${analysis}_${run_index}/${annotation_code} \
                                                    -f 0.05 \
                                                    -o ${main_dir}/${analysis}_${run_index}/${prefix}/${tissue}_${prefix}_${run_index}.RData")
done
###################################################################################################################################################
