#!/netscratch/dep_psl/grp_psl/ThomasN/tools/bin/bin/Rscripts
# R script to run a GLM analysis; for Defeng Shen (AG Andersen, MPIPZ)
# 12 Nov 2021
# Ryohei Thomas Nakano; nakano@mpipz.mpg.de

options(warn=-1)

# clean up
rm(list=ls())

# packages
library(edgeR,    quietly=T, warn.conflicts=F)
library(stringr,  quietly=T, warn.conflicts=F)
library(dplyr,    quietly=T, warn.conflicts=F)

# load config
config_path <- commandArgs(trailingOnly=T)[1]
config_path <- "path/to_your/config_file.R"

source(config_path)
source(paste(scripts, "plotting_parameters.R", sep=""))

# import 
dat    <- read.table(paste(original_data, "count_table.txt", sep=""), header=T, row.names=1, sep="\t", comment.char="#", stringsAsFactors=F, check.names=F)
design <- read.table(paste(original_data, "design.txt", sep=""), header=T, stringsAsFactors=F, sep="\t")

idx <- match(design$Library, colnames(dat))
dat <- dat[, idx]

write.table(dat,    file=paste(processed_data, "count_table.txt", sep=""), col.names=T, row.names=T, quote=F, sep="\t")




# ========= paramters ========= #

source(paste(scripts, "GLM_parameters.R", sep=""))

# ============================= #





# count list for edgeR
y <- DGEList(counts=dat)

# normalized read counts
log2cpm <- cpm(y, prior.count=.25, log=TRUE)

# extract genes with a least 5 cpm over all samples AND expressed more than 5 counts at least in two samples 
idx <- (rowSums(2^log2cpm) > 10)  & (rowSums(2^log2cpm > 1) >= 2)
y <- y[idx, , keep.lib.sizes=F]

# TMM normalization
y <- calcNormFactors(y)

# estimate dispersion
y <- estimateGLMCommonDisp(y, model)
y <- estimateGLMTrendedDisp(y, model)
y <- estimateGLMTagwiseDisp(y, model)

# Generalized linear model fitting
fit <- glmFit(y, model)

# LRT contrasts
contrast_names <- colnames(contrasts_mat)
n <- length(contrast_names)

# LRT for each contrasts
LRT.list <- lapply(1:n, function(x) glmLRT(fit, contrast=contrasts_mat[,x]))
names(LRT.list) <- contrast_names

# logFC and PValue tables
logFC_P.list <- lapply(1:n, function(x) {
	table <- LRT.list[[x]]$table[,c(1,4)]
	table$PValue <- p.adjust(table$PValue, method=p.adj.method)
	colnames(table) <- paste(contrast_names[x], colnames(table), sep="_")
	return(table)
	})
logFC_P <- do.call(cbind, logFC_P.list)
write.table(logFC_P, file=paste(processed_data, "logFC.P.txt", sep=""), sep="\t", quote=F, col.names=NA, row.names=T)

# transformed normalized read counts
log2cpm <- cpm(y, prior.count=.25, log=TRUE)
write.table(log2cpm, file=paste(processed_data, "log2cpm.txt", sep=""), sep="\t", quote=F, col.names=NA, row.names=T)

# norm
norm <- t(apply(log2cpm, 1, function(x) x - mean(x) ))
write.table(norm, file=paste(processed_data, "zero_centered.txt", sep=""), sep="\t", quote=F, col.names=NA, row.names=T)



# ##################### DEG extraction ############################

# # Significance picking for each tested model
DE.list <- lapply(1:n, function(x) decideTestsDGE(LRT.list[[x]], adjust.method=p.adj.method, p.value=alpha, lfc=log2(FC_threshold)))
names(DE.list) <- contrast_names

# Number of significant differentially abundant OTUs
total    <- sapply(DE.list, function(x) sum(abs(x)))
induced  <- sapply(DE.list, function(x) sum(x ==  1))
reduced  <- sapply(DE.list, function(x) sum(x == -1))
count <- data.frame(total, induced, reduced)
write.table(count, file=paste(stat, "number_of_DEGs.txt", sep=""), quote=F, row.names=T, col.names=NA, sep="\t")

# # significance table
DE <- sapply(1:n, function(x) DE.list[[x]][,1])
colnames(DE) <- contrast_names
write.table(DE, file=paste(stat, "significance_table.txt", sep=""), sep="\t", quote=T, row.names=T, col.names=NA)






# up-regulated genes, for metascape
DEG_list <- sapply(DE.list, function(x) rownames(x)[x == 1])

max_N <- max(sapply(DEG_list, length))
metascape <- lapply(contrasts_design$names, function(x){
	target <- as.character(DEG_list[[x]])
	out <- rep(NA, max_N)
	out[1:length(target)] <- target
	return(out)
}) %>% do.call(cbind, .)
colnames(metascape) <- contrasts_design$names
write.table(metascape, file=paste(stat, "UpDEGs_for_metascape.csv", sep=""), sep=",", quote=F, col.names=T, row.names=F, na="")




# up-regulated genes, for metascape
DEG_list <- sapply(DE.list, function(x) rownames(x)[x == -1])

max_N <- max(sapply(DEG_list, length))
metascape <- lapply(contrasts_design$names, function(x){
	target <- as.character(DEG_list[[x]])
	out <- rep(NA, max_N)
	out[1:length(target)] <- target
	return(out)
}) %>% do.call(cbind, .)
colnames(metascape) <- contrasts_design$names
write.table(metascape, file=paste(stat, "DownDEGs_for_metascape.csv", sep=""), sep=",", quote=F, col.names=T, row.names=F, na="")



