#usage: asv.matrix(df) to return a matrix form of the vector form of ASV table which is produced from the DADA2 script
#df would be the .csv read with header=T

asv.matrix <- function(df){#
  
  require(dplyr)
  require(tidyverse)

df.pivot <- pivot_wider(df, names_from = Sample_name, values_from = nReads)
df.pivot <- df.pivot[,-1] 
df.pivot <- as.data.frame(df.pivot) 
row.names(df.pivot) = df.pivot[,1] # make row names the ASV hash
df.pivot = df.pivot[,-1] # remove the column with the ASV hash
df.pivot[is.na(df.pivot)] <- 0


return(df.pivot)
}
