# getters

#' @title Getter for QALYs
#' @export
get_qalys <- function(res) {
  res$total_QALYs
}

#' @title Getter for costs
#' @export 
get_costs <- function(res) {
  res$total_costs
}

#' @title Getter for life expectancy (LE)
#' @export
get_le <- function(res) {
  res$total_LE
}
