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
