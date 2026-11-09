# getters

#' @title Getter for QALYs
#' @param res A list of results returned by ce_markov.
#' @param arm Optional treatment arm name or index.
#' @return A numeric vector of total QALYs by treatment, or a single numeric value if arm is specified.
#' @examples
#' data(test_data)
#' res <- run_model(test_data)
#' get_qalys(res)
#' get_qalys(res, "with_drug")
#' @export
get_qalys <- function(res, arm = NULL) {
  if (is.null(arm)) {
    res$total_QALYs
  } else {
    res$total_QALYs[arm]
  }
}

#' @title Getter for per-person QALYs
#' @param res A list of results returned by ce_markov.
#' @param arm Optional treatment arm name or index.
#' @return A numeric vector of per-person QALYs by treatment, or a single numeric value if arm is specified.
#' @export
get_qalys_pp <- function(res, arm = NULL) {
  if (is.null(arm)) {
    res$total_QALYs_pp
  } else {
    res$total_QALYs_pp[arm]
  }
}

#' @title Getter for costs
#' @param res A list of results returned by ce_markov.
#' @param arm Optional treatment arm name or index.
#' @return A numeric vector of total costs by treatment, or a single numeric value if arm is specified.
#' @examples
#' data(test_data)
#' res <- run_model(test_data)
#' get_costs(res)
#' get_costs(res, "with_drug")
#' @export 
get_costs <- function(res, arm = NULL) {
  if (is.null(arm)) {
    res$total_costs
  } else {
    res$total_costs[arm]
  }
}

#' @title Getter for per-person costs
#' @param res A list of results returned by ce_markov.
#' @param arm Optional treatment arm name or index.
#' @return A numeric vector of per-person costs by treatment, or a single numeric value if arm is specified.
#' @export
get_costs_pp <- function(res, arm = NULL) {
  if (is.null(arm)) {
    res$total_costs_pp
  } else {
    res$total_costs_pp[arm]
  }
}

#' @title Getter for life expectancy (LE)
#' @param res A list of results returned by ce_markov.
#' @param arm Optional treatment arm name or index.
#' @return A numeric vector of total life expectancy by treatment, or a single numeric value if arm is specified.
#' @examples
#' data(test_data)
#' res <- run_model(test_data)
#' get_le(res)
#' get_le(res, "with_drug")
#' @export
get_le <- function(res, arm = NULL) {
  if (is.null(arm)) {
    res$total_LE
  } else {
    res$total_LE[arm]
  }
}

#' @title Getter for per-person life expectancy (LE)
#' @param res A list of results returned by ce_markov.
#' @param arm Optional treatment arm name or index.
#' @return A numeric vector of per-person life expectancy by treatment, or a single numeric value if arm is specified.
#' @export
get_le_pp <- function(res, arm = NULL) {
  if (is.null(arm)) {
    res$total_LE_pp
  } else {
    res$total_LE_pp[arm]
  }
}

#' @title Getter for ICER
#' @param res A list of results returned by ce_markov.
#' @param arm1 Baseline treatment arm name or index (default: "without_drug").
#' @param arm2 Comparator treatment arm name or index (default: "with_drug").
#' @return A numeric value representing the incremental cost-effectiveness ratio (ICER).
#' @examples
#' data(test_data)
#' res <- run_model(test_data)
#' get_icer(res)
#' @export
get_icer <- function(res, arm1 = "without_drug", arm2 = "with_drug") {
  c_incr <- get_incremental_costs(res, arm1 = arm1, arm2 = arm2)
  q_incr <- get_incremental_qalys(res, arm1 = arm1, arm2 = arm2)
  as.numeric(c_incr / q_incr)
}

#' @title Getter for incremental costs
#' @param res A list of results returned by ce_markov.
#' @param arm1 Baseline treatment arm name or index (default: "without_drug").
#' @param arm2 Comparator treatment arm name or index (default: "with_drug").
#' @return A numeric value of incremental cost (arm 2 minus arm 1).
#' @examples
#' data(test_data)
#' res <- run_model(test_data)
#' get_incremental_costs(res)
#' @export
get_incremental_costs <- function(res, arm1 = "without_drug", arm2 = "with_drug") {
  costs <- get_costs(res)
  as.numeric(costs[arm2] - costs[arm1])
}

#' @title Getter for incremental QALYs
#' @param res A list of results returned by ce_markov.
#' @param arm1 Baseline treatment arm name or index (default: "without_drug").
#' @param arm2 Comparator treatment arm name or index (default: "with_drug").
#' @return A numeric value of incremental QALYs (arm 2 minus arm 1).
#' @examples
#' data(test_data)
#' res <- run_model(test_data)
#' get_incremental_qalys(res)
#' @export
get_incremental_qalys <- function(res, arm1 = "without_drug", arm2 = "with_drug") {
  qalys <- get_qalys(res)
  as.numeric(qalys[arm2] - qalys[arm1])
}


#' @title Getter for treatment arm names
#' @param input A list of parameters or model results.
#' @return A character vector of treatment arm names.
#' @examples
#' data(test_data)
#' get_arm_names(test_data)
#' @export
get_arm_names <- function(input) {
  if (!is.null(input$t_names)) {
    return(input$t_names)
  } else if (!is.null(input$total_costs)) {
    return(names(input$total_costs))
  } else {
    stop("Treatment arm names not found in input.")
  }
}

#' @title Getter for state costs
#' @param input A list of model parameters.
#' @param arm Optional treatment arm name (character) or index.
#' @return A vector of state costs for the specified arm, or the full cost matrix if arm is NULL.
#' @examples
#' data(test_data)
#' get_state_costs(test_data, "without_drug")
#' @export
get_state_costs <- function(input, arm = NULL) {
  if (is.null(arm)) {
    input$state_c_matrix
  } else {
    input$state_c_matrix[arm, ]
  }
}

#' @title Getter for state utilities
#' @param input A list of model parameters.
#' @param arm Optional treatment arm name (character) or index.
#' @return A vector of state utilities for the specified arm, or the full utility matrix if arm is NULL.
#' @examples
#' data(test_data)
#' get_state_utilities(test_data, "without_drug")
#' @export
get_state_utilities <- function(input, arm = NULL) {
  if (is.null(arm)) {
    input$state_q_matrix
  } else {
    input$state_q_matrix[arm, ]
  }
}

#' @title Getter for transition probability matrix
#' @param input A list of model parameters.
#' @param arm Optional treatment arm name (character) or index.
#' @return A matrix of transition probabilities for the specified arm, or the 3D array if arm is NULL.
#' @examples
#' data(test_data)
#' get_transition_matrix(test_data, "without_drug")
#' @export
get_transition_matrix <- function(input, arm = NULL) {
  if (is.null(arm)) {
    input$p_matrix
  } else {
    input$p_matrix[, , arm]
  }
}
