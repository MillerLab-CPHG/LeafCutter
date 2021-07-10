library(data.table)
library(R.utils)
library(stringr)
library(stringi)

# Args command
args = commandArgs(T)
main_dir = args[1]
fdr5_files = args[2]
output_file = args[3]

x = ifelse(str_sub(main_dir, -1) == "/", "yes", "no")

if (x == "yes"){
    fdr5_files = data.frame(name = paste0(main_dir,list.files(main_dir, pattern = fdr5_files)))
} else {
    fdr5_files = data.frame(name = paste0(main_dir,"/",list.files(main_dir, pattern = fdr5_files)))
}

fdr5_files = str_sort(fdr5_files$name, numeric = T)

#print(fdr5_files)
df1 = data.frame()
for (i in fdr5_files){
    df2 = fread(i, header = F)
    df_bind = rbind(df1, df2)
    df1 = df_bind
}

write.table(df_bind, output_file, quote = FALSE, row.names = F, col.names = F, sep = "\t")
gzip(output_file)
