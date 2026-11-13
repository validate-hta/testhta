#' Baseline parameters for the cohort Markov model case study
#'
#' A list containing the baseline input parameters for the 3-state
#' (`Asymptomatic`, `Progressive`, `Dead`) cohort Markov model comparing
#' `without_drug` and `with_drug`, as defined in the accompanying tutorial
#' paper.
#'
#' @format A list with 6 elements:
#' \describe{
#'   \item{start_pop}{Named numeric vector of initial population counts across
#'     the 3 health states (`Asymptomatic = 1000`, `Progressive = 0`,
#'     `Dead = 0`).}
#'   \item{p_matrix}{A 3 x 3 x 2 array of baseline transition probabilities
#'     for `without_drug` and `with_drug`.}
#'   \item{state_c_matrix}{A 2 x 3 matrix of state occupancy costs for each
#'     treatment scenario and health state.}
#'   \item{state_q_matrix}{A 2 x 3 matrix of health state utility weights for
#'     each treatment scenario and health state.}
#'   \item{n_cycles}{Time horizon in model cycles (`15`).}
#'   \item{discount_rate}{Annual discount rate for costs and QALYs (`0.035`).}
#' }
#' @examples
#' data(base_params)
#' str(base_params)
"base_params"

#' @rdname base_params
#' @usage data(test_data)
"test_data"
