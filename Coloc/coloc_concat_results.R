library(data.table)
library(R.utils)
library(stringr)

# Args command
args = commandArgs(T)
main_dir = args[1]
coloc_file = args[2]
output_file = args[3]

x = ifelse(str_sub(main_dir, -1) == "/", "yes", "no")

if (x == "yes"){
    coloc_files = data.frame(name = paste0(main_dir,list.files(main_dir, pattern = coloc_file)))
} else {
    coloc_files = data.frame(name = paste0(main_dir,"/",list.files(main_dir, pattern = coloc_file)))
}

coloc_files = str_sort(coloc_files$name, numeric = T)
#print(coloc_files)
df1 = data.frame()
for (i in coloc_files){
    df2 = fread(i, header = T)
    df_bind = rbind(df1, df2)
    df1 = df_bind
}

write.table(df_bind, output_file, quote = FALSE, row.names = F, col.names = TRUE, sep = "\t")
gzip(output_file)
