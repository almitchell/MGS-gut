# load libraries
library(readxl)
library(data.table)
library(ggplot2)
library(reshape2)
library(RColorBrewer)

# load data
sm.dset = read.csv("sourmash_classification.csv", check.names=FALSE, row.names=1) # load sourmash results
metadata.raw = read_excel("metadata.xlsx") # load excel file with metadata
metadata = as.data.frame(metadata.raw[,"continent"])
rownames(metadata) = metadata.raw$run_accession
colnames(metadata) = "continent"

# format datasets
dset = merge(sm.dset, metadata, by="row.names")
rownames(dset) = dset$Row.names
dset = dset[,c("HR", "+ RefSeq", "+ UMGS", "continent")]
dset$Improv = (dset$`+ UMGS`-dset$`+ RefSeq`)/dset$`+ RefSeq`*100

# plot boxplot of read assignment %
dset.box.all = melt(dset)

plot = print(ggplot(dset, aes(x=Continent, y=Improv, fill=continent)) # by continent
             + geom_boxplot(alpha=0.5, width=0.4, outlier.colour=NA, colour="black")
             + theme_bw()
             + scale_x_discrete(limits=rev(c("North America","Asia", "Europe", "Oceania", "South America", "Africa")))
             + scale_fill_manual(limits=rev(c("North America","Asia", "Europe", "Oceania", "South America", "Africa")),
                                 values=c("salmon", "orchid4", "darkorange", "steelblue", "red3", "green4"))
             + coord_flip()
             + guides(fill=FALSE)
             + ylab("Read classification (%)")
             + ylab("Read classification increase (%)")
             + theme(axis.title.y = element_blank())
             + theme(axis.text.y = element_text(size=12))
             + theme(axis.title.x = element_text(size=14))
             + theme(axis.text.x = element_text(size=12)))

# boxplot data
ggplot_build(plot)$data
