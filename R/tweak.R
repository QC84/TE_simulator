tweak <- function(params, r_mig, r_kill){
  params_grid <- tidyr::expand_grid(
    N         = params$init$N,
    p0        = params$init$p0,
    r_mig     = r_mig,
    r_kill    = r_kill,
    strat     = params$events$strat,
    prop_dead = params$breakif$prop_dead,
    max       = params$breakif$max,
    count     = params$breakif$count,
    tau       = params$other$tau,
    seed      = params$other$seed:(params$other$seed+(params$other$n_rep-1)) # We are running n_rep replicates
  )
  return(params_grid)
}