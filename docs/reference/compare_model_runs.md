# Compare model outputs from two different parameter sets

Compare model outputs from two different parameter sets

## Usage

``` r
compare_model_runs(
  extractor_fn,
  comparison_fn,
  params_1,
  params_2,
  data,
  label = NULL
)
```

## Arguments

- extractor_fn:

  The function to get the result (e.g., `get_qalys`).

- comparison_fn:

  The `testthat` expectation function (e.g., `expect_lt`).

- params_1:

  List of parameters for the first
  [`run_model()`](https://validate-hta.github.io/testhta/reference/run_model.md)
  call.

- params_2:

  List of parameters for the second
  [`run_model()`](https://validate-hta.github.io/testhta/reference/run_model.md)
  call.

- data:

  The base dataset (passed as the first argument to `run_model`).

- label:

  A label for the test, passed to the comparison function.

## Value

None, called for side effects (`testthat` assertion).

## Examples

``` r
library(testthat)
data(base_params)
compare_model_runs(
  extractor_fn = get_qalys,
  comparison_fn = expect_lt,
  params_1 = list(discount_rate = 0.035),
  params_2 = list(discount_rate = 0),
  data = base_params
)
```
