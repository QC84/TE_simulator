# Mission: améliorer run_process_silent()
source("./config.R") # Loading params
source("./R/run_process_silent.R") # Load original function
source("./R/generate_init.R") # Creating initial hosts pop
initial_hosts <- params |> generate_init()

run_process_silent(params, initial_hosts) -> res
run_process_silent(params, initial_hosts) |> profvis::profvis()
run_process_silent(params, initial_hosts) |> microbenchmark::microbenchmark(times = 10)

################################################################################
source("./R/run_process_silent2.R")
run_process_silent2(params, initial_hosts) -> res
run_process_silent2(params, initial_hosts) |> profvis::profvis()
run_process_silent2(params, initial_hosts) |> microbenchmark::microbenchmark(times = 10)
