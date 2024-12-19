run_process_silent <- function(params, initial_hosts){
  N         <- params$init$N
  r_mig     <- params$events$r_mig
  r_kill    <- params$events$r_kill
  strat     <- params$events$strat
  prop_dead <- params$breakif$prop_dead
  max       <- params$breakif$max
  count     <- params$breakif$count
  tau       <- params$other$tau
  seed      <- params$other$seed

  # Preallocation of the final output container
  cols <- c("killed_hosts", "min", "mean", "max", "total_end")
  output <- matrix(data = NA,
                   nrow = tau,
                   ncol = length(cols)) |> as.data.frame()
  colnames(output) <- cols
  rownames(output) <- paste0("t_", 1:tau)
  
  # Preallocation of the transitory output container
  current <- data.frame(
    initial            = initial_hosts,
    after_death        = rep(NA, length(initial_hosts)),
    after_migration    = rep(NA, length(initial_hosts)),
    after_repro        = rep(NA, length(initial_hosts))
  )
  # Sourcing core functions
  source("./R/process_fun.R")
  
  options(warn=-1) # Removes warnings (bad idea i know...)
  
  for(t in 1:tau){
    ###### KILL ######
    current$after_death <- kill(current$initial, r_kill, seed)
    n_dead <- current$after_death |> is.na() |> sum()
    threshold <- floor(N * prop_dead)
    if(n_dead > threshold){
      cat("\nEarly stop after kill module\nToo many dead hosts") 
      break
    }
    ###### MIGRATE ######
    current$after_migration <- migrate(current$after_death, r_mig, seed)
    max_TE <- max(current$after_migration, na.rm = TRUE)
    if(max_TE > max){
      cat("\nEarly stop after migration module\nMaximum number of TEs is too high\n") 
      break
    }
    ###### REPRODUCTION ######
    current$after_repro <- reproduce(current$after_migration, strat, seed)
    min_TE <- current$after_repro |> min()
    if(min_TE > count){
      cat("\nEarly stop after reproduction module\nMinimum number of TEs is too high\n") 
      break
    }
    ###### FILLING OUTPUT ######
    final <- current[,ncol(current)]
    output[t,]$killed_hosts <- sum(is.na(current$after_death))
    output[t,]$min          <- min(final)
    output[t,]$mean         <- mean(final) 
    output[t,]$max          <- max(final) 
    output[t,]$total_end    <- sum(final)
    ###### RESTART ######
    current$initial <- final
  }
  options(warn=0) # Restaure warnings
  return(output)
}