<img src="/images/Bionano-Logo.png" alt= “Bionano” width="5%" height="5%" title="GA"/>

# Local Guided Assembly #
It is recommended to launch assemblies from molecule .bnx files via command line if assembly intermediate files -`alignmolvref` step - are needed as input for downstream bioinformatics analysis (e.g molecule distance script). Assemblies downloaded from Access will likely not contain `alignmolvref` intermediate files.

For quick reference, please proceed to Local Guided Assembly (GA-Local) via Command Line Usage section.


## Set-up & Dependencies

Conda environment and Solve need to be installed in order to run pipelines. The following describes Solve installation in a Linux operating system. 

In general, the latest `*.tar.gz` of Solve can be downloaded from [Bionano Software Download](https://bionano.com/software-downloads/). Installation guide in a Linux operating system can be found in [30182 Bionano Solve Installation Guide](https://bionano.com/wp-content/uploads/2023/08/CG-30182-Bionano-Solve-Installation-Guide.pdf) Page 5.

Alternatively, if using Solve 3.7.2:

1. Acquire `*.tar.gz` of Solve 3.7.2.tar.gz.
2. Install `bionano_python3.0.yaml`.
```
conda env create --file bionano_python3.0.yml
```
3. Activate `bionano_python3.0` conda environment.
```
conda activate bionano_python3.0
```
4. Untar installation
5. Navigate into <path to install>/bionano_packages
6. Install the following R and python packages:
```
mkdir ~/Rpackages
export R_LIBS_USER=~/Rpackages
 
~/install/Solve3.7_09022021_137/bionano_packages$ R CMD INSTALL ./BionanoR
~/install/Solve3.7_09022021_137/bionano_packages$ R CMD INSTALL ./FractCNV
~/install/Solve3.7_09022021_137/bionano_packages$ python3 -m pip install ./pybionano
~/install/Solve3.7_09022021_137/bionano_packages$ python3 -m pip install ./svconfmodels
~/install/Solve3.7_09022021_137/bionano_packages$ y
```
7. Run assemblies. e.g `local_guided_assembly.sh`


### Local Guided Assembly (GA-Local) via Command Line Usage ###

`local_guided_assembly.sh` can only be run on machine with Linux-based operating system with Solve 3.7.2 installed and `bionano_python3.0` conda environment installed. Paths to pipeline, repeat coordinate .csv, and seed files path referenced in the script need to be examined to point to user's Solve installation. 

`hg38_DLE1_0kb_0labels.cmap` reference and `optArguments_haplotype_DLE1_saphyr_human_D4Z4.xml` files will be provided as input in the script for GA, which are preinstalled in Solve via command line.

Once Guided Assembly completes, the second portion of the script script launches a custom Enfocus pipeline assembling maps along repeat expansion gene coordinates supplied as an argument, which can be found in `coo_csvs/*.csv`. 

Script call will automatically reference the necessary repeat coordinate file for the custom Enfocus pipeline. All repeat loci with an expected repeat size >300-500 bp can be analyzed with this script by changing the -coo parameter. In our study, only the known repeat loci in CNBP, DMPK, RFC1, FMR1, STARD7, ATXN10, FXN, NOP56, and C9orf72 have been analyzed and the -coo parameter coordinate files for these loci are provided on this Github page. To run the script for a different repeat locus, the script has to be run using a user-provided custom -coo parameter coordinate file.

Example script call
```

# For running GA-Local in a single call.
sh ./scripts/run_local_guided_assembly.sh ./bnx_input/RUMC_DMPK_HvB_01.bnx DMPK

# For running GA-Local in a loop, given the path to a folder containing molecules
GA_PATH="$1/"
for DIR in $GA_PATH*.bnx;
do
    echo $DIR
    # echo $(dirname "$DIR")
    echo $(basename "$DIR")
    
    sh ./scripts/local_guided_assembly.sh $DIR dmpk
done

```

### Output ###
The output file is similar to an Enfocus Fragile X assembly, with the difference that it estimates repeat expansion distances along the locus specified by the .csv file instead of _FMR1_. Furthermore, the estimated number of repeat units depends on the repeat length (e.g trinucleotide, pentanucleotide), which is included in the `~/coo_csvs/*_repeat_coords.csv` file for genes *FMR1, RFC1, DMPK, STARD7, CNBP, ATXN10, FXN, NOP56, and c9orf72*.

### Resources ###

More information can be found in the following documentation:

*	[30182 Bionano Solve Installation Guide](https://bionano.com/wp-content/uploads/2023/08/CG-30182-Bionano-Solve-Installation-Guide.pdf).
*	[30205 Guidelines for Running Solve on the Command Line](https://bionano.com/wp-content/uploads/2023/08/CG-30205-Guidelines-for-Running-Bionano-Solve-on-the-Command-Line.pdf).
*	[30194 How to Align a BNX to Reference](https://bionano.com/wp-content/uploads/2023/01/30194-How-to-Align-a-bnx-to-a-Reference.pdf).

## Contact ###

Molecule distance script is authored by Joyce Lee, Syukri Shukor, Jillian Burke, and Andy Pang. For any questions, please reach out to Syukri Shukor (sshukor@bionano.com) or Andy Pang (apang@bionano.com) for questions and issues.
