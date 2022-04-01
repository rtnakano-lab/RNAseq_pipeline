
# parameter
p.adj.method <- "fdr"
FC_threshold <- 2
alpha <- 0.05

# directory
original_data  <- "/path_to_your_dir/original_data/"
processed_data <- "/path_to_your_dir/processed_data/"
fig            <- "/path_to_your_dir/fig/"
stat           <- "/path_to_your_dir/statistics/"
scripts        <- "/path_to_your_dir/scripts/"






# genotype (short: without hyphens)
genotypes <- data.frame(
	names=c("Col-0", "mutant_1-2", "mutant_2_a2"),
	short=c("WT", "mut1", "mut2"),
	colours=c(c_black, c_grey, c_cudo_magenta),
	shapes=c(8, 1, 16),
	stringsAsFactors=F)

tissues <- data.frame(
	names=c("rosette_leaves", "primary_roots", "lateral_roots"),
	short=c("leaf", "PR", "LR"),
	colours=c(c_cudo_magenda, c_dark_green, c_blue),
	shapes=c(8, 16, 1),
	stringsAsFactors=F)

# # microbial treatments
# treatment_1 <- data.frame(
# 	names=c("axenic", "R129_E", "AtRoot142"),
# 	short=c("mock", "129E", "142"),
# 	colours=c("#000000b3","#ff4500b3", "#0000ffb3"),
# 	shapes=c(8, 16, 1),
# 	stringsAsFactors=F)

# idx <- match(treatment_1$short, rhizobia_taxonomy$strain)
# treatment_1$colours <- rhizobia_taxonomy$colour[idx]

# # other treatments
# treatment_2 <- data.frame(
# 	names=c("mock", "flg22", "pep1"),
# 	colours=c(c_black, c_dark_green, c_cudo_magenta),
# 	shapes=c(8, 16, 17),
# 	stringsAsFactors=F)












