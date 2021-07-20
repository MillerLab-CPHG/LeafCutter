library(data.table)
library(dplyr)
library(stringr)
library(ggplot2)
library(ggrepel)

cluster_sig = fread("DS_analyses/finalrun/CA_Nonischemic_vs_Normal_cluster_significance.txt")
cluster_sig = cluster_sig[cluster_sig$status == "Success",]

effect = fread("DS_analyses/finalrun/CA_Ischemic_vs_Nonischemic_effect_sizes.txt")
temp1 = str_split_fixed(effect$intron, ":", 4)
effect$cluster = paste0(temp1[,1],":",temp1[,4])

df1 = inner_join(effect, cluster_sig, by = c("cluster" = "cluster"))
df1$abs_deltapsi = abs(df1$Nonischemic - df1$Normal) #Remember to change the conditions

df2 = group_by(df1, cluster) %>% summarise(max_deltapsi=max(abs_deltapsi)) 

df1$cluster_psi = paste0(df1$cluster,":",df1$abs_deltapsi)
df2$cluster_psi = paste0(df2$cluster,":",df2$max_deltapsi)

df3 = inner_join(df1, df2, by = c("cluster_psi"="cluster_psi"))
df3 = df3[!duplicated(df3$cluster.x),]

pval_threshold = 1e-6 #Calculate cluster-level significance

#df3$significant = ifelse(df3$p.adjust > pval_threshold, NA, "Significant") #Sets boolean variable to know which clusters are above significant thresholds for pvalue and deltapsi in volcano plot

df3$significant = ifelse(df3$p.adjust > pval_threshold, NA,
                         ifelse(df3$deltapsi < 0, "Significant_b0", 
                         ifelse(df3$deltapsi > 0, "Significant_a0", NA)))

df3$genes = ifelse(is.na(df3$genes), df3$intron, df3$genes)

ggplot(df3, aes(x=deltapsi, y=-log10(p.adjust), color=significant)) +
  geom_point(size = 1) +
  scale_color_manual(values = c("orangered", "skyblue2"), na.value="gray89") +
  geom_vline(xintercept = 0, color="black", size=0.5, linetype=2) +
  geom_hline(yintercept = -log10(pval_threshold), color="black", size=0.5, linetype=2) +
  geom_label_repel(data = subset(df3, df3$significant == "Significant_b0" | df3$significant == "Significant_a0"), aes(label=genes), size=3, col="black") +
  xlab(expression(Delta*"PSI")) +
  ylab(bquote(~-Log[10]~ 'Adjusted P-value')) +
  ggtitle("Title") +
  theme_bw() +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5))
  
  

