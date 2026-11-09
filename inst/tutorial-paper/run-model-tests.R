# ==============================================================================
# Automated Verification for Health Economic Models in R: End-to-End Test Suite
# ==============================================================================
# This script provides a self-contained, reproducible execution of the automated 
# test suite detailed in the manuscript.

library(testthat)

# library(testhta) # Uncomment to load package's internal engine
# devtools::load_all(".")

# ------------------------------------------------------------------------------
# 1. Baseline Input Parameters
# ------------------------------------------------------------------------------
t_names <- c("without_drug", "with_drug")
s_names <- c("Asymptomatic", "Progressive", "Dead")

base_params <- list(
  start_pop = c(1000, 0, 0),
  p_matrix = array(
    c(0.75, 0, 0, 0.2, 0.9, 0, 0.05, 0.1, 1,
      0.85, 0, 0, 0.1, 0.95, 0, 0.05, 0.05, 1), 
    dim = c(3, 3, 2),
    dimnames = list(s_names, s_names, t_names)
  ),
  state_c_matrix = matrix(
    c(100, 200, 0, 
      500, 200, 0),
    nrow = 2, ncol = 3, byrow = TRUE,
    dimnames = list(t_names, s_names)
  ),
  state_q_matrix = matrix(
    c(0.9, 0.6, 0, 
      0.9, 0.6, 0),
    nrow = 2, ncol = 3, byrow = TRUE,
    dimnames = list(t_names, s_names)
  ),
  n_cycles = 15,
  discount_rate = 0.035
)

# ------------------------------------------------------------------------------
# 2. Model Engine & Wrapper
# ------------------------------------------------------------------------------
# NOTE: In a real environment, `ce_markov` is provided by the package.
# The `run_model` wrapper allows us to merge default parameters with test overrides.

run_model <- function(data, ...) {
  updates <- list(...)
  args_list <- modifyList(data, updates)
  
  do.call(ce_markov, args_list)
}

# ------------------------------------------------------------------------------
# 3. Helper Functions (Getters)
# ------------------------------------------------------------------------------
get_qalys    <- function(res) { res$total_QALYs }
get_costs    <- function(res) { res$total_costs }
get_le       <- function(res) { res$total_LE }
get_qalys_pp <- function(res) { res$total_QALYs_pp }
get_costs_pp <- function(res) { res$total_costs_pp }
get_le_pp    <- function(res) { res$total_LE_pp }
get_icer     <- function(res) { 
  inc_cost <- res$total_costs["with_drug"] - res$total_costs["without_drug"]
  inc_qaly <- res$total_QALYs["with_drug"] - res$total_QALYs["without_drug"]
  inc_cost / inc_qaly
}

sample_psa_parameters <- function(n_sim = 1000, base_params = NULL) {
  data.frame(
    utility_Asymptomatic = stats::rbeta(n_sim, shape1 = 69, shape2 = 4),
    utility_Progressive  = stats::rbeta(n_sim, shape1 = 24, shape2 = 8)
  )
}

# ------------------------------------------------------------------------------
# 4. Custom Expectations
# ------------------------------------------------------------------------------
check_model_qalys <- function(data, expected_qalys, ..., tolerance = NULL, label = NULL) {
  run <- run_model(data, ...)
  actual <- get_qalys(run)
  if (length(expected_qalys) == 1) {
    expected_qalys <- setNames(rep(expected_qalys, length(actual)), names(actual))
  }
  expect_equal(actual, expected_qalys, tolerance = tolerance, label = label)
}

check_model_costs <- function(data, expected_costs, ..., tolerance = NULL, label = NULL) {
  run <- run_model(data, ...)
  actual <- get_costs(run)
  if (length(expected_costs) == 1) {
    expected_costs <- setNames(rep(expected_costs, length(actual)), names(actual))
  }
  expect_equal(actual, expected_costs, tolerance = tolerance, label = label)
}

check_model_le <- function(data, expected_le, ..., label = NULL) {
  run <- run_model(data, ...)
  actual <- get_le(run)
  if (length(expected_le) == 1) {
    expected_le <- setNames(rep(expected_le, length(actual)), names(actual))
  }
  expect_equal(actual, expected_le, label = label)
}

check_model_le_pp <- function(data, expected_le, ..., label = NULL) {
  run <- run_model(data, ...)
  actual <- get_le_pp(run)
  if (length(expected_le) == 1) {
    expected_le <- setNames(rep(expected_le, length(actual)), names(actual))
  }
  expect_equal(actual, expected_le, label = label)
}

compare_model_runs <- function(extractor_fn, comparison_fn, params_1, params_2, data, label = NULL) {
  run_1_args <- c(list(data = data), params_1)
  run_1 <- do.call(run_model, run_1_args)
  output_1 <- extractor_fn(run_1)
  
  run_2_args <- c(list(data = data), params_2)
  run_2 <- do.call(run_model, run_2_args)
  output_2 <- extractor_fn(run_2)
  
  for (idx in seq_along(output_1)) {
    comparison_fn(output_1[[idx]], output_2[[idx]], label = label)
  }
}

