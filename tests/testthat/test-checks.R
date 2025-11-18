#

# load test data list
f_path <- test_path("testdata", "test_data.rda")
load(f_path)

# test run wrapper
run_model <- function(input, ...) {
  updates <- list(...)
  updated_input <- modifyList(input, updates)
  do.call(ce_markov, args = updated_input)
}

# --- 1. QALY Calculations ---

test_that("QALY calculations", {
  ##TODO: set the discount rate _before_ passing to the model
  # test_run_t01 <- 
  #   test_data |> 
  #   set_discount_rate(1) |>
  #   run_model()
  
  # T01: QALYs with full discount should be 0
  # (Assumes QALYs are gained *after* cycle 0)
  test_run_t01 <- run_model(test_data, discount_rate = 1e100)
  actual <- get_qalys(test_run_t01)
  expect_equal(actual, rep(0, length(actual)), tolerance = 1e-10, ignore_attr = TRUE)
  
  # T02: QALYs with no discount (rate = 0) should equal Life Expectancy
  # (This assumes the utility/QoL weight for all alive states is 1)
  test_run_t02 <- run_model(test_data, discount_rate = 0)
  expect_equal(get_qalys(test_run_t02), get_le(test_run_t02))
  
  # T03: QALYs with standard discount should be less than undiscounted QALYs
  run_discounted <- run_model(test_data, discount_rate = 0.035)
  run_undiscounted <- run_model(test_data, discount_rate = 0)
  expect_lt(get_qalys(run_discounted), get_qalys(run_undiscounted))
  
  # T04: If utility is 0, QALYs should be 0
  # (Assumes `run_model` can take parameter overrides)
  state_q_matrix_t04 <- test_data$state_q_matrix*0
  test_run_t04 <- run_model(test_data, state_q_matrix = state_q_matrix_t04)
  actual <- get_qalys(test_run_t04)
  expect_equal(actual, rep(0, length(actual)), ignore_attr = TRUE)
})

# --- 2. Cost Calculations ---

test_that("Cost calculations", {

    # T05: Costs with standard discount should be less than undiscounted costs
    run_discounted <- run_model(test_data, discount_rate = 0.035)
    run_undiscounted <- run_model(test_data, discount_rate = 0)
    expect_true(all(get_costs(run_discounted) < get_costs(run_undiscounted)))

    # T06: If all costs are 0, total cost should be 0
    # (Assumes `run_model` can take parameter overrides)
    state_c_matrix_t06 <- test_data$state_c_matrix*0
    trans_c_matrix_t06 <- test_data$trans_c_matrix*0
    test_run_t06 <- run_model(test_data, 
                              state_c_matrix = state_c_matrix_t06, 
                              trans_c_matrix = trans_c_matrix_t06)
    expect_equal(get_costs(test_run_t06), rep(0, length(actual)), ignore_attr = TRUE)

    # T07: Larger discount should be less than standard discount
    run_discounted <- run_model(test_data, discount_rate = 0.035)
    run_full_discount <- run_model(test_data, discount_rate = 1)
    expect_true(all(get_costs(run_full_discount) < get_costs(run_discounted)))
})


# --- 3. Life Expectancy (LE) Calculations ---

test_that("Life Expectancy (LE) calculations", {

    # T08: LE should not be affected by discount rate
    run_discount_00 <- run_model(test_data, discount_rate = 0)
    run_discount_05 <- run_model(test_data, discount_rate = 0.05)
    expect_equal(get_le(run_discount_00), get_le(run_discount_05))

    ##TODO: because it get changes by a transition prob function internally?

    # T09: If all transition probabilities to death are 1, LE is 1 cycle
    # (Assuming model starts in cycle 1 and everyone lives 1 cycle)
    p_matrix_t09 <- test_data$p_matrix*0
    p_matrix_t09[, "Dead", ] <- 1
    test_run_t09 <- run_model(test_data, p_matrix = p_matrix_t09)
    expect_equal(get_le(test_run_t09), 1)

    # T10: If all transition probabilities to death are 0, LE is n_cycles
    # (Assuming `n_cycles` is an argument or in `test_data`)
    n_cycles_test <- 50
    p_matrix_t10 <- test_data$p_matrix
    p_matrix_t10[, "Dead", ] <- 0
    test_run_t10 <- run_model(test_data,
                              p_matrix = p_matrix_t10,
                              n_cycles = n_cycles_test)
    expect_equal(get_le(test_run_t10), n_cycles_test)
})
