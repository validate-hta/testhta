# Getter for incremental costs

Getter for incremental costs

## Usage

``` r
get_incremental_costs(res, arm1 = "without_drug", arm2 = "with_drug")
```

## Arguments

- res:

  A list of results returned by
  [`ce_markov()`](https://validate-hta.github.io/testhta/reference/ce_markov.md).

- arm1:

  Baseline treatment arm name or index (default: `"without_drug"`).

- arm2:

  Comparator treatment arm name or index (default: `"with_drug"`).

## Value

A numeric value of incremental cost (`arm2` minus `arm1`).

## Examples

``` r
data(base_params)
res <- run_model(base_params)
get_incremental_costs(res)
#> [1] 3718438
```
