# MAUVE experiments for the Truncation Sampling paper

This repository documents the MAUVE experiments in [_Truncation Sampling
as Language Model Desmoothing_](https://arxiv.org/pdf/2210.15191.pdf). Minimal changes have been made to the original
MAUVE experiments repository to add epsilon sampling, eta sampling, and typical
decoding. A few scripts are provided for running the set of experiments we ran
as well.

For the rest of the code for the _Trucation Sampling_ paper, please see our
[github repo](https://github.com/john-hewitt/truncation-sampling).



Of course, if you use this repository, cite the original authors. Only cite the
_Truncation Sampling_ paper if you use the new methods presented in it.

```
@article{pillutla-etal:mauve:preprint2021,
title = {{MAUVE: Human-Machine Divergence Curves for Evaluating Open-Ended Text Generation}},
author = {Krishna Pillutla and Swabha Swayamdipta and Rowan Zellers and John Thickstun and Yejin Choi and Zaid Harchaoui}
journal={arXiv preprint},
year = {2021},
}
```

## Taking a look at the results

If you just want to take a look at the MAUVE scores or the generated text from all methods,
we've kept it all, from both validation and testing! In the directory `cached_outputs`, you'll
see four files: `test-generations.json.zip`, `test-mauves.json`, `valid-generations.json.zip`,
`test-mauves.json`. The zipped generation files total almost 800MB and are stored with github
large file storage.

Each `generations` json file is a dictionary of the following form
```
	{
		str((method, hyperparameter, seed)):
			[
				[...] # List of generated strings
				[...] # List of completion booleans
			],
		...
	}
```
where the `method` mapping is `p`: top-p, `e`: epsilon, `h`: eta, `t`: typical.

While each `mauves` json file is a dictionary of the following form
```
	{
		str((method, hyperparameter, seed)): mauve_score # scalar
		...
	}
```
## Running val-set experiments and choosing hyperparameters

We choose hyperparameters for each method on the WebText validation set. You should
download it (and do other prep for the repository) with the instructions provided
in the original README, kept verbatim below, before you run these commands.
One thing to note that we noticed didn't work in the original prep is that the folders

```
outputs/webtext_gpt2/generations/ref/
outputs/webtext_gpt2-medium/generations/ref/
outputs/webtext_gpt2-large/generations/ref/
outputs/webtext_gpt2-xl/generations/ref/
```

should all have files with names like `featsL1024_test.pt`, for evaluation to work properly;
I think the prep only puts them in the `gpt2` folder. Copying the identical reference files
to all the locations (for validation and for test) worked.

In these and the test experiments, you'll probably want to parallelize these across
e.g., slurm jobs instead of running them serially.


You can then make the MAUVE scores by running `local_scripts/webtext/eta_mauve_metrics_kmeans.sh`.

Once the MAUVE scores are written, run `report.py` to get a breakdown.
```
model_name=gpt2 # Choose between {gpt2,gpt2-medium,gpt2-large,gpt2-xl}

# Eta-sampling
for h in 0.0006 0.0009 0.0003 0.002; do
	for seed in 5 4 3 2 1; do
		echo "time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta $h   --device 1   --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name $model_name   --prompt_size 35   --use_large_feats;"
		time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta $h   --device 1   --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name $model_name   --prompt_size 35   --use_large_feats
	done
done

# Epsilon-sampling
for e in 0.0003 0.0006; do
	for seed in 5 4 3 2 1; do
		echo "time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon $e --eta 0   --device 0   --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name $model_name   --prompt_size 35   --use_large_feats;"
		time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon $e --eta 0   --device 0   --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name $model_name   --prompt_size 35   --use_large_feats;
	done;
done

# Top-p-sampling
for p in 0.92 0.95 0.9 0.99; do
	for seed in 5 4 3 2 1; do
		echo "time python -u generate_basic.py --top_p $p --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0   --device 0   --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name $model_name   --prompt_size 35   --use_large_feats;"
		time python -u generate_basic.py --top_p $p --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0   --device 0   --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name $model_name   --prompt_size 35   --use_large_feats;
	done;
done

# Typical decoding
for p in 0.92 0.95 0.9 0.2 0.89; do
	for seed in 5 4 3 2 1; do
		echo "time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0 --typ $p   --device 0   --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name $model_name   --prompt_size 35   --use_large_feats;"
		time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0 --typ $p   --device 0   --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name $model_name   --prompt_size 35   --use_large_feats;
	done;
done
```

## Running test-set experiments 
These test set scripts use the best-performing hyperparameters for each method for each model size.

You can then make the MAUVE scores by running `local_scripts/webtext/test_mauve_metrics_kmeans.sh`.

Once the MAUVE scores are written, run `report.py --test 1` to get a breakdown.
```
# small
for seed in 1 2 3 4 5; do
	eta=0.002
	echo "time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta $eta   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2   --prompt_size 35   --use_large_feats;"
	time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta $eta   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2   --prompt_size 35   --use_large_feats;
			

	epsilon=0.0006
	echo "time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon $epsilon --eta 0   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2   --prompt_size 35   --use_large_feats;"
	time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon $epsilon --eta 0   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2   --prompt_size 35   --use_large_feats;

	p=0.9
	echo "time python -u generate_basic.py --top_p $p --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2   --prompt_size 35   --use_large_feats;"
	time python -u generate_basic.py --top_p $p --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2   --prompt_size 35   --use_large_feats;
    
    p= 0.9
     echo "python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0 --typ $p --device 1 --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2   --prompt_size 35 --use_large_feats"
    python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0 --typ $p --device 1 --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2   --prompt_size 35 --use_large_feats
			
done

# medium
for seed in 1 2 3 4 5; do
	eta=0.002
	echo "time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta $eta   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-medium   --prompt_size 35   --use_large_feats;"
	time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta $eta   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-medium   --prompt_size 35   --use_large_feats;
			

	epsilon=0.0009
	echo "time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon $epsilon --eta 0   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-medium   --prompt_size 35   --use_large_feats;"
	time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon $epsilon --eta 0   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-medium   --prompt_size 35   --use_large_feats;

	p=0.89
	echo "time python -u generate_basic.py --top_p $p --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-medium   --prompt_size 35   --use_large_feats;"
	time python -u generate_basic.py --top_p $p --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-medium   --prompt_size 35   --use_large_feats;
			
    p= 0.9
     echo "python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0 --typ $p --device 1 --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-medium   --prompt_size 35 --use_large_feats"
    python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0 --typ $p --device 1 --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-medium   --prompt_size 35 --use_large_feats
done

# large
for seed in 1 2 3 4 5; do
	eta=0.0006
	echo "time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta $eta   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-large   --prompt_size 35   --use_large_feats;"
	time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta $eta   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-large   --prompt_size 35   --use_large_feats;
			

	epsilon=0.0003
	echo "time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon $epsilon --eta 0   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-large   --prompt_size 35   --use_large_feats;"
	time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon $epsilon --eta 0   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-large   --prompt_size 35   --use_large_feats;

	p=0.95
	echo "time python -u generate_basic.py --top_p $p --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-large   --prompt_size 35   --use_large_feats;"
	time python -u generate_basic.py --top_p $p --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-large   --prompt_size 35   --use_large_feats;

    p= 0.92
     echo "python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0 --typ $p --device 1 --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-large   --prompt_size 35 --use_large_feats"
    python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0 --typ $p --device 1 --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-large   --prompt_size 35 --use_large_feats
done

for seed in 1 2 3 4 5; do
	eta=0.0003
	echo "time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta $eta   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-xl   --prompt_size 35   --use_large_feats;"
	time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta $eta   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-xl   --prompt_size 35   --use_large_feats;
			

	epsilon=0.0003
	echo "time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon $epsilon --eta 0   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-xl   --prompt_size 35   --use_large_feats;"
	time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon $epsilon --eta 0   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-xl   --prompt_size 35   --use_large_feats;

	p=0.95
	echo "time python -u generate_basic.py --top_p $p --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-xl   --prompt_size 35   --use_large_feats;"
	time python -u generate_basic.py --top_p $p --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0   --device 1   --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-xl   --prompt_size 35   --use_large_feats;
    
    p= 0.92
     echo "python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0 --typ $p --device 1 --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-xl   --prompt_size 35 --use_large_feats"
    python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0 --typ $p --device 1 --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name gpt2-xl   --prompt_size 35 --use_large_feats
```

# mauve-experiments (repeated verbatim from original repository)

This repository contains the code and the scripts to reproduce the experiments 
[in this paper](https://arxiv.org/pdf/2102.01454.pdf).
The paper introduces MAUVE, an evaluation metric for open-ended text generation.

MAUVE directly  compares  the distribution of machine-generated text to 
that of human language as the area under the divergence curve for the two distributions. 
MAUVE summarizes the  trade-off  between two types of errors: 
those arising from parts of the human distribution that the model distribution 
approximates  well, and those it does not. 

_**Standalone package**: For a self-contained package to compute MAUVE, installable 
via `pip install mauve-text`, please 
see [this repository](https://github.com/krishnap25/mauve)._

## Dependencies
The code is written in Python and the dependencies are:
- Python >= 3.6
- PyTorch >= 1.1
- Huggingface Transformers >= 4.2.0
- NLTK >= 3.4.5
- scikit-learn >= 0.22.1
- faiss-gpu >= 1.7.0
- tqdm >= 4.40.0

**Conda Environment**:
We recommend using a [conda environment](https://docs.conda.io/en/latest/miniconda.html)
for Python 3.8.
To setup the environment, run
```bash
conda env create --file environment.yml
# activate the environment
conda activate mauve-experiments
```
In addition, you will have to install the following manually:
- PyTorch, version 1.7: [instructions](https://pytorch.org/get-started/locally/),
- HuggingFace Transformers, version 4.2.0: [instructions](https://huggingface.co/transformers).

The code is compatible with PyTorch >= 1.1.0 and transformers >= 3.2.0 but
we have not thoroughly tested it in this configuration.


**Install Dependencies via Pip**:
Install PyTorch, version 1.7 ([instructions here](https://pytorch.org/get-started/locally))
and then run
```bash
pip install -r requirement.txt
```

## Datasets
We use the webtext data from the [GPT-2 output dataset repository](https://github.com/openai/gpt-2-output-dataset).
For the purpose of reproducing these experiments, 
it suffices to simply download the test set of webtext. 
To this end, run:
```python
python local_scripts/download_data.py
```
The data is downloaded to the folder `./data` and pass `--data_dir ./data` for all scripts below.

## Experimental Pipeline
For each dataset, once we have the pretrained models, the experimental pipeline is as follows:
1. generate samples and featurize samples (GPU needed)
2. compute MAUVE (CPU suffices, highly parallelizable)
3. compute LM metrics such as perplexity, sparsemax score, Jensen-Shannon score, etc. (GPU needed)
4. compute self-BLEU (CPU only, embarassingly parallelizable between multiple cores)
5. compute all other metrics (CPU only)
6. compute steps 4 and 5 on the human data

The generation of samples (Step 1) must be run first. Other steps can proceed in any order.

Here is how to find the scripts step-by-step for webtext.
The variables which need to be set are detailed at the top of each script.

**Step 0. Prepare directory:**
Run `bash local_scripts/make_output_dirs.sh` to create the necessary output directories.

**Step 1. Generate the samples:**
Run `slurm_scripts/webtext/arr_generate_basic.sh ${model_size}` to generate samples of basic methods
(pure sampling, top-K sampling, temperature sampling, nucleus sampling and greedy decoding).
`${model_size}` is one of `['small', 'medium', 'large', 'xl']`.

It is written as a slurm array job.
For each configuration and model size, we generate five sets of 5000 samples each 
using prompts from the dataset. This script internally calls the file `generate_basic.py`.
The outputs are stored in `./outputs/{dataset_name}_{model_name}/generations/basic`
The running time for each run varies from around 1 hour (GPT-2 small/medium) to around 3-4 hours (GPT-2 large) 
and 12 hours (GPT-2 XL) on a NVIDIA Quadro GPU with a memory of 24G. 
If you use a GPU with a memory of 12G, it will likely take around twice as long.

This creates the following in `./outputs/{dataset_name}_{model_name}/generations/basic`.
- `sentences_test_p${topp}_k${topk}_t${temp}_seed${seed}.p` (e.g. `sentences_test_p0.99_k0_t1.0_seed0.p`): 
    contains the raw samples in string form. If you load this using pickle, you will find 
    two lists: (1) list of strings which are the actual samples generated, and, 
    (2) list of booleans, denoting termination, i.e., whether a `|<endoftext>|` (EOS) token was generated. 
- `sample_test_p${topp}_k${topk}_t${temp}_seed${seed}.p` (e.g. `sample_test_p0.99_k0_t1.0_seed0.p`):
    contains the samples after tokenization. If you load this using pickle, you will find 
    a list of 5 entires: (1) list of list of ints, each of which is the BPE tokenized representation
    of the samples generated above, 
    (2) list of booleans, denoting termination (same as above),
    (3) unique n-gram fraction, for n in 1 to 6, 
    (4) perplexity of the generated text under the model, and,
    (5) the parsed arguments of the script `generate_basic.py`.
- `featsL${max_length}_test_p${topp}_k${topk}_t${temp}.0_seed4.pt` (e.g. `featsL1024_test_p0.99_k0_t1.0_seed0.pt`):
    features representation (i.e., terminal hidden state)
    under the GPT-2 large model. Each such a file is 25M in size.
    For each configuration, we create 4 files with 
    `max_length` in `{128, 256, 512, 1024}`. 

Next, run `slurm_scripts/webtext/generate_ref.sh` to featurize the human-written text (i.e., webtext test set).
The output is created in `./outputs/{dataset_name}_{model_name}/generations/ref`.


**Step 2. Compute MAUVE:**
Run `local_scripts/webtext/mauve_metrics_*.sh`. 
- `local_scripts/webtext/mauve_metrics_kmeans.sh`: use k-means for quantization.
    Runs on CPU within a few minutes per run. It is massively parallelizable.
- `local_scripts/webtext/mauve_metrics_drmm.sh`: use deep residual mixture models (DRMM) for quantization (Hämäläinen et. al. 2020).
    It is copied with minor edits from the [original repo](https://github.com/PerttuHamalainen/DRMM) 
    (note: this requires TensorFlow 1.12 to be installed. A CPU-only install suffices).
    A CPU-only run takes around 2 hours. It is also massively parallelizable. 
- `local_scripts/webtext/mauve_metrics_spv.sh`: use spreading vectors for quantization (Sablayrolles et. al. 2018).
    It is copied with minor edits from the [original repo](https://github.com/facebookresearch/spreadingvectors).
    It runs in <10 minutes on a GPU.
    
The outputs are written in 
`./outputs/{dataset_name}_{model_name}/metrics/basic`.
The filenames are:
- k-means: `mauve_L${max_len}_test_p${topp}_k${topk}_t${temp}_seed${seed}_kmeans_l2_${num_clusters}_${lower_dim_explained_variance}.p` (e.g., `mauve_L1024_test_p1.0_k50_t1.0_seed2_drmm_3_10.p`): 
    arguments are `num_clusters` (number of clusters) and 
    `lower_dim_explained_variance` (lower dimensionality after PCA is chosen with at least this much explained variance). 
- DRMM: `mauve_L${max_len}_test_p${topp}_k${topk}_t${temp}_seed${seed}_drmm_${num_layers}_${num_components_per_layer}.p` (e.g., `mauve_L1024_test_p1.0_k50_t1.0_seed2_drmm_3_10.p`):
    arguments are `num_layers` (number of layers in the DRMM) and `num_components_per_layer` (number of components in each layer).
    The equivalent number of k-means clusters would be `${num_components_per_layer}^${num_layers}`
- SPV: `mauve_L${max_len}_test_p${topp}_k${topk}_t${temp}_seed${seed}_spv.p` (e.g., `mauve_L1024_test_p1.0_k50_t1.0_seed2_drmm_3_10.p`)

Each of these outputs is a pickle file. In each output, we have, 
`[p_hist, q_hist, mauve]`, where `p_hist` and `q_hist` are 
respectively the multinomial distributions 
obtained after quantization.

**Step 3. Compute LM metrics:**
Run `local_scripts/webtext/run_lm_metrics.sh`,
which in turn invokes `compute_lm_metrics_basic.sh`.
Output files are written in 
`./outputs/{dataset_name}_{model_name}/metrics/basic`
with name `lm_test_p${topp}_k${topk}_t${temp}.p` (e.g., `lm_test_p1.0_k5_t1.0.p`).
Only one job is run per each seed 
(since the metrics depend on the model but not on the actual generations).

**Step 4. Compute Self-BLEU**:
Run `local_scripts/webtext/run_self_bleu.sh`,
which in turn calls `compute_self_bleu_metric.sh`.
Takes around 7 hours on a single processor core, but is embarassingly parallel.
The current script runs one processor per job but 
parallelizes jobs at once. 
Output files are written in 
`./outputs/{dataset_name}_{model_name}/metrics/basic`
with name `bleu_test_p${topp}_k${topk}_t${temp}_seed${seed}.p`
(e.g., `bleu_test_p1.0_k500_t1.0_seed4.p`).

**Step 5. Compute all other metrics**:
Run `local_scripts/webtext/run_all_L_metrics.sh`.
It calls `compute_all_L_metrics.py` under the hood
and computes other metrics such as the Zipf coefficient 
and repetition ratio. Runs in a few seconds.

Output files are written in 
`./outputs/{dataset_name}_{model_name}/metrics/basic`
with name `all_L_test_p${topp}_k${topk}_t${temp}_seed${seed}.p`
(e.g., `all_L_test_p0.92_k0_t1.0_seed3.p`).

**Step 6. Compute metrics on human data**:
To perform steps 4 and 5 on the human-written text, run 
```bash
python compute_ref_metrics.py --datasplit test --device 0 --parallel_bleu --n_proc_bleu 24
```
The self-BLEU computation is the most time-consuming (~7 hours with one process)
and its running time
depends on how many processes are allowed (`--n_proc_bleu`).
Outputs are written to 
`./outputs/{dataset_name}_{model_name}/metrics/ref`.


## Citation
If you find this repository useful, or you use it in your research, please cite:
```
@article{pillutla-etal:mauve:preprint2021,
title = {{MAUVE: Human-Machine Divergence Curves for Evaluating Open-Ended Text Generation}},
author = {Krishna Pillutla and Swabha Swayamdipta and Rowan Zellers and John Thickstun and Yejin Choi and Zaid Harchaoui}
journal={arXiv preprint},
year = {2021},
}
```
    
## Acknowledgements
This work was supported by NSF CCF-2019844,the DARPA MCS program through NIWC Pacific(N66001-19-2-4031),
the CIFAR program "Learning in Machines and Brains", 
a Qualcomm Innovation Fellowship, and faculty research awards. 



