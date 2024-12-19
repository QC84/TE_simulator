library(parallel)
library(tictoc) # For monitoring execution time

run_batch_par <- function(validity, params, params_grid, n_cores = 1) {
  # Monitoring
  tic()
  # Stop if params_grid haven't been validated
  if(!validity){
    stop("Parameters have not been validated")
  }
  # Stop if choosen number of cores > available number
  if(n_cores > parallel::detectCores()){
    stop("n_cores exceed available number of cores")
  }
  cli::cli_alert_info(
    paste0("Current simulation runs on ", n_cores, " core(s)\n")
  )
  # Create cluster
  cl <- makeCluster(n_cores)
  # Export necessary functions and variables to cluster
  clusterExport(cl, c("params",
                      "params_grid",
                      "generate_init", 
                      "run_process_silent"))
  
  ###############################################################
  # Run parallel processing
  all_results <- parLapply(cl, 1:nrow(params_grid), function(i) {
    current_params <- params
    # Update parameters for current iteration
    current_params$init$N            <- params_grid$N[i]
    current_params$init$p0           <- params_grid$p0[i]
    current_params$events$r_mig      <- params_grid$r_mig[i]
    current_params$events$r_kill     <- params_grid$r_kill[i]
    current_params$events$strat      <- params_grid$strat[i]
    current_params$breakif$prop_dead <- params_grid$prop_dead[i]
    current_params$breakif$max       <- params_grid$max[i]
    current_params$breakif$count     <- params_grid$count[i]
    current_params$other$tau         <- params_grid$tau[i]
    current_params$other$seed        <- params_grid$seed[i]
    # Generate initial population
    initial_hosts <- current_params |> generate_init()
    # Run simulation
    results <- run_process_silent(current_params, initial_hosts)
    # Return results with parameter context
    return(list(
      params = current_params,
      results = results
    ))
  })
  ###############################################################
  
  # Stop the cluster
  stopCluster(cl)
  # Monitoring
  elapsed_time <- toc(quiet = TRUE)
  # Prompt simulation success
  cli::cli_alert_success(paste0("Simulation completed (", elapsed_time$callback_msg , ")\n\n"))
  
  return(all_results)
}