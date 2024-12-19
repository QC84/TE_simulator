generate_init <- function(params){
  N <- params$init$N
  p0 <- params$init$p0
  pop <- integer(N)
  pop[1:floor(p0 * N)] <- 1
  init <- pop
  return(init)
}