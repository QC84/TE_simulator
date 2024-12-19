# Results of batch simulation (list) have been imported under the name 'res'

# Sélectionner tous les réplicats avec tel r_mig et tel r_kill

r_mig  <- 0.01
r_kill <- 0.0005

select_res <- function(res, r_mig, r_kill){
  # Guard-rail
  available_r_mig  <-  sapply(res, function(x) x$params$events$r_mig) |> unique()
  available_r_kill <- sapply(res, function(x) x$params$events$r_kill) |> unique()
  if( !(r_mig %in% available_r_mig & r_kill %in% available_r_kill) ){
    stop("Bad r_mig or r_kill")
  }
  # Filter the list according to choosen r_mig & r_kill
  filtered_results <- res[sapply(res, function(x) {
    isTRUE(x$params$events$r_mig == r_mig & x$params$events$r_kill == r_kill)
  })]
  # Returning only the results part
  return(lapply(filtered_results, function(x) x$results))
}

res_filtered <- select_res(res, r_mig, r_kill)

# Plot the replicates

tau <- res[[1]]$params$other$tau
predicted_mean <- 1 + (r_mig / r_kill)
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
  main = ""
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
  "topleft",
  legend = c("Predicted", "Actual"),
  col = c("darkgreen", "darkred"),
  lwd = 3,
  lty = c(1, 1)
)

