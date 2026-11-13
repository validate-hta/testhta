# Run model and check per-person Life Expectancy against an expected value

Run model and check per-person Life Expectancy against an expected value

## Usage

``` r
check_model_le_pp(data, expected_le, ..., label = NULL)
```

## Arguments

- data:

  Baseline input data list.

- expected_le:

  The exact expected per-person LE value.

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
check_model_le_pp(
  data = base_params,
  expected_le = setNames(c(1, 1), c("without_drug", "with_drug")),
  p_matrix = dead_p_matrix
)
```
