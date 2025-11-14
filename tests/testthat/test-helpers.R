# helpers

check_model_qalys <- function(test_data, discount_rate, expected_qalys) {
  # test_run <- 
  #   test_data |> 
  #   set_discount_rate(discount_rate) |>
  #   run_model()
  # # do.call(what = run_model, args = _)
  
  test_run <- run_model(test_data, discount_rate = discount_rate)
  expect_equal(get_qalys(test_run), expected_qalys)
}
