library(insect)
#pull in the ref db as a DNAbin object 
#(fasta file formatted as accession;taxonomic ranks and the sequence)
ref.db <- readFASTA("/Combined_blast_wang_RefDB_withtax_distinct.fasta")
#learn the classifier using insect
insect::learn(ref.db) -> new.classifier
#save the classifier as an rds to use in future classifications
write_rds(new.classifier, "/COI_classifier.rds")