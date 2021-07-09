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


