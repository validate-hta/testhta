# 
# # simulate state populations
# sim_pop <- function(n_cycles, age,
#                     trans_c_matrix,
#                     p_matrix, pop, trans, i) {
#   
#   for (j in 2:n_cycles) {
#     p_matrix <- p_matrix_cycle(p_matrix, age, j - 1)
#     pop[, cycle = j, i] <-
#       pop[, cycle = j - 1, i] %*% p_matrix[, , i]
#     trans[, cycle = j, i] <-
#       pop[, cycle = j - 1, i] %*% (trans_c_matrix * p_matrix[, , i])
#     age <- age + 1
#   }
#   
#   list(pop = pop[, , i],
#        trans = trans[, , i])
# }
# 
# 
# for (i in 1:n_treatments) {
#   
#   # simulate state populations
#   sim_res <-
#     sim_pop(n_cycles, Initial_age,
#             trans_c_matrix,
#             p_matrix, pop, trans, i)
#   
#   trans[, , i] <- sim_res$trans
#   pop[, , i] <- sim_res$pop
#   
#   cycle_state_costs[i, ] <-
#     (state_c_matrix[treatment = i, ] %*% pop[, , treatment = i]) * 1/(1 + cDr)^(1:n_cycles - 1)
#   
#   # discounting at _previous_ cycle
#   cycle_trans_costs[i, ] <-
#     (c(1,1,1) %*% trans[, , treatment = i]) * 1/(1 + cDr)^(1:n_cycles - 2)
#   
#   cycle_costs[i, ] <- cycle_state_costs[i, ] + cycle_trans_costs[i, ]
#   
#   # life expectancy
#   LE[i, ] <- c(1,1,0) %*% pop[, , treatment = i]
#   
#   # life-years
#   LYs[i, ] <- LE[i, ] * 1/(1 + oDr)^(1:n_cycles - 1)
#   
#   # quality-adjusted life expectancy
#   cycle_QALE[i, ] <-
#     state_q_matrix[treatment = i, ] %*% pop[, , treatment = i]
#   
#   # quality-adjusted life-years
#   cycle_QALYs[i, ] <- cycle_QALE[i, ] * 1/(1 + oDr)^(1:n_cycles - 1)
#   
#   total_costs[i] <- sum(cycle_costs[treatment = i, -1])
#   total_QALYs[i] <- sum(cycle_QALYs[treatment = i, -1])
# }
