seed=$1
device=$2
model=$3
python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0 --typ 0.95 --device $device --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name $model   --prompt_size 35 --use_large_feats
python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0 --typ 0.92 --device $device --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name $model   --prompt_size 35 --use_large_feats
python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0 --typ 0.90 --device $device --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name $model   --prompt_size 35 --use_large_feats
python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0 --typ 0.20 --device $device --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name $model   --prompt_size 35 --use_large_feats
python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0 --typ 0.89 --device $device --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name $model   --prompt_size 35 --use_large_feats
