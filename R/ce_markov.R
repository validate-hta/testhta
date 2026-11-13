#' @title Run cost-effectiveness Markov model
#' @description Runs a discrete-time cohort Markov model to calculate costs,
#'   QALYs, and life expectancy for different treatments.
#' @param start_pop A vector of initial population counts for each health state.
#' @param p_matrix A 3D array of transition probabilities for each treatment.
#' @param state_c_matrix A matrix of state costs for each treatment.
#' @param state_q_matrix A matrix of state utilities for each treatment.
#' @param n_cycles The number of cycles to run the model for.
#' @param init_age The initial age of the population.
#' @param s_names Optional names for the health states.
#' @param t_names Optional names for the treatments.
#' @param discount_rate The discount rate to apply to costs and QALYs.
#' @param ... Additional arguments passed to `p_matrix_cycle()`.
#' @importFrom stats setNames
#' @return A list containing the population array, total and per-person life
#'   expectancy (`total_LE`, `total_LE_pp`), total and per-person life-years
#'   (`total_LYs`, `total_LYs_pp`), cycle costs, cycle QALYs, and total and
#'   per-person costs (`total_costs`, `total_costs_pp`) and QALYs
#'   (`total_QALYs`, `total_QALYs_pp`) for each treatment.
#' @examples
#' data(base_params)
#' res <- do.call(ce_markov, base_params)
#' res$total_costs
#' @export
ce_markov <- function(start_pop,
                      p_matrix,
                      state_c_matrix,
                      state_q_matrix,
                      n_cycles = 46,
                      init_age = 55,
                      s_names = NULL,
                      t_names = NULL,
                      discount_rate = 0.035,
                      ...) {
  n_states <- length(start_pop)
  n_treat <- dim(p_matrix)[3]
  if (is.null(s_names)) s_names <- dimnames(p_matrix)[[1]]
  if (is.null(t_names)) t_names <- dimnames(p_matrix)[[3]]

  pop <- array(
    data = NA,
    dim = c(n_states, n_cycles, n_treat),
    dimnames = list(
      state = s_names,
      cycle = NULL,
      treatment = t_names
    )
  )

  for (i in 1:n_states) {
    pop[i, cycle = 1, ] <- start_pop[i]
  }

  cycle_empty_array <-
    array(
      NA,
      dim = c(n_treat, n_cycles),
      dimnames = list(
        treatment = t_names,
        cycle = NULL
      )
    )

  cycle_costs <- cycle_QALYs <- cycle_empty_array
  LE <- LYs <- cycle_empty_array # life expectancy; life-years
  cycle_QALE <- cycle_empty_array # quality-adjusted life expectancy

  total_costs <- setNames(rep(NA, n_treat), t_names)
  total_QALYs <- setNames(rep(NA, n_treat), t_names)
  total_LE <- setNames(rep(NA, n_treat), t_names)
  total_LYs <- setNames(rep(NA, n_treat), t_names)

  df_state <- 1 / (1 + discount_rate)^(1:n_cycles - 1)
  df_trans <- 1 / (1 + discount_rate)^(1:n_cycles - 2)
  df_qaly <- 1 / (1 + discount_rate)^(1:n_cycles - 1)

  for (i in 1:n_treat) {
    age <- init_age

    if (n_cycles > 1) {
      for (j in 2:n_cycles) {
        p_matrix <- p_matrix_cycle(p_matrix, age, j - 1, ...)

        # update population with matrix multiplication
        pop[, cycle = j, treatment = i] <-
          pop[, cycle = j - 1, treatment = i] %*% p_matrix[, , treatment = i]

        age <- age + 1
      }
    }

    cycle_costs[i, ] <-
      (state_c_matrix[treatment = i, ] %*% pop[, , treatment = i]) * df_state

    LE[i, ] <- c(1, 1, 0) %*% pop[, , treatment = i]

    LYs[i, ] <- LE[i, ] * df_qaly

    cycle_QALE[i, ] <-
      state_q_matrix[treatment = i, ] %*% pop[, , treatment = i]

    cycle_QALYs[i, ] <- cycle_QALE[i, ] * df_qaly

    total_LE[i] <- sum(LE[treatment = i, ])
    total_LYs[i] <- sum(LYs[treatment = i, ])

    total_costs[i] <- sum(cycle_costs[treatment = i, ])
    total_QALYs[i] <- sum(cycle_QALYs[treatment = i, ])
  }

  n_pop <- sum(start_pop)

  list(
    pop = pop,
    total_LE = total_LE,
    total_LYs = total_LYs,
    total_LE_pp = total_LE / n_pop,
    total_LYs_pp = total_LYs / n_pop,
    cycle_costs = cycle_costs,
    cycle_QALYs = cycle_QALYs,
    total_costs = total_costs,
    total_QALYs = total_QALYs,
    total_costs_pp = total_costs / n_pop,
    total_QALYs_pp = total_QALYs / n_pop
  )
}

#' Sample probabilistic sensitivity analysis (PSA) parameters
#'
#' Generates Monte Carlo samples of health state utility parameters from Beta
#' distributions for stochastic verification tests (e.g., Registry test `T12`).
#'
#' @param n_sim Number of Monte Carlo simulation draws (default: `1000`).
#' @param base_params Optional baseline parameter list.
#' @return A `data.frame` with columns `utility_Asymptomatic` and
#'   `utility_Progressive`.
#' @examples
#' data(base_params)
#' samples <- sample_psa_parameters(n_sim = 10, base_params = base_params)
#' head(samples)
#' @export
sample_psa_parameters <- function(n_sim = 1000, base_params = NULL) {
  data.frame(
    utility_Asymptomatic = stats::rbeta(n_sim, shape1 = 69, shape2 = 4),
    utility_Progressive = stats::rbeta(n_sim, shape1 = 24, shape2 = 8)
  )
}
