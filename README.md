# NextGenNEPA

Lots of code for processing metabarcoding data from creeks in Bellingham, Washington. 

Samples are taken monthly for a year at 5 creeks (2 stations per creek except 1 creek has 3 stations). The two stations are upstream and downstream of a culvert. In some cases, the culvert is blocking fish passage and in others it is restored and not blocking fish passage. The creek with 3 stations (Padden Creek) has two culverts, so there is a downstream station, upstream of the first blockage (SR11) but downstream of the second blockage (I-5), and upstream of both blockages.

We are interested in the impact of the actual construction on the aquatic communities. Padden Creek is the creek actively under construction. The monthly time series will capture before, during, and after the restoration of the lower blockage (SR11). The other four creeks are "control" creeks: 3 of which are currently considered as having a blockage (Squalicum Creek, Chuckanut Creek, and Barnes Creek), and 1 of which was previously restored (Portage Creek). 

Metabarcoding is done for 3 markers (12S MiFish, 12S MiMammal, COI Leray). Sequencing will be done on an Illumina MiSeq using Nextera UD indices. Sequencing runs will (for the most part) be in sets of three months worth of samples randomized over three runs. At each station, triplicate water samples are taken. One technical PCR replicate is performed for each biological replicate. However, on each sequencing run, one sample (one biological replicate of one station) is sequenced with three PCR replicates. The technical replicates and one positive control (kangaroo) for each marker are added to each sequencing run. 

We will try to measure the change in communities (via 3 markers) between upstream and downstream of the barriers, while also accounting for communities changing over time (seasonally). 

## Organization of files in this repo  
This repo has folders for: input, output, scripts, functions, and the manuscript.  

### Input
Files/folders include:
- creek_metadata_to_plot.csv - temperature, DO, etc. for all time sampled
- sequencing_metadata_files folder 
-- metadata file for each run (RunX_202XXXXX_metadata.csv) which has the following columns: Sequencing.run, Sample.number, Sample.name, Index.number, i7_Index_Name, i5_Index_Name, Well, Locus, Creek, Station, Bio.rep, Month.year, Dilution.factor, Type (sample vs kangaroo)
- insect_classifiers folder with subfolder for each marker (12S - which is both MiFish and MiMammal aka MiX - and COI) - each subfolder has a .fasta file of sequences and a .txt file with taxonomy 

*Note: raw fastq files are not housed here - the fastq files are processed using cutadapt and dada2 offline 

### Functions
The functions folder has commonly used functions in R for eDNA analysis. 

