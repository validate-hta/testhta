#' Run Markov model with parameters and overrides
#' 
#' @param data A list of base parameters.
#' @param ... Overrides for parameters or helper arguments.
#' @importFrom testthat expect_equal
#' @return The model results.
#' @export
run_model <- function(data, ...) {
  updates <- list(...)
  
  # Map helper arguments to standard matrix overrides
  
  # 1. Utilities (u_healthy, u_sick)
  if (any(c("u_healthy", "u_sick") %in% names(updates))) {
    state_q_matrix <- data$state_q_matrix
    if ("u_healthy" %in% names(updates)) {
      state_q_matrix[, "Asymptomatic_disease"] <- updates$u_healthy
      updates$u_healthy <- NULL
    }
    if ("u_sick" %in% names(updates)) {
      state_q_matrix[, "Progressive_disease"] <- updates$u_sick
      updates$u_sick <- NULL
    }
    updates$state_q_matrix <- state_q_matrix
  }
  
  # 2. Costs (c_healthy, c_sick, c_intervention, c_death)
  if (any(c("c_healthy", "c_sick", "c_intervention", "c_death") %in% names(updates))) {
    state_c_matrix <- data$state_c_matrix
    trans_c_matrix <- data$trans_c_matrix
    
    # Extract baseline or override values
    c_h <- if ("c_healthy" %in% names(updates)) updates$c_healthy else state_c_matrix["without_drug", "Asymptomatic_disease"]
    c_s <- if ("c_sick" %in% names(updates)) updates$c_sick else state_c_matrix["without_drug", "Progressive_disease"]
    c_int <- if ("c_intervention" %in% names(updates)) updates$c_intervention else (state_c_matrix["with_drug", "Asymptomatic_disease"] - state_c_matrix["without_drug", "Asymptomatic_disease"])
    c_d <- if ("c_death" %in% names(updates)) updates$c_death else trans_c_matrix["Progressive_disease", "Dead"]
    
    # Set them
    state_c_matrix["without_drug", "Asymptomatic_disease"] <- c_h
    state_c_matrix["with_drug", "Asymptomatic_disease"] <- c_h + c_int
    state_c_matrix[, "Progressive_disease"] <- c_s
    trans_c_matrix["Progressive_disease", "Dead"] <- c_d
    
    updates$state_c_matrix <- state_c_matrix
    updates$trans_c_matrix <- trans_c_matrix
    
    # Clean up helper keys
    updates$c_healthy <- NULL
    updates$c_sick <- NULL
    updates$c_intervention <- NULL
    updates$c_death <- NULL
  }
  
  # Merge with modifyList
  args_list <- utils::modifyList(data, updates)

  
  # Call ce_markov
  do.call(ce_markov, args_list)
}

#' Run model and check QALYs against an expected value
#'
#' @param expected_qalys The exact expected QALY value.
#' @param ... Arguments passed to `run_model()` (e.g., data, discount_rate).
#' @param label A label for the test, passed to `expect_equal()`.
#' @export
check_model_qalys <- function(expected_qalys, ..., label = NULL) {
  run <- run_model(...)
  actual <- get_qalys(run)
  if (length(expected_qalys) == 1) {
    expected <- rep(expected_qalys, length(actual))
  } else {
    expected <- expected_qalys
  }
  expect_equal(as.numeric(actual), as.numeric(expected), label = label)
}

#' Run model and check Costs against an expected value
#'
#' @param expected_costs The exact expected Cost value.
#' @param ... Arguments passed to `run_model()`.
#' @param label A label for the test, passed to `expect_equal()`.
#' @export
check_model_costs <- function(expected_costs, ..., label = NULL) {
  run <- run_model(...)
  actual <- get_costs(run)
  if (length(expected_costs) == 1) {
    expected <- rep(expected_costs, length(actual))
  } else {
    expected <- expected_costs
  }
  expect_equal(as.numeric(actual), as.numeric(expected), label = label)
}

#' Run model and check Life Expectancy against an expected value
#'
#' @param expected_le The exact expected LE value.
#' @param ... Arguments passed to `run_model()`.
#' @param label A label for the test, passed to `expect_equal()`.
#' @export
check_model_le <- function(expected_le, ..., label = NULL) {
  run <- run_model(...)
  actual <- get_le(run)
  if (length(expected_le) == 1) {
    expected <- rep(expected_le, length(actual))
  } else {
    expected <- expected_le
  }
  expect_equal(as.numeric(actual), as.numeric(expected), label = label)
}

#' Compare model outputs from two different parameter sets
#'
#' @param extractor_fn The function to get the result (e.g., get_qalys).
#' @param comparison_fn The testthat expectation function (e.g., expect_lt).
#' @param params_1 List of parameters for the first `run_model()` call.
#' @param params_2 List of parameters for the second `run_model()` call.
#' @param data The base dataset (passed as the first argument to `run_model`).
#' @param label A label for the test, passed to the comparison function.
#' @export
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
  
  # Call the comparison function (e.g., expect_lt) with the two outputs element-wise
  for (idx in seq_along(output_1)) {
    comparison_fn(output_1[[idx]], output_2[[idx]], label = label)
  }
}

