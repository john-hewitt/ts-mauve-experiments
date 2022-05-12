#!/bin/bash

## TO change: `data_dir` in line 45 and output directory. Pass in model size as argument.


#SBATCH --job-name=gen_basic
#SBATCH --comment="Generate all baselines"
#SBATCH --partition jag-important
#SBATCH --cpus-per-task=2
#SBATCH --mem=25G
#SBATCH --gres=gpu:1
#SBATCH --time=48:00:00
#SBATCH --open-mode=append
#SBATCH --mail-type=ALL


# Initialize conda into the right environment + modules.
source ~/.bashrc
#conda activate pyt17  # cuda 10.1
conda deactivate

if [[ ${HOSTNAME} == *"jagupard28"* ]]; then
  conda activate mauve-experiments-cu11
elif
 [[ ${HOSTNAME} == *"jagupard29"* ]]; then
  conda activate mauve-experiments-cu11
elif
 [[ ${HOSTNAME} == *"jagupard30"* ]]; then
  conda activate mauve-experiments-cu11
elif
 [[ ${HOSTNAME} == *"jagupard31"* ]]; then
  conda activate mauve-experiments-cu11
elif
 [[ ${HOSTNAME} == *"sphinx1"* ]]; then
  conda activate mauve-experiments-cu11
elif
 [[ ${HOSTNAME} == *"sphinx2"* ]]; then
  conda activate mauve-experiments-cu11
elif
 [[ ${HOSTNAME} == *"sphinx3"* ]]; then
  conda activate mauve-experiments-cu11
else
  conda activate mauve-experiments
fi

#source /u/scr/johnhew/jag-code/rc-nets/rcenv/bin/activate
#conda activate pyt14_tf1  # cuda 10.0
export DISABLE_TQDM=True
export TRANSFORMERS_CACHE=/u/scr/nlp/johnhew/data/huggingface



model_size=$1  # pass model size as argument
prompt_size=35

dataset="webtext"
model_name="gpt2-${model_size}"

if [ ${model_name} == "gpt2-small" ]; then
    model_name="gpt2"
fi

# Default args
if [ ${dataset} == "webtext" ]; then
    data_dir="./data/webtext/" ###TODO
else
    data_dir="UNKNOWN dataset ${dataset}"
    exit 100
fi


list_of_jobs=()

#for seed in 0 1 2 3 4
#for seed in 3 4 5
#for seed in 0 1 2 3 4
for seed in 200 201 202 203 204
do
for datasplit in valid
do

## entropy
#for e in 5e-5 2e-5 5e-6 1e-6
for h in 0.004 0.002 0.0009 0.0006 0.0003
do
    p=1
    k=0
    t=1
    e=0
    job="--top_p ${p} --top_k ${k} --temp ${t} --seed ${seed} --epsilon ${e} --eta ${h}"
    list_of_jobs+=("${job}")
done

# nucleus
#for p in 0.9 0.92 0.95
#for p in 0.89 
#do
#    k=0
#    t=1
#    e=0
#    job="--top_p ${p} --top_k ${k} --temp ${t} --seed ${seed} --epsilon ${e}"
#    list_of_jobs+=("${job}")
#done

# top-k
#for k in 1 5 10 50 100 500 1000 2000 5000 1000
#for k in 1
#do
#    p=1
#    t=1
#    job="--top_p ${p} --top_k ${k} --temp ${t} --seed ${seed}"
#    list_of_jobs+=("${job}")
#done

# temperature
#for t in 0.7 0.8 0.9 0.95 1.0
#for t in 1.0
#do
#    p=1
#    k=0
#    job="--top_p ${p} --top_k ${k} --temp ${t} --seed ${seed}"
#    list_of_jobs+=("${job}")
#done
#
## top-k + temperature
#for t in 0.75 0.9
#do
#for k in 10 100
#do
#    p=1
#    job="--top_p ${p} --top_k ${k} --temp ${t} --seed ${seed}"
#    list_of_jobs+=("${job}")
#done
#done

done # datasplit
done # seed

#num_jobs=${#list_of_jobs[@]}

job_id=$2

#if [ ${job_id} -ge ${num_jobs} ] ; then
#    echo "Invalid job id; qutting"
#    exit 2
#fi

#echo "-------- STARTING JOB ${job_id}/${num_jobs}"

args=${list_of_jobs[${job_id}]}

echo ${args}

time python -u generate_basic.py ${args} \
    --device 0 \
    --ds_name webtext \
    --datasplit ${datasplit} \
    --data_dir ${data_dir} \
    --model_name ${model_name} \
    --prompt_size ${prompt_size} \
    --use_large_feats

echo "Job completed at $(date)"
