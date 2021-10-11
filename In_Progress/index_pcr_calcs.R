###


tofill <- read.csv("/Users/elizabethandruszkiewicz/Downloads/indexed_pcr_qubit.csv", header=TRUE)
qubits <- read.csv("/Users/elizabethandruszkiewicz/Desktop/post_pcr_bead_clean_qubit2.csv", header=TRUE)

new_table <- merge(tofill, qubits, by="Samplename")

write.csv(new_table, "/Users/elizabethandruszkiewicz/Desktop/indexed_pcr_with_qubit_calcs.csv")
