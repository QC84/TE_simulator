# RETREIVING PARAMETERS ---------------------------------------------------
source("./CONFIG/default.R")

# TWEAK PARAMETERS --------------------------------------------------------
taux <- 0
resolution <- 1
source("./R/tweak.R")
custom_r_mig <- seq(from = params$events$r_mig - (params$events$r_mig * taux),
                    to   = params$events$r_mig + (params$events$r_mig * taux),
                    length.out = resolution)
custom_r_kill <- seq(from = params$events$r_kill - (params$events$r_kill * taux),
                     to   = params$events$r_kill + (params$events$r_kill * taux),
                     length.out = resolution)

params_grid <- tweak(params,
                     r_mig = custom_r_mig,
                     r_kil = custom_r_kill)

# VALIDATE PARAMETERS -----------------------------------------------------
source("./R/validate.R")
validity <- validate(params_grid)

# RUN ---------------------------------------------------------------------
source("./R/run_batch_par.R")
run_batch_par(validity)

