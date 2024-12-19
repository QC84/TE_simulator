# SUMMARY -----------------------------------------------------------------
cli::cli_h2("SUMMARY")
# Importing the most recent file of ./RESULTS directory
rds_files <- list.files(path = "./RESULTS", pattern = "\\.rds$", full.names = TRUE)
if (length(rds_files) > 0) {
  most_recent_file <- rds_files[which.max(file.info(rds_files)$mtime)]
  res <- readRDS(most_recent_file)
  cat(most_recent_file, "have been imported succesfully\n")
} else {
  stop("No .rds files found in the specified directory")
}