Functions include: 
- eDNAindex.R (calculates eDNA index from # of reads - from Moncho/Ryan)
- asv.matrix.R (return a matrix form of the vector form of ASV table which is produced from dada2 output)
- tax.table.R (makes the tax.table from the annotated hashes files created from insect)
- making.phyloseq.object.R (make.phyloseq.obj.R(asv.mat,metadata,tax.table) from asv matrix, metadata, and tax table)

### Scripts
There are many types of scripts in this repo. We have attempted to make the names informative. For the order of operations, see the next section, "How to use this repo: step by step order of operations". 

Scripts include: 
- cutadapt.wrapper.EA.Rmd (takes in fastq files, uses cutadapt to remove primers - originally by Moncho - RUN OFFLINE)
- split_primers.Rmd (takes cutadapt output and separates by marker before running dada2 - RUN OFFLINE)
- dada2.EA.Rmd (performs dada2 for each marker - also originally by Moncho - RUN OFFLINE)
- merge_runs.Rmd (merges ASVs/samples from multiple sequencing runs and separates by markers)
- COI_denoise.Rmd (denoises - checks for tag jumping, low reads, etc. - also originally by Moncho)
- create_classifier.Rmd (makes initial classifiers for each locus)
- update_classifiers.Rmd (updates initial classifiers to add new things found)
- hashes_to_taxonomy.Rmd (takes in ASVs and assigns taxonomy)
- reads_to_dna.Rmd (takes reads - either as ASVs or taxa - and converts to DNA for each ASV/taxa)
- pairwise_cuvlert.Rmd (compares up/down community at each culvert for each month)

### Output
Output of various scripts. 

Subfolders for: 
- dada2_output_files 
-- subfolders for each sequencing run 
-- sub-subfolders for each marker - provides ASV table, hash key *NOTE imported bc dada2 is run offline
-- then in main folder, merged asv table, hash key, and metadata file is produced from "merge_runs.Rmd" script
- insect_output_files 
-- subfolders for each marker (because runs were already merged) 
-- each subfolder contains a .rds file of the hashes annotated

### Manuscript
All files for the manuscript.


## How to use this repo: step by step order of operations
NOTE: add paths to scripts and inputs

### 1. Remove primers from sequences and then separate by marker
*NOTE: this is actually done locally because the fasta files are too big 

#### Scripts used
cutadapt.wrapper.EA.Rmd (NOTE: original script from Ramon Gallego - https://github.com/ramongallego/Nextera_Dada2)
split_primers.Rmd 

#### Input
- Raw fasta files from sequencer (folder with two .fastq files per sample - R1 and R2 - not zipped) **too big to house on github
- Metadata file with sample name, Nextera index, PCR primer sequences 

#### Process
Read in raw fasta files and use cutadapt script to remove Nextera indices and PCR primers. (See https://github.com/ramongallego/Nextera_Dada2)

#### Output
- fasta files with primers removed

### 2. Dada2: quality control and  convert reads to AVS and then merge multiple sequencing runs
*NOTE: dada2 is run offline, merging multiple runs is done in this repo

#### Scripts used
dada2.EA.Rmd (NOTE: this is actually done locally because the fasta files are too big - original script by Ramon Gallego - https://github.com/ramongallego/Nextera_Dada2)
merge_runs.Rmd

#### Input
- fasta files with primers removed organized into subfolder by marker
- need to decide on how much to trim off based on quality score plot! 

#### Process
Use dada2 to trim reads based on quality scores, merge paired end reads, and make ASVs (using hashes) from reads. In this case, start with 150/150 on F/R for 12S MiFish and MiMammal and 250/200 for COI LerayXT. Be sure to double check output plots to make sure those are reasonable numbers.

#### Output
- ASV table (Hash, Sample, nReads)
- Hash key - csv (Hash, Sequence)
- Hash key - fasta

### 3a. Build classifier for each locus.
*NOTE: this is actually done locally because the fasta files are too big 
*NOTE: only do this one time - after that, just add to it

#### Scripts used
- create_classifier.Rmd

#### Input
- CRUX fasta file 
- CRUX taxonomy file 

#### Process
- Get TaxIDs from NCBI for the accession numbers
- Build file with accession and TaxID for insect
- Build classifier with insect on cluster

#### Output
- (locus)_classifier.rds

### 3b. Add to classifiers 
NOTE: hopefully don't need to rebuild tree

#### Scripts used
- modify_classifier.Rmd

#### Input
- New CRUX fasta file - after modifying
- New CRUX taxonomy file - after modifying

#### Process
Creates a classifier using insect that is tree-based, from a reference database created using CRUX

#### Output
- classifer_"locus".rds (to be used in the next step - will be too large to house on github)

### 4. Annotate ASVs for each locus 

#### Scripts used
- hashes_to_taxonomy.Rmd

#### Input
- Hash_key.csv from step 2 
- ASV_table.csv from step 2
- classifier_locus.rds from step 3/4

#### Process
Using insect, classify sequences from the Dada2 output

#### Output
- taxonomy table (hashes, assigned taxonomy with levels as columns)
- taxon table (taxa as rows, samples as columns, values are number of reads) - **DO WE WANT THIS IN THIS SCRIPT OR DO WE WANT IT SEPARATE**

#### DO WE WANT TO HAVE A STEP WHERE WE MERGE DATA FROM MULTIPLE LOCI? 

### 5. Exploratory plotting and data analysis  
**phyloseq and other R scripts for div and other metrics?**
#### Scripts used
#### Input
#### Process
#### Output

### 6. Convert from number of reads to amount of DNA (or ratio of target DNA to total DNA?)
NOTE: this is going to be taxon specific because of amplification efficiencies? 

#### Scripts used
#### Input
- estimates of all parameters (amplification efficiency, )
- taxon table (taxa as rows, samples as columns, values are number of reads)

#### Process

#### Output
- csv: taxa as rows, samples as columns, values are ratios of target DNA / total DNA? 

### 7a. ANALYSIS: upstream/downstream of culvert  
NOTE: this is from our "big think" session 1 - where we have sets of paired upstream/downstream and plot distributions of some distance metric and see if Padden during construction drops out. 

NOTE: do we want to do this per marker, or on some dataset that is a merged multiple locus dataset? 

#### Scripts used
#### Input
#### Process
#### Output

### 7b. ANALYSIS: per species time series analysis / modeling vs. reality 
NOTE: this is from our "big think" session 1 idea #2 and the entire topic of our "big think" session 2. 

NOTE: we are modeling the ratio of target DNA to the ratio of total DNA - we are ignoring water flow and going to abundance 

NOTE: we are going to need to make different models for different species (or types of species) - probably best to start everything with a random walk for the equation relating time points in the process model and then see if we can improve it (for example with an exponential function)

NOTE: this is going to need to happen in STAN 

#### Scripts used
#### Input
#### Process
#### Output

### 7c. ANALYSIS: ancom or something similar?

#### Scripts used
#### Input
#### Process
#### Output
