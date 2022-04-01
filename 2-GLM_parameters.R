# # modify design table if necessary
design$genotype <- factor(design$genotype, levels=genotypes$names)
levels(design$genotype) <- genotypes$short

design$tissue <- factor(design$tissue, levels=tissues$names)
levels(design$genotype) <- tissues$short

design$group <- paste(design$genotype, design$tissue, sep="_")
# design$genotype_treatment_1 <- paste(design$genotype, design$treatment_1, sep="_")

write.table(design, file=paste(processed_data, "design.txt", sep=""),      col.names=T, row.names=T, quote=F, sep="\t")


# model matrix
Rep_fac   <- factor(design$rep)
group_fac <- factor(design$group, levels=unique(design$group)))

# genotype_fac <- factor(design$genotype, levels=genotypes$names))
# tissue_fac   <- factor(design$tissue,   levels=tissues$names))

model <- model.matrix( ~ 0 + group_fac + Rep_fac)
colnames(model) <- str_replace(colnames(model), "group_fac", "")

# model <- model[, -ncol(model)]
contrasts_mat <- makeContrasts(

	mut1_leaf = (  mut1_leaf - WT_leaf  ),
	mut2_leaf = (  mut2_leaf - WT_leaf  ),

	mut1_PR   = (  mut1_PR   - WT_PR    ),
	mut2_PR   = (  mut2_PR   - WT_PR    ),

	mut1_LR   = (  mut1_LR   - WT_LR    ),
	mut2_LR   = (  mut2_LR   - WT_LR    ),

	levels=model)

# contrast names
contrasts <- data.frame( 
	names    = c("mut1_leaf", "mut2_leaf", "mut1_PR", "mut1_LR", "mut2_PR", "mut2_LR"),
	genotype = c("mut1", "mut2", "mut1", "mut2", "mut1", "mut2"),
	tissue   = c("leaf", "leaf", "PR", "PR", "LR", "LR"),
	stringsAsFactors=F)



