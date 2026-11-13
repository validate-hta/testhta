# Run Markov model with parameters and overrides

Run Markov model with parameters and overrides

## Usage

``` r
run_model(data, ...)
```

## Arguments

- data:

  A list of base parameters (e.g., `base_params`).

- ...:

  Overrides for parameters passed to
  [`ce_markov()`](https://validate-hta.github.io/testhta/reference/ce_markov.md).

## Value

A list of model simulation results.

## Examples

``` r
data(base_params)
res <- run_model(base_params, discount_rate = 0.05)
```
