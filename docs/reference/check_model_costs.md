# Run model and check Costs against an expected value

Run model and check Costs against an expected value

## Usage

``` r
check_model_costs(expected_costs, ..., label = NULL)
```

## Arguments

- expected_costs:

  The exact expected Cost value.

- ...:

  Arguments passed to
  [`run_model()`](https://n8thangreen.github.io/testhta/reference/run_model.md).

- label:

  A label for the test, passed to
  [`expect_equal()`](https://testthat.r-lib.org/reference/equality-expectations.html).
