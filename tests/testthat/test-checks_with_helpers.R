# Unit tests for cohort Markov model - Using custom expectation helpers
# Aligned with the HTA Verification Registry (T01 - T12) in the tutorial paper

data(base_params)

test_that("QALY calculations", {
  u_one_matrix <- base_params$state_q_matrix
  u_one_matrix[, c("Asymptomatic", "Progressive")] <- 1

  # T04: Undiscounted QALYs (with u=1) should equal LE
  test_run_t04 <- run_model(
    base_params,
    discount_rate = 0,
    state_q_matrix = u_one_matrix
  )
  expect_equal(
    get_qalys(test_run_t04),
    get_le(test_run_t04),
    label = "T04: Undiscounted QALYs (with u=1) should equal LE"
  )

  # T05: QALY gains exactly equal LYGs when all utilities are 1
  test_run_t05 <- run_model(
    base_params,
    discount_rate = 0,
    state_q_matrix = u_one_matrix
  )
  expect_equal(
    get_qalys(test_run_t05)["with_drug"] -
      get_qalys(test_run_t05)["without_drug"],
    get_le(test_run_t05)["with_drug"] -
      get_le(test_run_t05)["without_drug"],
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
  base_res <- run_model(base_params)
  base_qalys <- get_qalys(base_res)
  inc_qalys <- unname(
    base_qalys["with_drug"] - base_qalys["without_drug"]
  )

  testthat::skip_if_not(
    inc_qalys > 0,
    "Baseline incremental QALYs are <= 0. Skipping ICER directionality tests."
  )

  # T08: Set intervention costs = 0. ICER is reduced
  c_mat_zero_int <- base_params$state_c_matrix
  c_mat_zero_int["with_drug", "Asymptomatic"] <-
    c_mat_zero_int["without_drug", "Asymptomatic"]

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
  c_mat_high_int["with_drug", "Asymptomatic"] <-
    c_mat_high_int["without_drug", "Asymptomatic"] + 10000

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
  t_names <- get_arm_names(base_params)

  # T01: Set relative treatment effects = 1
  no_effect_p_matrix <- base_params$p_matrix
  no_effect_p_matrix[, , "with_drug"] <-
    no_effect_p_matrix[, , "without_drug"]
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

  # Normalise all rows simultaneously
  no_death_p_matrix <- prop.table(no_death_p_matrix, margin = c(1, 3))

  no_death_p_matrix["Dead", , ] <- 0
  no_death_p_matrix["Dead", "Dead", ] <- 1

  no_death_p_matrix <- array(
    no_death_p_matrix,
    dim = dim(base_params$p_matrix),
    dimnames = dimnames(base_params$p_matrix)
  )

  check_model_le_pp(
    data = base_params,
    p_matrix = no_death_p_matrix,
    n_cycles = n_cycles_test,
    expected_le = setNames(c(n_cycles_test, n_cycles_test), t_names),
    label = "T02: LE should be n_cycles when all p_death=0"
  )

  # T03: If all transition probabilities to death are 1, LE is 1 cycle
  dead_p_matrix <- base_params$p_matrix
  dead_p_matrix[] <- 0
  dead_p_matrix[, "Dead", ] <- 1

  check_model_le_pp(
    data = base_params,
    p_matrix = dead_p_matrix,
    expected_le = setNames(c(1, 1), t_names),
    label = "T03: LE should be 1 when all p_death=1"
  )
})

test_that("Input structure calculations", {
  # T12: PSA beta samples remain within (0, 1)
  withr::with_seed(42, {
    psa_samples <- sample_psa_parameters(
      n_sim = 1000,
      base_params = base_params
    )
    beta_cols <- grep("^utility_", names(psa_samples), value = TRUE)

    for (col in beta_cols) {
      expect_true(
        all(psa_samples[[col]] > 0 & psa_samples[[col]] < 1),
        label = paste0(
          "T12: beta-sampled '",
          col,
          "' must lie strictly in (0, 1)"
        )
      )
    }
  })
})
