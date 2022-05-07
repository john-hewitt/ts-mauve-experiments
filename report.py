import pickle
import argparse
import numpy as np

argp = argparse.ArgumentParser()
argp.add_argument('--just_best', default=None)
args = argp.parse_args()

model_sizes = ('', '-medium', '-large', '-xl')

top_p_hyps = (0.89, 0.9, 0.92, 0.95, 0.99)
epsilon_hyps = (0.001, 0.0009, 0.0006, 0.0003, 0.0001)
eta_hyps = (0.004, 0.002, 0.0009, 0.0006, 0.0003)

top_p_seeds_valid = (1, 2, 3, 4, 5)
epsilon_seeds_valid = (1, 2, 3, 4, 5)
eta_seeds_valid = (200, 201, 202, 203, 204)

lengths = (128, 256, 512, 1024)

path = 'outputs/webtext_gpt2{}/metrics/basic/mauve_L{}_valid_p{}_k0_t1.0_e{}_seed{}_kmeans_l2_500_0.9.p'


def results_helper(hyps, seeds, typ):
  results = {hyp: [] for hyp in hyps}
  for hyp in hyps:
    for seed in seeds:
      try:
        if typ == 'p':
          resolved_path = path.format(model_size, length, hyp, 0.0, seed)
        elif  typ == 'e':
          resolved_path = path.format(model_size, length, 1.0, hyp, seed)
        elif typ == 'h':
          resolved_path = path.format(model_size, length, 1.0, hyp, seed)
        result = pickle.load(open(resolved_path, 'rb'))[0]
        results[hyp].append(result)
      except:
        pass
  #print(results)
  results = {hyp: (np.mean(results[hyp]), np.std(results[hyp]), len(results[hyp])) for hyp in results}
  if args.just_best:
    print(list(sorted(results.items(), key=lambda x: 100 if np.isnan(x[1][0]) else -x[1][0]))[0])
  else:
    for hyp in hyps:
      print(hyp, results[hyp])

for model_size in model_sizes:
  for length in lengths:
    print()
    print(model_size if model_size != '' else 'small', length)
    results_helper(top_p_hyps, top_p_seeds_valid,  'p')
    results_helper(epsilon_hyps, epsilon_seeds_valid, 'e')
    results_helper(eta_hyps, eta_seeds_valid, 'h')
