# see test_case_example.xls ----

library(testthat)

data(test_data)

test_that("QALY calcs", {

	# T01
	test_run <- run_model(test_data, discount = 1)
	expect_equal(get_qalys(test_run), 0)

	# T02
	test_run <- run_model(test_data, discount = 0)
	expect_equal(get_qalys(test_run),
		     get_le(test_run))
})

# It assumes the existence of:
# - `run_model(data, ...)`: Your main model function.
# - `get_qalys(run)`: Extracts total QALYs from a model run.
# - `get_costs(run)`: Extracts total costs from a model run.
# - `get_le(run)`: Extracts total Life Expectancy from a model run.
# - `test_data`: A standard test dataset.

# --- 1. QALY Calculations ---

test_that("QALY calculations", {

	# T01: QALYs with full discount (rate = 1) should be 0
	# (Assumes QALYs are gained *after* cycle 0)
	test_run_t01 <- run_model(test_data, discount_rate = 1)
	expect_equal(get_qalys(test_run_t01), 0)

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
    test_run_t04 <- run_model(test_data, u_healthy = 0, u_sick = 0)
    expect_equal(get_qalys(test_run_t04), 0)
})

# --- 2. Cost Calculations ---

test_that("Cost calculations", {

    # T05: Costs with standard discount should be less than undiscounted costs
    run_discounted <- run_model(test_data, discount_rate = 0.035)
    run_undiscounted <- run_model(test_data, discount_rate = 0)
    expect_lt(get_costs(run_discounted), get_costs(run_undiscounted))

    # T06: If all costs are 0, total cost should be 0
    # (Assumes `run_model` can take parameter overrides)
    test_run_t06 <- run_model(test_data,
                              c_healthy = 0,
                              c_sick = 0,
                              c_intervention = 0,
                              c_death = 0)
    expect_equal(get_costs(test_run_t06), 0)

    # T07: Full discount (rate = 1) should be less than standard discount
    # (Will not be 0 if there are costs in cycle 0)
    run_discounted <- run_model(test_data, discount_rate = 0.035)
    run_full_discount <- run_model(test_data, discount_rate = 1)
    expect_lt(get_costs(run_full_discount), get_costs(run_discounted))
})


# --- 3. Life Expectancy (LE) Calculations ---

test_that("Life Expectancy (LE) calculations", {

    # T08: LE should not be affected by discount rate
    run_discount_00 <- run_model(test_data, discount_rate = 0)
    run_discount_05 <- run_model(test_data, discount_rate = 0.05)
    expect_equal(get_le(run_discount_00), get_le(run_discount_05))

    # T09: If all transition probabilities to death are 1, LE is 1 cycle
    # (Assuming model starts in cycle 1 and everyone lives 1 cycle)
    test_run_t09 <- run_model(test_data, p_healthy_death = 1, p_sick_death = 1)
    expect_equal(get_le(test_run_t09), 1)

    # T10: If all transition probabilities to death are 0, LE is n_cycles
    # (Assuming `n_cycles` is an argument or in `test_data`)
    n_cycles_test <- 50
    test_run_t10 <- run_model(test_data,
                              p_healthy_death = 0,
                              p_sick_death = 0,
                              n_cycles = n_cycles_test)
    expect_equal(get_le(test_run_t10), n_cycles_test)
})

# --- 4. Using Helpers (from test-helpers.R) ---

# This block shows how you could use the `check_model_qalys` function
# from your `test-helpers.R` file for simple, fixed-value checks.

test_that("QALY calculations (using helper)", {

    # T01 (Helper version)
    # This is much cleaner
    check_model_qalys(data = test_data, discount_rate = 1, expected_qalys = 0)

    # T04 (Helper version)
    # We can't use the helper if we need to modify parameters *inside* the
    # `run_model` call, unless the helper is updated to pass `...`
    # to `run_model`.
    # For now, we'd use the manual version:
    test_run_t04 <- run_model(test_data, u_healthy = 0, u_sick = 0)
    expect_equal(get_qalys(test_run_t04), 0)

    # T02 (Manual version)
    # The helper `check_model_qalys` is for checking against a *fixed*
    # number. For dynamic checks (comparing two model outputs),
    # we still write the test manually.
    test_run_t02 <- run_model(test_data, discount_rate = 0)
    expect_equal(get_qalys(test_run_t02), get_le(test_run_t02))
})

