# Run model and check QALYs against an expected value

Run model and check QALYs against an expected value

## Usage

``` r
check_model_qalys(data, expected_qalys, ..., tolerance = NULL, label = NULL)
```

## Arguments

- data:

  Baseline input data list.

- expected_qalys:

  The exact expected QALY value.

- ...:

  Arguments passed to
  [`run_model()`](https://validate-hta.github.io/testhta/reference/run_model.md)
  (e.g., `discount_rate`).

- tolerance:

  Approximate equality tolerance.

- label:

  A label for the test, passed to
  [`expect_equal()`](https://testthat.r-lib.org/reference/equality-expectations.html).

## Value

None, called for side effects (`testthat` assertion).

## Examples

``` r
data(base_params)
res_cycle_zero <- run_model(base_params, n_cycles = 1)
check_model_qalys(
  data = base_params,
  expected_qalys = get_qalys(res_cycle_zero),
  discount_rate = 1000,
  tolerance = 0.01
)
```
