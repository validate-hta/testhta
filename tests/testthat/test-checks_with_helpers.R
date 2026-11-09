# Unit tests for cohort Markov model - Using validation helpers
# Aligned with the HTA Verification Registry (T01 - T12)

# Load baseline test data
data(test_data)

# --- QALY Validation Tests ---

test_that("T02: Undiscounted QALYs (with u=1) should equal LE", {
  test_run_t02 <- run_model(test_data, discount_rate = 0, u_healthy = 1, u_sick = 1)
  expect_equal(
    get_qalys(test_run_t02), 
    get_le(test_run_t02), 
    tolerance = 0.01,
    label = "T02: Undiscounted QALYs (with u=1) should equal LE"
  )
})

test_that("T06: Set all living health state utility parameters = 1 yields QALYs equal to LYGs", {
  test_run_t06 <- run_model(test_data, u_healthy = 1, u_sick = 1)
  expect_equal(
    get_qalys(test_run_t06), 
    test_run_t06$total_LYs, 
    tolerance = 0.01,
    label = "T06: QALY gains exactly equal LYGs when utilities = 1"
  )
})

test_that("T07: Discounted QALYs should be less than Undiscounted QALYs", {
  compare_model_runs(
    extractor_fn = get_qalys,
    comparison_fn = expect_lt,
    params_1 = list(discount_rate = 0.035),
    params_2 = list(discount_rate = 0),
    data = test_data,
    label = "T07: Discounted QALYs should be less than Undiscounted QALYs"
  )
})

test_that("T08: QALY gains after time 0 tend towards zero at high discount rates", {
  res_cycle_zero <- run_model(test_data, n_cycles = 1)
  check_model_qalys(
    data = test_data, 
    discount_rate = 1000, 
    expected_qalys = get_qalys(res_cycle_zero),
    label = "T08: QALYs with extreme discount_rate = 1000 equal cycle 0 QALYs"
  )
})


# --- Population Validation Tests ---

test_that("T03: Set relative treatment effects = 1 yields equal LYGs & QALYs", {
  test_run_t03 <- run_model(test_data, effect = 0)
  expect_equal(
    as.numeric(test_run_t03$total_LYs["with_drug"]), 
    as.numeric(test_run_t03$total_LYs["without_drug"]), 
    tolerance = 0.01,
    label = "T03: Equal LYGs for relative effect = 0"
  )
  expect_equal(
    as.numeric(test_run_t03$total_QALYs["with_drug"]), 
    as.numeric(test_run_t03$total_QALYs["without_drug"]), 
    tolerance = 0.01,
    label = "T03: Equal QALYs for relative effect = 0"
  )
})

test_that("T04: LE should be n_cycles when all p_death = 0", {
  n_cycles_test <- 50
  check_model_le(
    data = test_data,
    p_healthy_death = 0,
    p_sick_death = 0,
    n_cycles = n_cycles_test,
    expected_le = n_cycles_test,
    label = "T04: LE should be n_cycles when all p_death = 0"
  )
})

test_that("T05: LE should be 1 when all p_death = 1", {
  check_model_le(
    data = test_data,
    p_healthy_death = 1,
    p_sick_death = 1,
    expected_le = 1,
    label = "T05: LE should be 1 when all p_death = 1"
  )
})


# --- Cost Validation Tests ---

test_that("T09: Set intervention costs = 0 reduces ICER", {
  compare_model_runs(
    extractor_fn = get_icer,
    comparison_fn = expect_lt,
    params_1 = list(c_intervention = 0),
    params_2 = list(),
    data = test_data,
    label = "T09: Set intervention costs = 0 reduces ICER"
  )
})

test_that("T10: Increase intervention costs increases ICER", {
  compare_model_runs(
    extractor_fn = get_icer,
    comparison_fn = expect_gt,
    params_1 = list(c_intervention = 5000),
    params_2 = list(),
    data = test_data,
    label = "T10: Increase intervention costs increases ICER"
  )
})

test_that("T11: Cost discount rate = 0 yields discounted costs = undiscounted costs", {
  compare_model_runs(
    extractor_fn = get_costs,
    comparison_fn = expect_equal,
    params_1 = list(discount_rate = 0),
    params_2 = list(discount_rate = 0),
    data = test_data,
    label = "T11: Cost discount rate = 0 yields discounted costs = undiscounted costs"
  )
})

