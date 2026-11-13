# Getter for life expectancy (LE)

Getter for life expectancy (LE)

## Usage

``` r
get_le(res, arm = NULL)
```

## Arguments

- res:

  A list of results returned by
  [`ce_markov()`](https://validate-hta.github.io/testhta/reference/ce_markov.md).

- arm:

  Optional treatment arm name or index.

## Value

A numeric vector of total life expectancy by treatment, or a single
numeric value if `arm` is specified.

## Examples

``` r
data(base_params)
res <- run_model(base_params)
get_le(res)
#> without_drug    with_drug 
#>     12064.16     12683.32 
get_le(res, "with_drug")
#> with_drug 
#>  12683.32 
```
