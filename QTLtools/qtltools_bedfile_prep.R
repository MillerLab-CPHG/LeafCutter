library(stringr)
library(data.table)
library(tibble)

# Args command
args=commandArgs(T)
bed_file=args[1]
output_file=args[2]

#Reads bed file to be prepared for QTLtools
if (str_detect(bed_file,'.gz')){
  dummy_file=fread(sprintf('zcat %s',bed_file), skip="Chr")
} else {
  dummy_file=fread(bed_file, skip="Chr")
}

# Add the gid and strand columns
dummy_file = add_column(dummy_file, gid = ".", .after = "ID")
dummy_file = add_column(dummy_file, strand = ".", .after = "gid")

dummy1 = str_split_fixed(dummy_file$ID, ":", 5) #splits out the phenotype id 
dummy_file$gid = dummy1[,5] #assigns phenotype id to gid
dummy2 = str_split_fixed(dummy1[,4], "_", 3) #splits out the strand sign
dummy_file$strand = dummy2[,3] #assigns strand sign to strand column

# Writes output file
write.table(dummy_file, output_file, quote = FALSE, row.names = FALSE, col.names = TRUE, sep = "\t")

