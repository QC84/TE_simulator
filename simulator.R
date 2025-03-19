# CLI ARGUMENTS -----------------------------------------------------------
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2) {
  cat("Usage: Rscript script.R <taux> <resolution>\n")
  cat("Example: Rscript script.R 0.2 30\n")
  cat("If you don't want to tweak the parameters, choose any <taux> and a <resolution> of 1\n")
  quit(status = 1)
}

# Convert arguments to numeric
taux <- as.numeric(args[1])
resolution <- as.numeric(args[2])

# Validate inputs
if (is.na(taux) || taux <= 0 || taux >= 1) {
  stop("<taux> must be a number between 0 and 1")
}
if (is.na(resolution) || resolution <= 0) {
  stop("<resolution> must be a positive number")
}
# LOCAL FUNCTIONS ---------------------------------------------------------
cli::cli_h2("FUNCTIONS")
r_files <- list.files(path = "./R",
                      pattern = "*.R",
                      full.names = TRUE)
for (file in r_files) {
  cat(paste0("Sourcing: ", basename(file), "\n"))
  source(file)
}
cat("\n")

# PARAMETERS --------------------------------------------------------------
cli::cli_h2("PARAMETERS")

## Load -------------------------------------------------------------------
source("./config.R")
# This script also prints object name & key values

## Tweak ------------------------------------------------------------------
custom_r_mig <- seq(from = params$events$r_mig - (params$events$r_mig * taux),
                    to   = params$events$r_mig + (params$events$r_mig * taux),
                    length.out = resolution)
custom_r_kill <- seq(from = params$events$r_kill - (params$events$r_kill * taux),
                     to   = params$events$r_kill + (params$events$r_kill * taux),
                     length.out = resolution)

params_grid <- tweak(params,
                     r_mig = custom_r_mig,
                     r_kil = custom_r_kill)

cat("r_mig will varie from", range(custom_r_mig)[1], "to", range(custom_r_mig)[2], "\n")
cat("r_kill will varie from", range(custom_r_kill)[1], "to", range(custom_r_kill)[2], "\n")
cat("Total:", length(custom_r_mig), "(r_mig) x", length(custom_r_kill), "(r_kill) x", params$other$n_rep, "(replicates)\n\n") 
cat("Do you want to continue? [y/N]: \n")
answer <- readLines("stdin", n=1)
if (tolower(answer) != "y") {
  cat("Execution cancelled by user\n")
  quit(status = 1)
}
## Validate ---------------------------------------------------------------
cat("------Validate------\n\n")
validity <- FALSE
validity <- params_grid |> validate()

# Parallel run
cli::cli_h2("SIMULATIONS")
batch_results_par <- run_batch_par(validity,
                                   params,
                                   params_grid,
                                   n_cores = min(parallel::detectCores() - 1, params$other$n_rep))

# Saving results
current_time <- Sys.time()
saveRDS(object = batch_results_par,
        file = paste0("./RESULTS/", substr(gsub(pattern = " ", replacement = "_", x = current_time),1,19), ".rds"))
cat("Results have been saved in ~/RESULTS directory\n")
