validate <- function(params_grid){
  for(i in seq_len(nrow(params_grid))){
    stopifnot(
      params_grid[i,]$N >  0,
      params_grid[i,]$p0 >= 0 && params_grid[i,]$p0 <= 1,
      params_grid[i,]$r_mig >= 0 && params_grid[i,]$r_mig <= 1,
      params_grid[i,]$r_kill >= 0 && params_grid[i,]$r_kill <= 1,
      params_grid[i,]$strat   %in% c("neutral", "weighted"),
      params_grid[i,]$prop_dead>= 0 && params_grid[i,]$prop_dead<= 1,
      params_grid[i,]$max > 0,
      params_grid[i,]$count > 0,
      params_grid[i,]$tau > 0,
      params_grid[i,]$seed > 0
    )
  }
  cli::cli_alert_success("Valid input parameters\n")
  return(TRUE)
}
