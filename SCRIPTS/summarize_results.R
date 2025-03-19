# SUMMARIZE ---------------------------------------------------------------
cli::cli_h2("SUMMARIZE")

# Importing the most recent file of ./RESULTS directory
rds_files <- list.files(path = "./RESULTS", pattern = "\\.rds$", full.names = TRUE)
if (length(rds_files) > 0) {
  most_recent_file <- rds_files[which.max(file.info(rds_files)$mtime)]
  res <- readRDS(most_recent_file)
  cat(most_recent_file, "have been imported succesfully (most recent file of the directory)\n")
} else {
  stop("No .rds files found in the specified directory")
}

# Print available parameters
cat("------ Available parameters ------\n\n")
available_r_mig  <-  sapply(res, function(x) x$params$events$r_mig) |> unique()
available_r_kill <- sapply(res, function(x) x$params$events$r_kill) |> unique()
cat("r_mig:  ", available_r_mig, "\n")
cat("r_kill: ", available_r_kill, "\n")

# Select from available parameters
selected_r_mig  <- available_r_mig[8]
selected_r_kill <- available_r_kill[1]

# Filter the res list according to choosen r_mig & r_kill
res_filtered <- res[sapply(res, function(x) {
  isTRUE(x$params$events$r_mig == selected_r_mig &
         x$params$events$r_kill == selected_r_kill)})] |> 
  lapply(function(x) x$results)

# Create a 'mean result' data-frame
mean_res <- Reduce(`+`, res_filtered) / length(res_filtered)

# Generate plots

tau <- res[[1]]$params$other$tau
predicted_mean <- 1 + (selected_r_mig / selected_r_kill)
my_alpha = 0.4

plot(
  x = 1:tau,
  y = res_filtered[[1]]$mean,
  type = "l",
  col =  adjustcolor("darkred", alpha.f = my_alpha),
  lwd = 3,
  xlab = "Generations",
  ylab = "Count",
  ylim = c(0, predicted_mean + 10),
  main = paste0(
    "PARAMETERS :      ",
    "N = ",
    res[[1]]$params$init$N,
    "   |   ",
    "R_mig = ",
    res[[1]]$params$events$r_mig,
    "   |   ",
    "R_kill = ",
    res[[1]]$params$events$r_kill
  )
)
grid()
for (i in 2:length(res_filtered)) {
  lines(
    x = 1:tau,
    y = res_filtered[[i]]$mean,
    col = adjustcolor("darkred", alpha.f = my_alpha),
    lwd = 2
  )
}
abline(h = predicted_mean,
       col = "darkgreen",
       lwd = 3)
legend(
  "bottomright",
  legend = c("Predicted", "Actual"),
  col = c("darkgreen", "darkred"),
  lwd = 3,
  lty = c(1, 1)
)




# Display infos

