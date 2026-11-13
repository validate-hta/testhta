# Getter for per-person costs

Getter for per-person costs

## Usage

``` r
get_costs_pp(res, arm = NULL)
```

## Arguments

- res:

  A list of results returned by
  [`ce_markov()`](https://validate-hta.github.io/testhta/reference/ce_markov.md).

- arm:

  Optional treatment arm name or index.

## Value

A numeric vector of per-person costs by treatment, or a single numeric
value if `arm` is specified.

## Examples

``` r
data(base_params)
res <- run_model(base_params)
get_costs_pp(res)
#> without_drug    with_drug 
#>     1147.099     4865.536 
```
