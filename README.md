# NextGenNEPA

Lots of code for processing metabarcoding data from creeks in Bellingham, Washington. 

Samples are taken monthly for a year at 5 creeks (2 stations per creek except 1 creek has 3 stations). The two stations are upstream and downstream of a culvert. In some cases, the culvert is blocking fish passage and in others it is restored and not blocking fish passage. The creek with 3 stations (Padden Creek) has two culverts, so there is a downstream station, upstream of the first blockage (SR11) but downstream of the second blockage (I-5), and upstream of both blockages.

We are interested in the impact of the actual construction on the aquatic communities. Padden Creek is the creek actively under construction. The monthly time series will capture before, during, and after the restoration of the lower blockage (SR11). The other four creeks are "control" creeks: 3 of which are currently considered as having a blockage (Squalicum Creek, Chuckanut Creek, and Barnes Creek), and 1 of which was previously restored (Portage Creek). 

Metabarcoding is done for 3 markers (12S MiFish, 12S MiMammal, COI Leray). Sequencing will be done on an Illumina MiSeq using Nextera UD indices. Sequencing runs will (for the most part) be conducted by month. At each station, triplicate water samples are taken. One technical PCR replicate is performed for each biological replicate. However, on each sequencing run, one sample (one biological replicate of one station) is sequenced with three PCR replicates. Also on each sequencing run, one sample from the previous month's sequencing run is run again to quantify run-to-run variability between sequencing runs. The technical replicate and sequencing run replicates added to each sequencing run are done for each marker. 

We will try to measure the change in communities (via 3 markers) between upstream and downstream of the barriers, while also accounting for communities changing over time (seasonally). 

## How to use this repo 

The data folder has: raw fastq files separated by sequencing run (usually one sequencing run is one month's worth of samples), field metadata for the creeks (temperature, time, DO, turbidity), metadata for the sequencing runs (sample, Nextera index, primer etc.)

The functions folder has commonly used functions in R for eDNA analysis. 

The preannotation folder has scripts that take in the raw fastq files and provides as ASV table (not annotated). Note: this also merges ASVs from multiple runs. 

The annotation folder has scripts that take in the ASV table for each marker and annotates ASVs to taxa. 

The analysis folder includes scripts to perform analyses at both the ASV and taxon level. It also plots metadata. 

The figures folder is where figures generated in various scripts are stored. 


NOTE: add paths to scripts and inputs

## 1. Remove primers from sequences
# Scripts used
cutadapt.wrapper.Rmd

### Input
- Raw fasta files from sequencer. 
- Metadata file with sample name, Nextera index, PCR primer sequences 

### Process
Read in raw fasta files and use cutadapt script to remove Nextera indices and PCR primers. (See https://github.com/ramongallego/Nextera_Dada2)

### Output
- fasta files with primers removed

## 2. Dada2: quality control and  convert reads to AVS
# Scripts used
dada2.Rmd

### Input
- fasta files with primers removed
- need to decide on how much to trim off based on quality score plot! 
- 

### Process
Use dada2 to trim reads based on quality scores, merge paired end reads, and make ASVs (using hashes) from reads. (See https://github.com/ramongallego/Nextera_Dada2)  


### Output
- ASV table (Hash, Sample, nReads)
- Hash key - csv (Hash, Sequence)
- Hash key - fasta

## 3a. Build classifier for each locus.
NOTE: only do this one time - after that, just add to it

### Scripts used

### Input
- CRUX fasta file 
- CRUX taxonomy file 

### Process

### Output


## 3b. Add to classifiers 
NOTE: hopefully don't need to rebuild tree

### Scripts used
### Input
### Process
### Output

## 4. Annotate ASVs for each locus 

### Scripts used
### Input


### Process


### Output
- taxon table (taxa as rows, samples as columns, values are number of reads)
- 

### DO WE WANT TO HAVE A STEP WHERE WE MERGE DATA FROM MULTIPLE LOCI? 

## 5. Exploratory plotting and data analysis  

### Scripts used
### Input
### Process
### Output

## 6. Convert from number of reads to amount of DNA (or ratio of target DNA to total DNA?)
NOTE: this is going to be taxon specific because of amplification efficiencies? 

### Scripts used
### Input
- estimates of all parameters (amplification efficiency, )
- taxon table (taxa as rows, samples as columns, values are number of reads)

### Process

### Output
- csv: taxa as rows, samples as columns, values are ratios of target DNA / total DNA? 

## 7a. ANALYSIS: upstream/downstream of culvert  
NOTE: this is from our "big think" session 1 - where we have sets of paired upstream/downstream and plot distributions of some distance metric and see if Padden during construction drops out. 

NOTE: do we want to do this per marker, or on some dataset that is a merged multiple locus dataset? 

### Scripts used
### Input
### Process
### Output

## 7b. ANALYSIS: per species time series analysis / modeling vs. reality 
NOTE: this is from our "big think" session 1 idea #2 and the entire topic of our "big think" session 2. 

NOTE: we are modeling the ratio of target DNA to the ratio of total DNA - we are ignoring water flow and going to abundance 

NOTE: we are going to need to make different models for different species (or types of species) - probably best to start everything with a random walk for the equation relating time points in the process model and then see if we can improve it (for example with an exponential function)

### Scripts used
### Input
### Process
### Output

## 7c. ANALYSIS: ancom or something similar?

### Scripts used
### Input
### Process
### Output