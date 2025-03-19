# IMPORT ------------------------------------------------------------------
# Import simulation results
res <- readRDS("./RESULTS/2025-03-19_09:46:45.rds")


# WRANGLING ---------------------------------------------------------------
# Identify unique parameter sets
param_sets <- list()
results_by_params <- list()
# Extract parameter values
for(i in 1:length(res)) {
  param_id <- paste(
    res[[i]]$params$init$N,
    res[[i]]$params$init$p0,
    res[[i]]$params$events$r_mig,
    res[[i]]$params$events$r_kill,
    res[[i]]$params$events$strat,
    sep = "_"
  )
  
  if(!(param_id %in% names(results_by_params))) {
    results_by_params[[param_id]] <- list()
    param_sets[[param_id]] <- res[[i]]$params
  }
  
  results_by_params[[param_id]] <- c(results_by_params[[param_id]], list(res[[i]]$results))
}
# Calculate means at each timepoint across replicates
summary_results <- lapply(names(results_by_params), function(param_id) {
  reps <- results_by_params[[param_id]]
  n_timepoints <- nrow(reps[[1]])
  
  # Create empty matrices for each variable
  all_min <- matrix(0, nrow=n_timepoints, ncol=length(reps))
  all_max <- matrix(0, nrow=n_timepoints, ncol=length(reps))
  all_mean <- matrix(0, nrow=n_timepoints, ncol=length(reps))
  all_killed <- matrix(0, nrow=n_timepoints, ncol=length(reps))
  all_total <- matrix(0, nrow=n_timepoints, ncol=length(reps))
  
  # Fill matrices with data from each replicate
  for(j in 1:length(reps)) {
    all_min[,j] <- reps[[j]]$min
    all_max[,j] <- reps[[j]]$max
    all_mean[,j] <- reps[[j]]$mean
    all_killed[,j] <- reps[[j]]$killed_hosts
    all_total[,j] <- reps[[j]]$total_end
  }
  
  # Calculate row means (across replicates)
  list(
    params = param_sets[[param_id]],
    results = data.frame(
      min = rowMeans(all_min),
      max = rowMeans(all_max),
      mean = rowMeans(all_mean),
      killed_hosts = rowMeans(all_killed),
      total_end = rowMeans(all_total)
    )
  )
})
# Return the same structure as input but with averaged results
names(summary_results) <- names(results_by_params)


# PLOT --------------------------------------------------------------------
# Function to plot one parameter set
plot_results <- function(result) {
  df <- result$results
  time <- 1:nrow(df)
  param <- result$params
  
  # Create main plot
  plot(time, df$mean, type="l", lwd=2,
       main=sprintf("N=%d, p0=%g, r_mig=%g, r_kill=%g, n_rep=%s", 
                    param$init$N, param$init$p0, 
                    param$events$r_mig, param$events$r_kill, 
                    param$other$n_rep),
       xlab="Tau", ylab="Number of TEs (log_2)",
       ylim=c(min(df$min), max(df$max)),
       log = "y")
  
  # Add min/max as dashed lines
  lines(time, df$min, lty=2, col="blue")
  lines(time, df$max, lty=2, col="red")
  
  # Add legend
  legend("topleft", legend=c("Mean", "Min", "Max"),
         col=c("black", "blue", "red"), 
         lty=c(1, 2, 2), lwd=c(2, 1, 1))
  
  grid()
}
# Plot all results sequentially
names(summary_results)
plot_results(summary_results[[14]])
