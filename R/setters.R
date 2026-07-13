#' Set discount rate
#'
#' @param input A list of model parameters.
#' @param discount_rate The discount rate to set (numeric).
#' @return The modified list of parameters.
#' @export
set_discount_rate <- function(input, discount_rate) {
  if (!is.list(input)) {
    stop("input must be a list")
  }
  if (!is.numeric(discount_rate)) {
    stop("discount_rate must be numeric")
  }
  input$discount_rate <- discount_rate
  input
}

#' Set costs for a scenario
#'
#' @param input A list of model parameters.
#' @param scenario The scenario name (character) or index (numeric).
#' @param values A vector of cost values for health states.
#' @return The modified list of parameters.
#' @export
set_costs <- function(input, scenario, values) {
  if (!is.list(input)) {
    stop("input must be a list")
  }
  input$state_c_matrix[scenario, ] <- values
  input
}

#' Set transition probabilities for a scenario
#'
#' @param input A list of model parameters.
#' @param scenario The scenario name (character) or index (numeric).
#' @param values A matrix of transition probabilities.
#' @return The modified list of parameters.
#' @export
set_p_matrix <- function(input, scenario, values) {
  if (!is.list(input)) {
    stop("input must be a list")
  }
  input$p_matrix[, , scenario] <- values
  input
}

#' Set utilities for a scenario
#'
#' @param input A list of model parameters.
#' @param scenario The scenario name (character) or index (numeric).
#' @param values A vector of utility values for health states.
#' @return The modified list of parameters.
#' @export
set_utilities <- function(input, scenario, values) {
  if (!is.list(input)) {
    stop("input must be a list")
  }
  input$state_q_matrix[scenario, ] <- values
  input
}

#' Set time horizon
#'
#' @param input A list of model parameters.
#' @param scenario The scenario name or index, or values if scenario is omitted.
#' @param values The number of cycles (numeric).
#' @return The modified list of parameters.
#' @export
set_time_horizon <- function(input, scenario, values) {
  if (!is.list(input)) {
    stop("input must be a list")
  }
  if (missing(values)) {
    input$n_cycles <- scenario
  } else {
    input$n_cycles <- values
  }
  input
}
