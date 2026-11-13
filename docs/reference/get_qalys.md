# Getter for QALYs

Getter for QALYs

## Usage

``` r
get_qalys(res, arm = NULL)
```

## Arguments

- res:

  A list of results returned by
  [`ce_markov()`](https://validate-hta.github.io/testhta/reference/ce_markov.md).

- arm:

  Optional treatment arm name or index.

## Value

A numeric vector of total QALYs by treatment, or a single numeric value
if `arm` is specified.

## Examples

``` r
data(base_params)
res <- run_model(base_params)
get_qalys(res)
#> without_drug    with_drug 
#>     8394.580     8981.496 
get_qalys(res, "with_drug")
#> with_drug 
#>  8981.496 
```
