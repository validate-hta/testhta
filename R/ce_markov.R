
#' @title run cost-effectiveness model
#' @description Runs a Markov model to calculate costs, QALYs, and life expectancy for different treatments
#' @param start_pop A vector of initial population counts for each health state
#' @param p_matrix A 3D array of transition probabilities for each treatment
#' @param state_c_matrix A matrix of state costs for each treatment
#' @param trans_c_matrix A matrix of transition costs for each treatment
#' @param state_q_matrix A matrix of state utilities for each treatment
#' @param n_cycles The number of cycles to run the model for
#' @param init_age The initial age of the population
#' @param s_names Optional names for the health states
#' @param t_names Optional names for the treatments
#' @param discount_rate The discount rate to apply to costs and QALYs
#' @param ... Additional arguments passed to p_matrix_cycle.
#' @importFrom stats setNames
#' @return A list containing the population array, total life expectancy, total life-years,
#' cycle costs, cycle QALYs, total costs, and total QALYs for each treatment
#' @export
ce_markov <- function(start_pop,
                      p_matrix,
                      state_c_matrix,
                      trans_c_matrix,
                      state_q_matrix,
                      n_cycles = 46,
                      init_age = 55,
                      s_names = NULL,
                      t_names = NULL,
                      discount_rate = 0.035,
                      ...) {
  
  n_states <- length(start_pop)
  n_treat <- dim(p_matrix)[3]
  
  pop <- array(data = NA,
               dim = c(n_states, n_cycles, n_treat),
               dimnames = list(state = s_names,
                               cycle = NULL,
                               treatment = t_names))
  trans <- array(data = 0,
                 dim = c(n_states, n_cycles, n_treat),
                 dimnames = list(state = s_names,
                                 cycle = NULL,
                                 treatment = t_names))
  
  for (i in 1:n_states) {
    pop[i, cycle = 1, ] <- start_pop[i]
  }
  
  cycle_empty_array <-
    array(NA,
          dim = c(n_treat, n_cycles),
          dimnames = list(treatment = t_names,
                          cycle = NULL))
  
  cycle_state_costs <- cycle_trans_costs <- cycle_empty_array
  cycle_costs <- cycle_QALYs <- cycle_empty_array
  LE <- LYs <- cycle_empty_array    # life expectancy; life-years
  cycle_QALE <- cycle_empty_array   # quality-adjusted life expectancy
  
  total_costs <- setNames(rep(NA, n_treat), t_names)
  total_QALYs <- setNames(rep(NA, n_treat), t_names)
  total_LE <- setNames(rep(NA, n_treat), t_names)
  total_LYs <- setNames(rep(NA, n_treat), t_names)
  
  df_state <- 1/(1 + discount_rate)^(1:n_cycles - 1)
  df_trans <- 1/(1 + discount_rate)^(1:n_cycles - 2)
  df_qaly <- 1/(1 + discount_rate)^(1:n_cycles - 1)
  
  if (discount_rate >= 1) {
    df_state[] <- 0
    df_qaly[] <- 0
    df_trans[] <- 0
  }

  for (i in 1:n_treat) {
    
    age <- init_age
    
    for (j in 2:n_cycles) {
      
      p_matrix <- p_matrix_cycle(p_matrix, age, j - 1, ...)
      
      # update population with matrix multiplication
      pop[, cycle = j, treatment = i] <-
        pop[, cycle = j - 1, treatment = i] %*% p_matrix[, , treatment = i]
      
      trans[, cycle = j, treatment = i] <-
        pop[, cycle = j - 1, treatment = i] %*% (trans_c_matrix * p_matrix[, , treatment = i])
      
      age <- age + 1
    }
    
    cycle_state_costs[i, ] <-
      (state_c_matrix[treatment = i, ] %*% pop[, , treatment = i]) * df_state
    
    cycle_trans_costs[i, ] <-
      (c(1,1,1) %*% trans[, , treatment = i]) * df_trans
    
    cycle_costs[i, ] <- cycle_state_costs[i, ] + cycle_trans_costs[i, ]
    
    LE[i, ] <- c(1,1,0) %*% pop[, , treatment = i]
    
    LYs[i, ] <- LE[i, ] * df_qaly
    
    cycle_QALE[i, ] <-
      state_q_matrix[treatment = i, ] %*%  pop[, , treatment = i]
    
    cycle_QALYs[i, ] <- cycle_QALE[i, ] * df_qaly
    
    total_LE[i] <- sum(LE[treatment = i, ])
    total_LYs[i] <- sum(LYs[treatment = i, ])
    
    total_costs[i] <- sum(cycle_costs[treatment = i, ])
    total_QALYs[i] <- sum(cycle_QALYs[treatment = i, ])
  }
  
  list(pop = pop,
       total_LE = total_LE,
       total_LYs = total_LYs,
       cycle_costs = cycle_costs,
       cycle_QALYs = cycle_QALYs,
       total_costs = total_costs,
       total_QALYs = total_QALYs)
}
