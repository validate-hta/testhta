
data(test_data)

# It assumes the existence of:
# - `run_model(data, ...)`: Your main model function.
# - `get_qalys(run)`: Extracts total QALYs from a model run.
# - `get_costs(run)`: Extracts total costs from a model run.
# - `get_le(run)`: Extracts total Life Expectancy from a model run.
# - `test_data`: A standard test dataset.

# --- 1. QALY Calculations ---

test_that("QALY calculations", {
  
  # T01: QALYs are 0 if discount rate is 1 (all future value is 0)
  check_model_qalys(data = test_data, discount_rate = 1, expected_qalys = 0,
                    label = "T01: QALYs with discount_rate = 1 should be 0")
  
  # T04: QALYs are 0 if all utilities are 0
  check_model_qalys(data = test_data, u_healthy = 0, u_sick = 0, expected_qalys = 0,
                    label = "T04: QALYs with all utilities = 0 should be 0")
  
  # T03: QALYs with standard discount < undiscounted QALYs
  compare_model_runs(
    extractor_fn = get_qalys,
    comparison_fn = expect_lt,
    params_1 = list(discount_rate = 0.035),
    params_2 = list(discount_rate = 0),
    data = test_data,
    label = "T03: Discounted QALYs should be less than Undiscounted QALYs"
  )
  
  # T02: Undiscounted QALYs (with u=1) should equal LE
  # This is a dynamic check (comparing two *different* outputs from the *same* run),
  # so it doesn't fit the helper patterns and is clearer to write manually.
  test_run_t02 <- run_model(test_data, discount_rate = 0, u_healthy = 1, u_sick = 1)
  expect_equal(get_qalys(test_run_t02), get_le(test_run_t02),
               label = "T02: Undiscounted QALYs (with u=1) should equal LE")
})


# --- 2. Cost Calculations ---

test_that("Cost calculations", {
  
  # T05: Costs with standard discount < undiscounted costs
  compare_model_runs(
    extractor_fn = get_costs,
    comparison_fn = expect_lt,
    params_1 = list(discount_rate = 0.035),
    params_2 = list(discount_rate = 0),
    data = test_data,
    label = "T05: Discounted Costs should be less than Undiscounted Costs"
  )
  
  # T06: If all costs are 0, total cost should be 0
  check_model_costs(
    data = test_data,
    c_healthy = 0,
    c_sick = 0,
    c_intervention = 0,
    c_death = 0,
    expected_costs = 0,
    label = "T06: Total cost should be 0 when all cost inputs are 0"
  )
  
  # T07: Full discount (rate = 1) < standard discount
  # (Note: Assumes non-zero costs after cycle 0)
  compare_model_runs(
    extractor_fn = get_costs,
    comparison_fn = expect_lt,
    params_1 = list(discount_rate = 1),
    params_2 = list(discount_rate = 0.035),
    data = test_data,
    label = "T07: Full discount (100%) Costs should be less than standard discount"
  )
})


# --- 3. Life Expectancy (LE) Calculations ---

test_that("Life Expectancy (LE) calculations", {
  
  # T08: LE should not be affected by discount rate
  compare_model_runs(
    extractor_fn = get_le,
    comparison_fn = expect_equal,
    params_1 = list(discount_rate = 0),
    params_2 = list(discount_rate = 0.05),
    data = test_data,
    label = "T08: LE should not be affected by discount rate"
  )
  
  # T09: If all transition probabilities to death are 1, LE is 1 cycle
  # (Assuming model starts in cycle 1 and everyone lives 1 cycle)
  check_model_le(
    data = test_data,
    p_healthy_death = 1,
    p_sick_death = 1,
    expected_le = 1,
    label = "T09: LE should be 1 when all p_death = 1"
  )
  
  # T10: If all transition probabilities to death are 0, LE is n_cycles
  n_cycles_test <- 50
  check_model_le(
    data = test_data,
    p_healthy_death = 0,
    p_sick_death = 0,
    n_cycles = n_cycles_test,
    expected_le = n_cycles_test,
    label = "T10: LE should be n_cycles when all p_death = 0"
  )
})
