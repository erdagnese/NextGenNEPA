# NextGenNEPA

Lots of code for processing metabarcoding data from creeks in Bellingham, Washington. 

Samples are taken monthly for a year at 5 creeks (2 stations per creek except 1 creek has 3 stations). The two stations are upstream and downstream of a culvert. In some cases, the culvert is blocking fish passage and in others it is restored and not blocking fish passage. The creek with 3 stations (Padden Creek) has two culverts, so there is a downstream station, upstream of the first blockage (SR11) but downstream of the second blockage (I-5), and upstream of both blockages.

We are interested in the impact of the actual construction on the aquatic communities. Padden Creek is the creek actively under construction. The monthly time series will capture before, during, and after the restoration of the lower blockage (SR11). The other four creeks are "control" creeks: 3 of which are currently considered as having a blockage (Squalicum Creek, Chuckanut Creek, and Barnes Creek), and 1 of which was previously restored (Portage Creek). 

Metabarcoding is done for 3 markers (12S MiFish, 12S MiMammal, COI Leray). Sequencing will be done on an Illumina MiSeq using Nextera UD indices. Sequencing runs will (for the most part) be in sets of three months worth of samples randomized over three runs. At each station, triplicate water samples are taken. One technical PCR replicate is performed for each biological replicate. However, on each sequencing run, one sample (one biological replicate of one station) is sequenced with three PCR replicates. The technical replicates and one positive control (kangaroo) for each marker are added to each sequencing run. 

We will try to measure the change in communities (via 3 markers) between upstream and downstream of the barriers, while also accounting for communities changing over time (seasonally). 

## Organization of files in this repo  
This repo has folders for: data, functions, scripts, output, and the manuscript.  


### Data
The data folder has sequencing data and supporting metadata files required for running different scripts.

Files include: 
- raw fastq files separated by sequencing run (usually one sequencing run is one month's worth of samples) **too big to house on github
- field metadata for the creeks (temperature, time, DO, turbidity)
- metadata for the sequencing runs (sample, Nextera index, primer etc.)

### Input
Files include:
- CRUX databases for each marker used to make classifiers for annotating ASVs

### Functions
The functions folder has commonly used functions in R for eDNA analysis. 

Functions include: 
- eDNAindex.R
- asv.matrix.R 

### Scripts
There are many types of scripts in this repo. We have attempted to make the names informative. For the order of operations, see the next section, "How to use this repo: step by step order of operations". 

Scripts include: 
- fastqs_to_asvs.Rmd (takes in fastq files, uses cutadapt to remove primers, uses dada2 to trim and form ASVs)
- create_classifiers.Rmd (makes initial classifiers for each locus)
- update_classifiers.Rmd (updates initial classifiers to add new things found)
- merge_multiple_runs.Rmd (merges ASVs/samples from multiple sequencing runs)
- asvs_to_taxa.Rmd (takes in ASVs and assigns taxonomy)
- reads_to_dna.Rmd (takes reads - either as ASVs or taxa - and converts to DNA for each ASV/taxa)
- pairwise_cuvlert.Rmd (compares up/down community at each culvert for each month)

### Output
Output of various scripts. 

Subfolders for: 
- cutadapt output
- dada2 output
- classifiers for each amplicon** too big to house on github

### Manuscript
All files for the manuscript.


## How to use this repo: step by step order of operations
NOTE: add paths to scripts and inputs

### 1. Remove primers from sequences 
*NOTE: this is actually done locally because the fasta files are too big 

#### Scripts used
fastqs_to_asvs.Rmd

#### Input
- Raw fasta files from sequencer (folder with two .fastq files per sample - R1 and R2 - not zipped) **too big to house on github
- Metadata file with sample name, Nextera index, PCR primer sequences 

#### Process
Read in raw fasta files and use cutadapt script to remove Nextera indices and PCR primers. (See https://github.com/ramongallego/Nextera_Dada2)

#### Output
- fasta files with primers removed

### 2. Dada2: quality control and  convert reads to AVS
*NOTE: this is actually done locally because the fasta files are too big 

#### Scripts used
fastqs_to_asvs.Rmd (same as step 1)

#### Input
- fasta files with primers removed
- need to decide on how much to trim off based on quality score plot! 

#### Process
Use dada2 to trim reads based on quality scores, merge paired end reads, and make ASVs (using hashes) from reads. (See https://github.com/ramongallego/Nextera_Dada2)  

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
- asvs_to_taxonomy.Rmd

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
