# Run model and check QALYs against an expected value

Run model and check QALYs against an expected value

## Usage

``` r
check_model_qalys(expected_qalys, ..., label = NULL)
```

## Arguments

- expected_qalys:

  The exact expected QALY value.

- ...:

  Arguments passed to
  [`run_model()`](https://n8thangreen.github.io/testhta/reference/run_model.md)
  (e.g., data, discount_rate).

- label:

  A label for the test, passed to
  [`expect_equal()`](https://testthat.r-lib.org/reference/equality-expectations.html).
