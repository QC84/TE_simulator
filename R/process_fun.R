# This script defines all functions (~ modules) used in run_process()

# KILL --------------------------------------------------------------------
# When a TE migrates, it has a probability r_death to kill his host
# Killed hosts became NAs
kill <- function(hosts, rate, seed) {
  set.seed(seed)
  prob <- 1 - (1 - rate)**hosts
  death_filter <- runif(n = length(hosts)) < prob
  hosts[death_filter] <- NA
  return(hosts)
}

# MIGRATION ---------------------------------------------------------------
# TEs are copying - pasting themselves somewhere on the genome
migrate <- function(hosts, rate, seed) {
  set.seed(seed)
  rbinom(n = length(hosts),
         size = hosts,
         prob = rate) + hosts
}
# REPRODUCTION ------------------------------------------------------------
# TEs reproduces following two strategies.
# After reproduction, our alive host population size equals N again
reproduce <- function(hosts, strat, seed){
  if(strat == "neutral"){
    set.seed(seed)
    alive_ind <- which(!is.na(hosts))
    new_hosts <- hosts[alive_ind][sample.int(length(alive_ind),
                                             size = length(hosts),
                                             replace = TRUE)]
    return(new_hosts)
  } else
    if(strat == "weighted"){
      # Yet to be improved (speed-wise)
      set.seed(seed)
      val_max <- max(hosts, na.rm = TRUE)
      weights <- pmax(val_max, 1000) - hosts # What is that ?
      weights[is.na(weights)] <- 0  # Set NA weights to 0
      new_hosts <- sample(x = hosts,
                        size = length(hosts),
                        prob = weights,
                        replace = TRUE)
      return(new_hosts)
    }
}

