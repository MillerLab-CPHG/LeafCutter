#!/bin/bash
#SBATCH -N 2
#SBATCH -n 16
#SBATCH -t 10:00:00
#SBATCH -p parallel
#SBATCH -A cphg-millerlab

#Prepare .vcf for snpeff use
#zcat ../PCA/UVA_coronary_hg38_merged_imputed_filtered.vcf.gz | awk 'BEGIN{OFS="\t"} {print $1,$2,$3,$4,$5,$6,$7,$8,$9}' > UVA_coronary_hg38_merged_imputed_filtered_snpEFF.vcf

#Run snpeff to annotate variants
#java -jar ~/snpEff/snpEff.jar -geneId -no-downstream -no-upstream  GRCh38.86 ./UVA_coronary_hg38_merged_imputed_filtered_snpEFF.vcf > UVA_coronary_hg38_merged_imputed_filtered_snpEFF.ann.vcf

#Run snpsift to extract annotation of interest
#java -jar ~/snpEff/SnpSift.jar extractFields -s "," -e "." UVA_coronary_hg38_merged_imputed_filtered_snpEFF.ann.vcf CHROM POS ID REF ALT "ANN[*].EFFECT" > UVA_coronary_hg38_merged_imputed_filtered_snpEFF.ann.effect.vcf

#bgzip the effect .vcf file
module load htslib/1.9
bgzip -l 9 UVA_coronary_hg38_merged_imputed_filtered_snpEFF.ann.effect.vcf
