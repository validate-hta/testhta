# Unit tests for cohort Markov model - Standard testthat expectations
# Aligned with the HTA Verification Registry (T01 - T12) in the tutorial paper

data(base_params)

test_that("T06: Discounted QALYs are lower than undiscounted QALYs", {
  # run model with standard discounting (3.5%)
  results_discounted <- with(
    base_params,
    ce_markov(
      start_pop,
      p_matrix,
      state_c_matrix,
      state_q_matrix,
      n_cycles,
      discount_rate = 0.035
    )
  )

  # run model with NO discounting (0%)
  results_undiscounted <- with(
    base_params,
    ce_markov(
      start_pop,
      p_matrix,
      state_c_matrix,
      state_q_matrix,
      n_cycles,
      discount_rate = 0.0
    )
  )

  qaly_discounted <- get_qalys(results_discounted)
  qaly_undiscounted <- get_qalys(results_undiscounted)

  expect_lt(
    qaly_discounted["without_drug"],
    qaly_undiscounted["without_drug"]
  )
  expect_lt(
    qaly_discounted["with_drug"],
    qaly_undiscounted["with_drug"]
  )
})

test_that("T07 & T11: High discounting reduces future value to 0", {
  res_high_disc <- run_model(base_params, discount_rate = 1000)
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
  run_with_intervention_cost <- function(c_int) {
    temp_params <- base_params
    temp_params$state_c_matrix["with_drug", "Asymptomatic"] <-
      temp_params$state_c_matrix["without_drug", "Asymptomatic"] + c_int
    run_model(temp_params)
  }

  res_base <- run_model(base_params)
  res_no_int <- run_with_intervention_cost(c_int = 0)

  res_no_int_icer <- get_icer(res_no_int)
  res_base_icer <- get_icer(res_base)

  base_qalys <- get_qalys(res_base)
  res_base_ie <- unname(
    base_qalys["with_drug"] - base_qalys["without_drug"]
  )

  testthat::skip_if_not(
    res_base_ie > 0,
    "Baseline incremental QALYs are <= 0. Skipping ICER directionality tests."
  )

  expect_lt(res_no_int_icer, res_base_icer)
})

test_that("T03: Immediate mortality results in LE of 1", {
  dead_p_matrix <- base_params$p_matrix
  dead_p_matrix[] <- 0
  dead_p_matrix[, "Dead", ] <- 1

  res_death <- run_model(base_params, p_matrix = dead_p_matrix)
  res_le <- get_le_pp(res_death)

  expect_equal(unname(res_le), rep(1, length(res_le)))
})
