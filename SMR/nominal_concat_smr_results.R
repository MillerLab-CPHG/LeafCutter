library(data.table)
library(R.utils)
library(stringr)
library(stringi)

# Args command
args = commandArgs(T)
main_dir = args[1]
smr_files = args[2]
output_file = args[3]

x = ifelse(str_sub(main_dir, -1) == "/", "yes", "no")

if (x == "yes"){
    smr_files = data.frame(name = paste0(main_dir,list.files(main_dir, pattern = smr_files)))
} else {
    smr_files = data.frame(name = paste0(main_dir,"/",list.files(main_dir, pattern = smr_files)))
}

smr_files = str_sort(smr_files$name, numeric = T)

df1 = data.frame()
for (i in smr_files){
    df2 = fread(i, header = T)
    df_bind = rbind(df1, df2)
    df1 = df_bind
}

write.table(df_bind, output_file, quote = FALSE, row.names = F, col.names = TRUE, sep = "\t")
gzip(output_file)
