#!/netscratch/dep_psl/grp_psl/ThomasN/tools/bin/bin/Rscripts
# upset plot
# Ryohei Thomas Nakano; nakano@mpipz.mpg.de; 04 Apri 2022

options(warn=-1)

# clean up
rm(list=ls())

# packages
library(stringr, quietly=T, warn.conflicts=F)
library(UpSetR,  quietly=T, warn.conflicts=F)



# load config
config_path <- commandArgs(trailingOnly=T)[1]
# config_path <- "path/to_your/config_file.R"

source(config_path)
source(paste(scripts, "plotting_parameters.R", sep=""))


# import 
sig <- read.table(paste(stat, "significance_table.txt", sep=""), sep="\t", header=T, row.names=1, check.names=F, stringsAsFactors=F) %>% as.matrix

# up and down
DE_up <- sig
idx <- DE_up != 1
DE_up[idx] <- 0
colnames(DE_up) <- paste(colnames(sig), "_up", sep="")

DE_down <- -sig
idx <- DE_down != 1
DE_down[idx] <- 0
colnames(DE_down) <- paste(colnames(sig), "_down", sep="")

DE_df <- data.frame(ID=rownames(sig), DE_up, DE_down, row.names=NULL)


#
pdf(paste(fig, "upset_diagrams.pdf", sep=""), width=22, height=8)
	upset(DE_df, order.by="freq", sets=colnames(DE_df)[-1], mb.ratio=c(.35, .65), nintersects=150, keep.order=T)
dev.off()

pdf(paste(fig, "upset_diagrams.up.pdf", sep=""), width=22, height=8)
	upset(DE_df, order.by="freq", sets=paste(contrasts$names, "_up", sep=""), mb.ratio=c(.35, .65), nintersects=150, keep.order=T, sets.bar.color=c_dark_green)
dev.off()

pdf(paste(fig, "upset_diagrams.down.pdf", sep=""), width=22, height=8)
	upset(DE_df, order.by="freq", sets=paste(contrasts$names, "_down", sep=""), mb.ratio=c(.35, .65), nintersects=150, keep.order=T, sets.bar.color=c_cudo_magenta)
dev.off()













