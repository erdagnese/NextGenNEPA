#make.phyloseq.obj.R usage make.phyloseq.obj.R(asv.mat,metadata,tax.table)

make.phyloseq.obj <- function(asv.mat,metadata, tax.table) {
 
  require(tidyverse)
  require(plyr)
  require(vegan)
  require(phyloseq)
  
  source("asv.matrix.R")
  source("tax.table.R")
  
  ASV = otu_table(asv.mat, taxa_are_rows = T)
  TAX = tax_table(tax.mat)
  
  physeq = phyloseq(ASV,TAX)
  
  samples = sample_data(meta_data)
  
  physeq = merge_phyloseq(physeq,samples)
  
return(physeq)  
  
}
