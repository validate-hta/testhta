# Run Markov model script (aligned with tutorial paper base_params)

t_names <- c("without_drug", "with_drug")
n_treatments <- length(t_names)

s_names <- c("Asymptomatic", "Progressive", "Dead")
n_states <- length(s_names)

n_cohort <- 1000

# Baseline parameters matching Section 5.1 & 6.1 of the tutorial paper
base_params <- list(
  start_pop = setNames(c(n_cohort, 0, 0), s_names),
  p_matrix = array(
    c(
      0.75, 0, 0, 0.2, 0.9, 0, 0.05, 0.1, 1,
      0.85, 0, 0, 0.1, 0.95, 0, 0.05, 0.05, 1
    ),
    dim = c(n_states, n_states, n_treatments),
    dimnames = list(s_names, s_names, t_names)
  ),
  state_c_matrix = matrix(
    c(
      100, 200, 0,
      500, 200, 0
    ),
    nrow = n_treatments, ncol = n_states, byrow = TRUE,
    dimnames = list(t_names, s_names)
  ),
  state_q_matrix = matrix(
    c(
      0.9, 0.6, 0,
      0.9, 0.6, 0
    ),
    nrow = n_treatments, ncol = n_states, byrow = TRUE,
    dimnames = list(t_names, s_names)
  ),
  n_cycles = 15,
  discount_rate = 0.035
)

res <- do.call(ce_markov, base_params)

# Incremental costs and QALYs of with_drug vs without_drug
c_incr <- res$total_costs["with_drug"] - res$total_costs["without_drug"]
q_incr <- res$total_QALYs["with_drug"] - res$total_QALYs["without_drug"]

# Incremental cost-effectiveness ratio
ICER <- c_incr / q_incr
