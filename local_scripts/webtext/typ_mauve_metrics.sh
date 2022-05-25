#!/usr/bin/env bash

# TODO: set `njobs` (number of jobs to run at one) and `data_dir`

source local_scripts/parallelize.sh
njobs=4 # TODO
cmds=""


set -u  # x: stack trace
export MKL_NUM_THREADS=1
export NUMEXPR_NUM_THREADS=1
export OMP_NUM_THREADS=1

export CUDA_VISIBLE_DEVICES=""
export DISABLE_TQDM=True

# options
datasplit="test"
dataset="webtext"
#model_name="gpt2-large"
#max_len=${1}

# Default args
if [ ${dataset} == "webtext" ]; then
    data_dir="./data/webtext"  # TODO
else
    data_dir="UNKNOWN dataset ${dataset}"
    exit 100
fi

discretization="kmeans_l2"
kmeans_num_clusters=500

#for max_len in 1024 512 256 128
#for max_len in 1024 #512 256 128
for max_len in 1024 
do
#for generate_seed in 10 11 12 13 14 15
#for generate_seed in 0 1 2 3 4 5
#for generate_seed in 100 101 102 103 104
#for generate_seed in 200 201 202 203 204
for generate_seed in 0 1 2 3 4 5
#for generate_seed in 3 4 5
do
#for model_name in "gpt2" "gpt2-medium" "gpt2-large" "gpt2-xl"
#for model_name in "gpt2" "gpt2-medium" "gpt2-large"
#for model_name in "gpt2-xl" "gpt2-large"
#for model_name in "gpt2" "gpt2-medium" "gpt2-large" "gpt2-xl"
for model_name in "gpt2" "gpt2-medium" "gpt2-large" "gpt2-xl"
do

args="  --data_dir ${data_dir} --model_name ${model_name} "
sn="${discretization}_${kmeans_num_clusters}_${model_name}_${max_len}"

options="${args} --datasplit ${datasplit} --discretization ${discretization} --device -1"
options="${options} --kmeans_num_clusters ${kmeans_num_clusters}"
options="${options} --generate_seed ${generate_seed} --seed 1234"
options="${options} --use_large_feats --max_len ${max_len} --kmeans_explained_var 0.9"

##################
# basic
##################
# eta
#for e in 0.00005 0.0001 0.0003 0.0006 0.001
#for e in 5e-5 2e-5 5e-6 1e-6
for typ in 0.9 0.92 0.95 0.3 0.2
do
    cmds="$cmds ; time python -u compute_mauve_metrics.py ${options} --generation_type basic --typ ${typ} > outputs/${dataset}_${model_name}/outs/basic/${datasplit}_mauve_${sn}_typ_${typ}_seed${generate_seed} 2>&1 "
done


## top-k
#for k in 1
#do
#    cmds="$cmds ; time python -u compute_mauve_metrics.py ${options} --generation_type basic --top_k ${k} > outs/basic/mauve_${sn}_k_${k}_seed${generate_seed} 2>&1 "
#done
#
## temperature
#for t in 1.0
#do
#    cmds="$cmds ; time python -u compute_mauve_metrics.py ${options} --generation_type basic --temp ${t} > outs/basic/mauve_${sn}_t_${t}_seed${generate_seed} 2>&1 "
#done

done # model_name
done # seed
done # length

############ DONE ###########

echo "executing..."
date
set +u # for parallel exec to work (unbound variables)
f_ParallelExec $njobs "$cmds"
date
