#! /bin/bash
export SGE_ROOT=/home/sge
export DRMAA_LIBRARY_PATH=/home/sge/lib/lx-amd64/libdrmaa.so


INPUT_BNX=$1
GENE=$2

echo "/home/IrysView1/users9/jburke/repeat_expansion_project/guided_assembly_enfocus_output/${1//.bnx/_pipelines}/output"
mkdir -p "/home/IrysView1/users9/jburke/repeat_expansion_project/guided_assembly_enfocus_output/${1//.bnx/_pipelines}/output"

OUTPUT="/home/IrysView1/users9/jburke/repeat_expansion_project/guided_assembly_enfocus_output/${1//.bnx/_pipelines}/output"
REPEAT_COORDS='/home/IrysView1/users9/jburke/repeat_expansion_project/enfocus_runs/new_coo_csvs/'$GENE'_repeat_coords.csv'
PIPELINE=/home/users6/bioinformatics/common/releases/Solve3.7/1.0
REFERENCE=$PIPELINE/RefGenome/hg38_DLE1_0kb_0labels.cmap
# SEED=/home/IrysView1/users9/jburke/repeat_expansion_project/custom_seed_files/seed_no_als.cmap

if [ $GENE="c9orf72" ]
then
  SEED=/home/IrysView1/users9/jburke/repeat_expansion_project/custom_seed_files/seed_als_only.cmap
else
  SEED=/home/IrysView1/users9/jburke/repeat_expansion_project/custom_seed_files/seed_no_als.cmap
fi


OPTARGS=${PIPELINE}/RefAligner/1.0/optArguments_haplotype_DLE1_saphyr_human_D4Z4.xml
CLUSTER_ARGS=$PIPELINE/Pipeline/1.0/clusterArguments_access.xml

echo $INPUT_BNX
echo $OUTPUT
echo $REPEAT_COORDS

python3 $PIPELINE/Pipeline/1.0/pipelineCL.py \
   -l $OUTPUT \
   -t $PIPELINE/RefAligner/1.0 \
   -C $CLUSTER_ARGS \
   -b $INPUT_BNX \
   -a $OPTARGS \
   -r $REFERENCE \
   -seed $SEED \
   -guidedB \
   -y \
   -i 5 \
   --species-reference human_hg38 \
   -F 1 \
   -W 0.4 \
   -f 0.1 \
   -J 44 \
   -TJ 88 \
   -j 44 \
   -jp 44 \
   -je 44 \
   -T 176 \
   -Tp 88 \
   -Te 176 \
   -N 4 

python3 $PIPELINE/EnFocus_Repeats/1.0/run_enfocus_repeat.py exp \
  -coo $REPEAT_COORDS \
  -a $OUTPUT \
  -g 'FMR1'\
  -o $OUTPUT/repeat_report

