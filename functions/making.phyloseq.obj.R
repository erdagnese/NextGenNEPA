#make.phyloseq.obj.R usage make.phyloseq.obj.R(asv.mat,metadata,tax.table)

make.phyloseq.obj <- function(asv.mat,metadata, tax.mat) {
 
  require(tidyverse)
  require(plyr)
  require(vegan)
  require(phyloseq)
  

  ASV = otu_table(asv.mat, taxa_are_rows = T)
  TAX = tax_table(tax.mat)
  
  physeq = phyloseq(ASV,TAX)
  
  samples = sample_data(metadata)
  sample_names(samples) <- metadata$sample_id
  
  physeq = merge_phyloseq(physeq,samples)
  
return(physeq)  
  
}
