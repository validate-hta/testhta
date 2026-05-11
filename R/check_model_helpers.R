# --- helpers ---

check_model_qalys <- function(test_data, discount_rate, expected_qalys) {
  # test_run <- 
  #   test_data |> 
  #   set_discount_rate(discount_rate) |>
  #   run_model()
  # # do.call(what = run_model, args = _)
  
  test_run <- run_model(test_data, discount_rate = discount_rate)
  expect_equal(get_qalys(test_run), expected_qalys)
}

# These functions wrap common testing patterns for the model.
# They assume the existence of:
# - `run_model(data, ...)`
# - `get_qalys(run)`
# - `get_costs(run)`
# - `get_le(run)`

#' ' Run model and check QALYs against an expected value
#'
#' @param expected_qalys The exact expected QALY value.
#' @param ... Arguments passed to `run_model()` (e.g., data, discount_rate).
#' @param label A label for the test, passed to `expect_equal()`.
check_model_qalys <- function(expected_qalys, ..., label = NULL) {
  run <- run_model(...)
  expect_equal(get_qalys(run), expected_qalys, label = label)
}

#' Run model and check Costs against an expected value
#'
#' @param expected_costs The exact expected Cost value.
#' @param ... Arguments passed to `run_model()`.
#' @param label A label for the test, passed to `expect_equal()`.
check_model_costs <- function(expected_costs, ..., label = NULL) {
  run <- run_model(...)
  expect_equal(get_costs(run), expected_costs, label = label)
}

#' Run model and check Life Expectancy against an expected value
#'
#' @param expected_le The exact expected LE value.
#' @param ... Arguments passed to `run_model()`.
#' @param label A label for the test, passed to `expect_equal()`.
check_model_le <- function(expected_le, ..., label = NULL) {
  run <- run_model(...)
  expect_equal(get_le(run), expected_le, label = label)
}

#' Compare model outputs from two different parameter sets
#'
#' @param extractor_fn The function to get the result (e.g., get_qalys).
#' @param comparison_fn The testthat expectation function (e.g., expect_lt).
#' @param params_1 List of parameters for the first `run_model()` call.
#' @param params_2 List of parameters for the second `run_model()` call.
#' @param data The base dataset (passed as the first argument to `run_model`).
#' @param label A label for the test, passed to the comparison function.
compare_model_runs <- function(extractor_fn, comparison_fn, 
                               params_1, params_2, data, label = NULL) {
  
  # Use do.call to run the model with the list of parameters
  # This ensures 'data' is the first argument, followed by items in the list.
  run_1_args <- c(list(data = data), params_1)
  run_1 <- do.call(run_model, run_1_args)
  output_1 <- extractor_fn(run_1)
  
  run_2_args <- c(list(data = data), params_2)
  run_2 <- do.call(run_model, run_2_args)
  output_2 <- extractor_fn(run_2)
  
  # Call the comparison function (e.g., expect_lt) with the two outputs
  comparison_fn(output_1, output_2, label = label)
}
