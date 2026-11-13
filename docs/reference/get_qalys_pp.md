# Getter for per-person QALYs

Getter for per-person QALYs

## Usage

``` r
get_qalys_pp(res, arm = NULL)
```

## Arguments

- res:

  A list of results returned by
  [`ce_markov()`](https://validate-hta.github.io/testhta/reference/ce_markov.md).

- arm:

  Optional treatment arm name or index.

## Value

A numeric vector of per-person QALYs by treatment, or a single numeric
value if `arm` is specified.

## Examples

``` r
data(base_params)
res <- run_model(base_params)
get_qalys_pp(res)
#> without_drug    with_drug 
#>     8.394580     8.981496 
```
