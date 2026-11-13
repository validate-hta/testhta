# Getter for per-person life expectancy (LE)

Getter for per-person life expectancy (LE)

## Usage

``` r
get_le_pp(res, arm = NULL)
```

## Arguments

- res:

  A list of results returned by
  [`ce_markov()`](https://validate-hta.github.io/testhta/reference/ce_markov.md).

- arm:

  Optional treatment arm name or index.

## Value

A numeric vector of per-person life expectancy by treatment, or a single
numeric value if `arm` is specified.

## Examples

``` r
data(base_params)
res <- run_model(base_params)
get_le_pp(res)
#> without_drug    with_drug 
#>     12.06416     12.68332 
```
