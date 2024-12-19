## NOT UP TO DATE (yet...)

## Parameters

| Name | Explanation |
|----|----|
| $N$ | Number of individuals |
| $p_0$ | Initial proportion of hosts with one initial transposon |
| $R_{mig}$ | Successful migration rate |
| $R_{kill}$ | Failed (i.e., leading to death of the host) migration rate |
| `strat` | Reproduction strategy (neutral Wright-Fisher or weighted) |
| $\tau$ | Duration of the simulation |
| `seed` | Random seed used for reproducibility |

Parameters are called to the simulator from the config.json file, located in the CONFIG directory.

## Functions

| Name | Arguments | Explanation |
|----|----|----|
| `load_params` | Path to the config file | Load the parameters from the JSON file |
| `validate_params` | All parameters | Checks if the parameters are valid inputs or not |
| `generate_init` | $N$, $p_{0}$ | Generate the initial host population ; $p_{0} \cdot N $ of them contains one TE at the begining   |
| `run_process` | All parameters except $p0$ | Compute the evolution of our population ; call for several sub-routines ("modules") defined in process_fun.R |
| `custom_results` | `results` | Generate some summary plot of the evolution |

## Modules

| Name | Arguments | Process |
|----|----|----|
| `kill` | $R_{kill}$, `seed` | Each transposon succeeds in duplicating *but* inserts itself in a coding genome spot with probability $R_{kill}$ |
| `migrate` | $R_{mig}$, `seed` | Each transposon succeeds in duplicating and transposing in a non-coding part of the genome with probability $R_{mig}$ |
| `reproduce` | `strat`, `seed` | Neutral or weighted Wright-Fisher reproduction dynamics. Note that the new population is always of size $N$|

## References


## Futur developements

1) [DONE] Generate several replicates of the same simulation (with different random seeds)
2) [DONE] Batch-simulate for some set of parameters