print_params <- function(params) {
  # Header
  cat("------------------------------------------------------------\n")
  cat("Retrieving parameters from ~/config.R\n")
  cat("------------------------------------------------------------\n")
  
  # Initial parameters
  cat("Initial parameters:\n")
  cat("     N  = ", params$init$N, "\n", sep = "")
  cat("     p0 = ", params$init$p0, "\n", sep = "")
  cat("------------------------------------------------------------\n")
  
  # Event parameters
  cat("Event parameters:\n")
  cat("     r_mig  = ", params$events$r_mig, "\n", sep = "")
  cat("     r_kill = ", params$events$r_kill, "\n", sep = "")
  cat("     strat  = ", params$events$strat, "\n", sep = "")
  cat("------------------------------------------------------------\n")
  
  # Breakif parameters
  cat("Breakif parameters:\n")
  cat("     prop_dead = ", params$breakif$prop_dead, "\n", sep = "")
  cat("     max       = ", params$breakif$max, "\n", sep = "")
  cat("     count     = ", params$breakif$count, "\n", sep = "")
  cat("------------------------------------------------------------\n")
  
  # Other parameters
  cat("Other parameters:\n")
  cat("     tau   = ", params$other$tau, "\n", sep = "")
  cat("     n_rep = ", params$other$n_rep, "\n", sep = "")
  cat("     seed  = ", params$other$seed, "\n", sep = "")
  cat("------------------------------------------------------------\n")
}