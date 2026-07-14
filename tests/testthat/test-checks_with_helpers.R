# Unit tests for cohort Markov model - Using validation helpers
# Aligned with the HTA Verification Registry (T01 - T12)

# Load baseline test data
data(test_data)

# --- QALY Validation Tests ---

test_that("T01: QALYs with discount_rate = 1 should be 0", {
  check_model_qalys(
    data = test_data, 
    discount_rate = 1, 
    expected_qalys = 0,
    label = "T01: QALYs with discount_rate = 1 should be 0"
  )
})

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
  check_model_qalys(
    data = test_data, 
    discount_rate = 1000, 
    expected_qalys = 0,
    label = "T08: QALYs with extreme discount_rate = 1000 should be 0"
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

test_that("T12: Costs with extreme discount_rate = 1000 should be 0", {
  check_model_costs(
    data = test_data, 
    discount_rate = 1000, 
    expected_costs = 0,
    label = "T12: Costs with extreme discount_rate = 1000 should be 0"
  )
})