test_that("T12: Costs with extreme discount_rate = 1000 equal cycle 0 costs", {
  res_cycle_zero <- run_model(test_data, n_cycles = 1)
  check_model_costs(
    data = test_data, 
    discount_rate = 1000, 
    expected_costs = get_costs(res_cycle_zero),
    label = "T12: Costs with extreme discount_rate = 1000 equal cycle 0 costs"
  )
})


# --- Probabilistic Sensitivity Analysis (PSA) Validation Tests (T13) ---

test_that("T13 (PSA): Sampled parameters lie within valid statistical distribution bounds", {
  set.seed(123)
  n_samples <- 100
  u_samples <- stats::rbeta(n_samples, shape1 = 8, shape2 = 2)
  expect_true(all(u_samples >= 0 & u_samples <= 1), label = "T13: Beta utility samples in [0,1]")
  
  cost_samples <- stats::rlnorm(n_samples, meanlog = 5, sdlog = 0.5)
  expect_true(all(cost_samples > 0), label = "T13: Lognormal cost samples > 0")
})


# --- Treatment Arm & Symmetry Validation Tests (T14 - T16) ---

test_that("T14 (Treatment Arm): Equalizing arm parameters yields equal costs and QALYs across arms", {
  data_eq <- test_data |>
    set_costs("with_drug", get_state_costs(test_data, "without_drug")) |>
    set_utilities("with_drug", get_state_utilities(test_data, "without_drug")) |>
    set_p_matrix("with_drug", get_transition_matrix(test_data, "without_drug"))
  
  res_eq <- run_model(data_eq)
  
  expect_equal(
    as.numeric(get_incremental_costs(res_eq)),
    0,
    tolerance = 0.01,
    label = "T14: Incremental costs equal 0 when arms are identical"
  )
  expect_equal(
    as.numeric(get_incremental_qalys(res_eq)),
    0,
    tolerance = 0.01,
    label = "T14: Incremental QALYs equal 0 when arms are identical"
  )
})

test_that("T15 (Treatment Arm): Amending individual treatment arm parameter changes ICER", {
  u_with_drug <- get_state_utilities(test_data, "with_drug")
  u_with_drug["Progressive_disease"] <- 0.8
  
  compare_model_runs(
    extractor_fn = get_icer,
    comparison_fn = function(val1, val2, label) {
      expect_false(isTRUE(all.equal(val1, val2)), label = label)
    },
    params_1 = list(state_q_matrix = set_utilities(test_data, "with_drug", u_with_drug)$state_q_matrix),
    params_2 = list(),
    data = test_data,
    label = "T15: Amending individual arm parameter changes ICER"
  )
})

test_that("T16 (Treatment Arm): Swapping treatment arm parameters swaps QALYs and costs between arms", {
  arms <- get_arm_names(test_data)
  arm1 <- arms[1]
  arm2 <- arms[2]
  
  data_swapped <- test_data |>
    set_costs(arm1, get_state_costs(test_data, arm2)) |>
    set_costs(arm2, get_state_costs(test_data, arm1)) |>
    set_utilities(arm1, get_state_utilities(test_data, arm2)) |>
    set_utilities(arm2, get_state_utilities(test_data, arm1)) |>
    set_p_matrix(arm1, get_transition_matrix(test_data, arm2)) |>
    set_p_matrix(arm2, get_transition_matrix(test_data, arm1))
  
  res_base <- run_model(test_data)
  res_swapped <- run_model(data_swapped)
  
  expect_equal(
    as.numeric(get_costs(res_swapped)[arm1]),
    as.numeric(get_costs(res_base)[arm2]),
    tolerance = 0.01,
    label = "T16: Swapped costs arm 1 equals baseline arm 2"
  )
  expect_equal(
    as.numeric(get_costs(res_swapped)[arm2]),
    as.numeric(get_costs(res_base)[arm1]),
    tolerance = 0.01,
    label = "T16: Swapped costs arm 2 equals baseline arm 1"
  )
  expect_equal(
    as.numeric(get_qalys(res_swapped)[arm1]),
    as.numeric(get_qalys(res_base)[arm2]),
    tolerance = 0.01,
    label = "T16: Swapped QALYs arm 1 equals baseline arm 2"
  )
  expect_equal(
    as.numeric(get_qalys(res_swapped)[arm2]),
    as.numeric(get_qalys(res_base)[arm1]),
    tolerance = 0.01,
    label = "T16: Swapped QALYs arm 2 equals baseline arm 1"
  )
})