# ------------------------------------------------------------------------------
# 5. Automated Test Suite (Registry T01 - T12)
# ------------------------------------------------------------------------------

test_that("T06: Discounted QALYs are lower than undiscounted QALYs", {
  # run model with standard discounting (3.5%)
  results_discounted <- with(base_params,
    ce_markov(start_pop, p_matrix, state_c_matrix,
              state_q_matrix, n_cycles, discount_rate = 0.035))
  
  # run model with NO discounting (0%)
  results_undiscounted <- with(base_params,
    ce_markov(start_pop, p_matrix, state_c_matrix,
              state_q_matrix, n_cycles, discount_rate = 0.0))
  
  # alternatively:
  # results_discounted <- 
  #  run_model(base_params, discount_rate = 0.035)
  # results_undiscounted <- 
  #  run_model(base_params, discount_rate = 0.00)
  
  # extract the total QALYs using getter
  # could use direct list access instead
  qaly_discounted <- get_qalys(results_discounted)
  qaly_undiscounted <- get_qalys(results_undiscounted)
  
  # expectation: discounted must be less than undiscounted value
  expect_lt(qaly_discounted["without_drug"], 
            qaly_undiscounted["without_drug"])
  expect_lt(qaly_discounted["with_drug"], 
            qaly_undiscounted["with_drug"])
})

test_that("T07 & T11: High discounting reduces future value to 0", {
  # Run full model with extreme discount
  res_high_disc <- run_model(base_params, discount_rate = 1000)
  
  # Run a baseline model for only 1 cycle (time 0)
  res_cycle_zero <- run_model(base_params, n_cycles = 1)
  
  # Check Costs (T11)
  expect_equal(
    get_costs(res_high_disc), 
    get_costs(res_cycle_zero), 
    tolerance = 0.01,
    label = "T11: High discount total costs equal cycle 0 costs"
  )
  
  # Check QALYs (T07)
  expect_equal(
    get_qalys(res_high_disc), 
    get_qalys(res_cycle_zero), 
    tolerance = 0.01,
    label = "T07: High discount total QALYs equal cycle 0 QALYs"
  )
})

test_that("T08: Zero intervention cost strictly reduces ICER", {
  # Temporary wrapper to isolate intervention cost
  run_with_intervention_cost <- function(c_int) {
    temp_params <- base_params
    temp_params$state_c_matrix["with_drug", "Asymptomatic"] <- 
      temp_params$state_c_matrix["without_drug", "Asymptomatic"] + c_int
    
    run_model(temp_params)
  }
  
  # Run model with a standard positive intervention cost
  res_base <- run_model(base_params)
  
  # Run model with zero intervention cost
  res_no_int <- run_with_intervention_cost(c_int = 0)
  
  # extract ICERs
  res_no_int_icer <- get_icer(res_no_int)
  res_base_icer <- get_icer(res_base)
  
  # extract baseline Incremental Effects (IE) 
  # to handle ICER directionality
  base_qalys <- get_qalys(res_base)
  res_base_ie <- unname(base_qalys["with_drug"] - 
                          base_qalys["without_drug"])
  
  # verify ICER directional change based on the sign of IE
  # skip the rest of this block if assumption fails
  testthat::skip_if_not(
    res_base_ie > 0, 
    "Baseline incremental QALYs are <= 0. 
     Skipping ICER directionality tests."
  )
  
  expect_lt(res_no_int_icer, res_base_icer)
})

test_that("T03: Immediate mortality results in LE of 1", {
  # modify p_matrix to force death
  dead_p_matrix <- base_params$p_matrix
  dead_p_matrix[] <- 0
  dead_p_matrix[, "Dead", ] <- 1 # all transitions go to Dead
  
  res_death <- run_model(base_params, p_matrix = dead_p_matrix)
  res_le <- get_le_pp(res_death)
  
  # is Life Expectancy for all scenarios = 1 cycle
  expect_equal(unname(res_le), rep(1, length(res_le)))
})

#######################
# full set of tests

test_that("QALY calculations", {
  u_one_matrix <- base_params$state_q_matrix
  u_one_matrix[, c("Asymptomatic", "Progressive")] <- 1
  
  # T04: Undiscounted QALYs (with u=1) should equal LE
  test_run_t04 <- run_model(base_params, discount_rate = 0, state_q_matrix = u_one_matrix)
  expect_equal(
    get_qalys(test_run_t04), get_le(test_run_t04),
    label = "T04: Undiscounted QALYs (with u=1) should equal LE"
  )
  
  # T05: QALY gains exactly equal LYGs when all utilities are 1
  test_run_t05 <- run_model(base_params, discount_rate = 0, state_q_matrix = u_one_matrix)
  expect_equal(
    get_qalys(test_run_t05)["with_drug"] - get_qalys(test_run_t05)["without_drug"],
    get_le(test_run_t05)["with_drug"] - get_le(test_run_t05)["without_drug"],
    label = "T05: QALYs exactly equals LYGs when all utilities are 1"
  )
  
  # T06: QALYs with standard discount < undiscounted QALYs
  compare_model_runs(
    extractor_fn = get_qalys,
    comparison_fn = expect_lt,
    params_1 = list(discount_rate = 0.035),
    params_2 = list(discount_rate = 0),
    data = base_params,
    label = "T06: Discounted should be less than undiscounted QALYs"
  )
  
  # T07: High QALY discount rate reduces totals to cycle 0
  res_cycle_zero <- run_model(base_params, n_cycles = 1)
  check_model_qalys(
    data = base_params,
    discount_rate = 1000,
    expected_qalys = get_qalys(res_cycle_zero),
    tolerance = 0.01,
    label = "T07: High discount total QALYs equal cycle 0 QALYs"
  )
})

