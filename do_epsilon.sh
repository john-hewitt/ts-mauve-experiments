for e in 0.0003 0.0006; do 
	for seed in 5 4 3; do 
		echo "time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon $e --eta 0   --device 0   --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name gpt2-xl   --prompt_size 35   --use_large_feats;"
		time python -u generate_basic.py --top_p 1 --top_k 0 --temp 1 --seed $seed --epsilon $e --eta 0   --device 0   --ds_name webtext   --datasplit valid   --data_dir ./data/webtext/   --model_name gpt2-xl   --prompt_size 35   --use_large_feats;
	done;
done
