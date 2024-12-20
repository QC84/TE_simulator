## How to run a simulation ?

1) Open a terminal inside the main directory of the project.
2) Inspect the config.R script located inside the CONFIG folder and change parameters as you wish
3) Launch the simulations with the following command `Rscript simulator.R <taux> <resolution>` (replace the two <arguments> at your discretion)
The interface will ask you to confirm your choice before it launch the whole simulation.

## What's inside ?

### Parameters

Reminder: you can change the simulation parameters by modifying the list `params` defined in the ./CONFIG/default.R script.

| Name | Explanation |
|----|----|
| $N$ | Number of hosts |
| $p_0$ | Initial proportion of hosts with one initial transposon |
| $R_{mig}$ | Successful (i.e., **not** leading to death of the host) migration rate |
| $R_{kill}$ | Failed (i.e., leading to death of the host) migration rate |
| `strat` | Reproduction strategy (neutral Wright-Fisher or weighted) |
| $\tau$ | Duration of the simulation |
| $n_{rep}$ | Number of replicates |
| `seed` | Random seed used for reproducibility |

Other parameters (`breakif$prop_dead`, `breakif$max`, `breakif$count`) are control parameters that needs to be discussed in more details.

### Functions

| Name | Arguments | Explanation |
|----|----|----|
| `tweak` | `params`, `custom_r_mig`, `custom_r_kill` | Generate the parameter grid according to <taux> and <resolution> |
| `validate` | All parameters | Checks if the parameters are valid inputs or not (in term of domain) |
| `generate_init` | $N$, $p_{0}$ | Generate the initial host population ; $p_{0} \cdot N $ of them contains one TE at the begining   |
| `process_fun` | `hosts`, `strat` & `seed` | This script defines all functions (~ modules) used in run_process() |
| `run_process_silent` | All parameters except $p0$ | Compute the evolution of our population ; call for several sub-routines ("modules") defined in process_fun.R and also include the break modules |
| `run_batch_par` | `validity`, `params`, `params_grid`, `n_cores` | For each set of parameters, distribute the replicates on multiple cores |

### Modules

Defined in ./R/proess_fun.R

| Name | Arguments | Process |
|----|----|----|
| `kill` | $R_{kill}$, `seed` | Each transposon succeeds in duplicating *but* inserts itself in a coding genome spot with probability $R_{kill}$ |
| `migrate` | $R_{mig}$, `seed` | Each transposon succeeds in duplicating and transposing in a non-coding part of the genome with probability $R_{mig}$ |
| `reproduce` | `strat`, `seed` | Neutral or weighted Wright-Fisher reproduction dynamics. Note that the new population is always of size $N$|

## Sensitivity analysis

Big simulations are currently running...

## Futur developements

1) [DONE] Generate several replicates of the same simulation (with different random seeds)
2) [DONE] Batch-simulate for some set of parameters
3) Implement a diploid case without recombination (for now ...)
4) Try it on a very minimal R installation and solve packages dependencies if needed
5) Unitzry tests (for tweaking parameters very small, null or very large for instance)