test_that("Cost calculations", {
  # Baseline calculation to handle ICER directionality (IE must be positive)
  base_res <- run_model(base_params)
  base_qalys <- get_qalys(base_res)
  inc_qalys <- unname(base_qalys["with_drug"] - base_qalys["without_drug"])
  
  skip_if_not(
    inc_qalys > 0, 
    "Baseline incremental QALYs are <= 0. Skipping ICER directionality tests."
  )
  
  # T08: Set intervention costs = 0. ICER is reduced
  c_mat_zero_int <- base_params$state_c_matrix
  c_mat_zero_int["with_drug", "Asymptomatic"] <- c_mat_zero_int["without_drug", "Asymptomatic"]
  
  compare_model_runs(
    extractor_fn = get_icer,
    comparison_fn = expect_lt,
    params_1 = list(state_c_matrix = c_mat_zero_int),
    params_2 = list(), 
    data = base_params,
    label = "T08: Intervention costs = 0 reduces ICER"
  )
  
  # T09: Increase intervention costs. ICER is increased
  c_mat_high_int <- base_params$state_c_matrix
  c_mat_high_int["with_drug", "Asymptomatic"] <- c_mat_high_int["without_drug", "Asymptomatic"] + 10000
  
  compare_model_runs(
    extractor_fn = get_icer,
    comparison_fn = expect_gt,
    params_1 = list(state_c_matrix = c_mat_high_int),
    params_2 = list(),
    data = base_params,
    label = "T09: Increasing intervention costs increases ICER"
  )
  
  # T10: Costs with standard discount < undiscounted costs
  compare_model_runs(
    extractor_fn = get_costs,
    comparison_fn = expect_lt,
    params_1 = list(discount_rate = 0.035),
    params_2 = list(discount_rate = 0),
    data = base_params,
    label = "T10: Discounted less than undiscounted costs"
  )
  
  # T11: High cost discount rate reduces totals to cycle 0
  res_cycle_zero <- run_model(base_params, n_cycles = 1)
  check_model_costs(
    data = base_params,
    discount_rate = 1000,
    expected_costs = get_costs(res_cycle_zero),
    tolerance = 0.01,
    label = "T11: High discount total costs equal cycle 0 costs"
  )
})

test_that("Population calculations", {
  # T01: Set relative treatment effects = 1
  no_effect_p_matrix <- base_params$p_matrix
  no_effect_p_matrix[, , "with_drug"] <- no_effect_p_matrix[, , "without_drug"]
  res_no_effect <- run_model(base_params, p_matrix = no_effect_p_matrix)
  
  expect_equal(
    unname(get_qalys(res_no_effect)["with_drug"]),
    unname(get_qalys(res_no_effect)["without_drug"]),
    label = "T01: QALYs must be equal when relative treatment effect is 1"
  )
  
  expect_equal(
    unname(get_le(res_no_effect)["with_drug"]),
    unname(get_le(res_no_effect)["without_drug"]),
    label = "T01: LEs must be equal when relative treatment effect is 1"
  )
  
  # T02: If all transition probabilities to death are 0, LE is n_cycles
  n_cycles_test <- 50
  no_death_p_matrix <- base_params$p_matrix
  no_death_p_matrix[, "Dead", ] <- 0
  no_death_p_matrix["Dead", "Dead", ] <- 1
  
  check_model_le_pp(
    data = base_params,
    p_matrix = no_death_p_matrix,
    n_cycles = n_cycles_test,
    expected_le = n_cycles_test,
    label = "T02: LE should be n_cycles when all p_death=0"
  )
  
  # T03: If all transition probabilities to death are 1, LE is 1 cycle
  # (Note: LE expectation depends on within-cycle correction implementation)
  dead_p_matrix <- base_params$p_matrix
  dead_p_matrix[] <- 0
  dead_p_matrix[, "Dead", ] <- 1
  
  check_model_le_pp(
    data = base_params,
    p_matrix = dead_p_matrix,
    expected_le = 1, 
    label = "T03: LE should be 1 when all p_death=1"
  )
})

test_that("Input structure calculations", {
  # T12: PSA beta samples remain within (0, 1)
  withr::with_seed(42, {
    psa_samples <- sample_psa_parameters(n_sim = 1000, base_params = base_params)
    beta_cols <- grep("^utility_", names(psa_samples), value = TRUE)

    for (col in beta_cols) {
      expect_true(
        all(psa_samples[[col]] > 0 & psa_samples[[col]] < 1),
        label = paste0("T12: beta-sampled '", col, "' must lie strictly in (0, 1)")
      )
    }
  })
})
