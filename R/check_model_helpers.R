#' Run Markov model with parameters and overrides
#' 
#' @param data A list of base parameters.
#' @param ... Overrides for parameters.
#' @importFrom testthat expect_equal
#' @importFrom stats setNames
#' @return A list of model simulation results.
#' @examples
#' data(test_data)
#' res <- run_model(test_data, discount_rate = 0.05)
#' @export
run_model <- function(data, ...) {
  updates <- list(...)
  args_list <- utils::modifyList(data, updates)
  do.call(ce_markov, args_list)
}

#' Run model and check QALYs against an expected value
#'
#' @param data Baseline input data list.
#' @param expected_qalys The exact expected QALY value.
#' @param ... Arguments passed to `run_model()` (e.g., discount_rate).
#' @param tolerance Approximate equality tolerance.
#' @param label A label for the test, passed to `expect_equal()`.
#' @return None, called for side effects (testthat assertion).
#' @export
check_model_qalys <- function(data, expected_qalys, ..., tolerance = NULL, label = NULL) {
  run <- run_model(data, ...)
  actual <- get_qalys(run)
  if (length(expected_qalys) == 1) {
    expected <- setNames(rep(expected_qalys, length(actual)), names(actual))
  } else {
    expected <- expected_qalys
  }
  expect_equal(actual, expected, tolerance = tolerance, label = label)
}

#' Run model and check Costs against an expected value
#'
#' @param data Baseline input data list.
#' @param expected_costs The exact expected Cost value.
#' @param ... Arguments passed to `run_model()`.
#' @param tolerance Approximate equality tolerance.
#' @param label A label for the test, passed to `expect_equal()`.
#' @return None, called for side effects (testthat assertion).
#' @export
check_model_costs <- function(data, expected_costs, ..., tolerance = NULL, label = NULL) {
  run <- run_model(data, ...)
  actual <- get_costs(run)
  if (length(expected_costs) == 1) {
    expected <- setNames(rep(expected_costs, length(actual)), names(actual))
  } else {
    expected <- expected_costs
  }
  expect_equal(actual, expected, tolerance = tolerance, label = label)
}

#' Run model and check Life Expectancy against an expected value
#'
#' @param data Baseline input data list.
#' @param expected_le The exact expected LE value.
#' @param ... Arguments passed to `run_model()`.
#' @param label A label for the test, passed to `expect_equal()`.
#' @return None, called for side effects (testthat assertion).
#' @export
check_model_le <- function(data, expected_le, ..., label = NULL) {
  run <- run_model(data, ...)
  actual <- get_le(run)
  if (length(expected_le) == 1) {
    expected <- setNames(rep(expected_le, length(actual)), names(actual))
  } else {
    expected <- expected_le
  }
  expect_equal(actual, expected, label = label)
}

#' Run model and check per-person Life Expectancy against an expected value
#'
#' @param data Baseline input data list.
#' @param expected_le The exact expected per-person LE value.
#' @param ... Arguments passed to `run_model()`.
#' @param label A label for the test, passed to `expect_equal()`.
#' @return None, called for side effects (testthat assertion).
#' @export
check_model_le_pp <- function(data, expected_le, ..., label = NULL) {
  run <- run_model(data, ...)
  actual <- get_le_pp(run)
  if (length(expected_le) == 1) {
    expected <- setNames(rep(expected_le, length(actual)), names(actual))
  } else {
    expected <- expected_le
  }
  expect_equal(actual, expected, label = label)
}

#' Compare model outputs from two different parameter sets
#'
#' @param extractor_fn The function to get the result (e.g., get_qalys).
#' @param comparison_fn The testthat expectation function (e.g., expect_lt).
#' @param params_1 List of parameters for the first `run_model()` call.
#' @param params_2 List of parameters for the second `run_model()` call.
#' @param data The base dataset (passed as the first argument to `run_model`).
#' @param label A label for the test, passed to the comparison function.
#' @return None, called for side effects (testthat assertion).
#' @export
compare_model_runs <- function(extractor_fn, comparison_fn, 
                               params_1, params_2, data, label = NULL) {
  
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
