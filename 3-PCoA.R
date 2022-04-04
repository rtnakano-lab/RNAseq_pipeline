#!/netscratch/dep_psl/grp_psl/ThomasN/tools/bin/bin/Rscripts
# R script to plot all RNAseq data on my hands
# 29 Dec 2020
# Ryohei Thomas Nakano; nakano@mpipz.mpg.de

options(warn=-1)

# clean up
rm(list=ls())

# packages
library(stringr,   quietly=T, warn.conflicts=F)
# library(patchwork, quietly=T, warn.conflicts=F)
library(ggrepel,   quietly=T, warn.conflicts=F)
library(ggplot2,   quietly=T, warn.conflicts=F)



# load config
config_path <- commandArgs(trailingOnly=T)[1]
# config_path <- "path/to_your/config_file.R"

source(config_path)
source(paste(scripts, "plotting_parameters.R", sep=""))


# import 
design  <- read.table(paste(processed_data, "design.txt", sep=""),        header=T, stringsAsFactors=F, check.names=F, row.names=NULL, sep="\t")
norm    <- read.table(paste(processed_data, "zero_centered.txt", sep=""), header=T, stringsAsFactors=F, check.names=F, row.names=1,    sep="\t") %>% as.matrix
DEGs    <- read.table(paste(stat,           "list_of_DEGs.txt", sep=""),  header=F, stringsAsFactors=F, check.names=F, row.names=NULL, sep="\t")$V1




# ========= PCoA based on zero-centered expression values of all genes ========= #

cor <- cor(norm)

pcoa <- cmdscale(as.dist(1-cor), k=3, eig=T)

point <- as.data.frame(pcoa$points)
colnames(point) <- c("x", "y", "z")

idx <- match(rownames(point), design$Library)
point <- data.frame(point, design[idx,], row.names=NULL, stringsAsFactors=F)

point$genotype <- factor(point$genotype, levels=genotypes$names)
point$tissue   <- factor(point$tissue,   levels=tissues$names)

# plot PC1 and PC2
p_12 <- ggplot(point, aes(x=x, y=y, colour=genotype, shape=tissue, label=rep)) +
	geom_point(size=2) +
	geom_text_repel(size=2, show.legend=F) +
	scale_colour_manual(values=genotypes$colours) +
	scale_shape_manual(values=tissues$shapes) +
	labs(x=paste("PC1: ", format(pcoa$eig[1]/sum(pcoa$eig)*100, digits=4), "%", sep=""),
		 y=paste("PC2: ", format(pcoa$eig[2]/sum(pcoa$eig)*100, digits=4), "%", sep=""),
		 title="PCoA; 1-cor(zero_centered)") +
	theme_RTN +
	theme(legend.position="right")
ggsave(p_12, file=paste(fig, "PCoA-PCC_zero_centered.col_geno-shape_tis.pdf", sep=""), width=4.5, height=3, bg="transparent")

p_12 <- ggplot(point, aes(x=x, y=y, colour=tissue, shape=genotype, label=rep)) +
	geom_point(size=2) +
	geom_text_repel(size=2, show.legend=F) +
	scale_colour_manual(values=tissues$colours) +
	scale_shape_manual(values=genotypes$shapes) +
	labs(x=paste("PC1: ", format(pcoa$eig[1]/sum(pcoa$eig)*100, digits=4), "%", sep=""),
		 y=paste("PC2: ", format(pcoa$eig[2]/sum(pcoa$eig)*100, digits=4), "%", sep=""),
		 title="PCoA; 1-cor(zero_centered)") +
	theme_RTN +
	theme(legend.position="right")

ggsave(p_12, file=paste(fig, "PCoA-PCC_zero_centered.col_tis-shape_geno.pdf", sep=""), width=4.5, height=3, bg="transparent")









# ========= PCoA based on zero-centered expression values of DEGs ========= #
idx <- rownames(norm) %in% DEGs
norm <- norm[idx,]

cor <- cor(norm)

pcoa <- cmdscale(as.dist(1-cor), k=3, eig=T)

point <- as.data.frame(pcoa$points)
colnames(point) <- c("x", "y", "z")

idx <- match(rownames(point), design$Library)
point <- data.frame(point, design[idx,], row.names=NULL, stringsAsFactors=F)

point$genotype <- factor(point$genotype, levels=genotypes$names)
point$tissue   <- factor(point$tissue,   levels=tissues$names)

# plot PC1 and PC2
p_12 <- ggplot(point, aes(x=x, y=y, colour=genotype, shape=tissue, label=rep)) +
	geom_point(size=2) +
	geom_text_repel(size=2, show.legend=F) +
	scale_colour_manual(values=genotypes$colours) +
	scale_shape_manual(values=tissues$shapes) +
	labs(x=paste("PC1: ", format(pcoa$eig[1]/sum(pcoa$eig)*100, digits=4), "%", sep=""),
		 y=paste("PC2: ", format(pcoa$eig[2]/sum(pcoa$eig)*100, digits=4), "%", sep=""),
		 title="PCoA; 1-cor(zero_centered)") +
	theme_RTN +
	theme(legend.position="right")

ggsave(p_12, file=paste(fig, "PCoA-PCC_zero_centered.col_geno-shape_tis.DEG.pdf", sep=""), width=4.5, height=3, bg="transparent")

p_12 <- ggplot(point, aes(x=x, y=y, colour=tissue, shape=genotype, label=rep)) +
	geom_point(size=2) +
	geom_text_repel(size=2, show.legend=F) +
	scale_colour_manual(values=tissues$colours) +
	scale_shape_manual(values=genotypes$shapes) +
	labs(x=paste("PC1: ", format(pcoa$eig[1]/sum(pcoa$eig)*100, digits=4), "%", sep=""),
		 y=paste("PC2: ", format(pcoa$eig[2]/sum(pcoa$eig)*100, digits=4), "%", sep=""),
		 title="PCoA; 1-cor(zero_centered)") +
	theme_RTN +
	theme(legend.position="right")

ggsave(p_12, file=paste(fig, "PCoA-PCC_zero_centered.col_tis-shape_geno.DEG.pdf", sep=""), width=4.5, height=3, bg="transparent")

