# Création de la liste de paramètres
params <- list(
  init    = list(N  = 1e4,
                 p0 = 1),
  events  = list(r_mig  = 0.01,
                 r_kill = 0.0005,
                 strat  = "neutral"), # "neutral" or "weighted"
  breakif = list(prop_dead = 0.33,
                 max       = 500,
                 count     = 300),
  other   = list(tau      = 1e5,
                 n_rep    = 5,
                 seed     = 2025)
)
# Print the parameters to inform the user
source("./R/print_params.R")
print_params(params)
