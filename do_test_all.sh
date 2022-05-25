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
			
done
