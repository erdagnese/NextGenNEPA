# tax.table.R to make the tax.table from the annotated hashes files created from insect
# usage tax.tabe(df)

tax.table <- function(df){
  library (tidyverse)
  library (plyr)
  
  taxonomy.file <- subset(df, select = -X)
  taxonomy.file <- as.data.frame(taxonomy.file)
  row.names(taxonomy.file) = taxonomy.file[,1]
  tax.mat = taxonomy.file[,-1]
  tax.table <- as.matrix(tax.mat)
  
  
return(tax.table)  
  
}