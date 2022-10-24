hyp=$1
device=$2
model=$3
seed=$4

python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0 --typ $hyp --device $device --ds_name webtext   --datasplit test   --data_dir ./data/webtext/   --model_name $model   --prompt_size 35 --use_large_feats

