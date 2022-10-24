# small
seed=$1
device=$2
	eta=0.002
	echo "time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta $eta   --device $device   --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name gpt2   --prompt_size 1   --use_large_feats;"
	time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta $eta   --device $device   --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name gpt2   --prompt_size 1   --use_large_feats;
			

	epsilon=0.0006
	echo "time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon $epsilon --eta 0   --device $device   --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name gpt2   --prompt_size 1   --use_large_feats;"
	time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon $epsilon --eta 0   --device $device   --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name gpt2   --prompt_size 1   --use_large_feats;

	p=0.90
	echo "time python -u generate_basic.py --top_p $p --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0   --device $device   --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name gpt2   --prompt_size 1   --use_large_feats;"
	time python -u generate_basic.py --top_p $p --top_k 0 --temp 1 --seed $seed --epsilon 0 --eta 0   --device $device   --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name gpt2   --prompt_size 1   --use_large_feats;
			

