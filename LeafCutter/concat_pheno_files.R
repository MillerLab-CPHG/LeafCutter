library(stringr)
library(data.table)
library(R.utils)

# Args command
args=commandArgs(T)
main_dir=args[1]
file_pattern=args[2]
output_file=args[3]


x = ifelse(str_sub(main_dir, -1) == "/", "yes", "no")

if (x == "yes"){
    pheno_files = data.frame(name = paste0(main_dir,list.files(main_dir, pattern = file_pattern)))
} else {
    pheno_files = data.frame(name = paste0(main_dir,"/",list.files(main_dir, pattern = file_pattern)))
}

pheno_files = str_sort(pheno_files$name, numeric = T)
#print(pheno_files)

df1 = data.frame()
for (i in pheno_files){
    df2 = fread(i, header = T)
    df_bind = rbind(df1, df2)
    df1 = df_bind
}

write.table(df1, output_file, quote = FALSE, row.names = F, col.names = TRUE, sep = "\t")
gzip(output_file)
