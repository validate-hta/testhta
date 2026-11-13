# Getter for costs

Getter for costs

## Usage

``` r
get_costs(res, arm = NULL)
```

## Arguments

- res:

  A list of results returned by
  [`ce_markov()`](https://validate-hta.github.io/testhta/reference/ce_markov.md).

- arm:

  Optional treatment arm name or index.

## Value

A numeric vector of total costs by treatment, or a single numeric value
if `arm` is specified.

## Examples

``` r
data(base_params)
res <- run_model(base_params)
get_costs(res)
#> without_drug    with_drug 
#>      1147099      4865536 
get_costs(res, "with_drug")
#> with_drug 
#>   4865536 
```
