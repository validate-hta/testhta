# Run model and check Life Expectancy against an expected value

Run model and check Life Expectancy against an expected value

## Usage

``` r
check_model_le(data, expected_le, ..., label = NULL)
```

## Arguments

- data:

  Baseline input data list.

- expected_le:

  The exact expected LE value.

- ...:

  Arguments passed to
  [`run_model()`](https://validate-hta.github.io/testhta/reference/run_model.md).

- label:

  A label for the test, passed to
  [`expect_equal()`](https://testthat.r-lib.org/reference/equality-expectations.html).

## Value

None, called for side effects (`testthat` assertion).

## Examples

``` r
data(base_params)
dead_p_matrix <- base_params$p_matrix
dead_p_matrix[] <- 0
dead_p_matrix[, "Dead", ] <- 1
check_model_le(
  data = base_params,
  expected_le = 1000,
  p_matrix = dead_p_matrix
)
```
