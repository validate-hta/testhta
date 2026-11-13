# Getter for ICER

Getter for ICER

## Usage

``` r
get_icer(res, arm1 = "without_drug", arm2 = "with_drug")
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

A numeric value representing the incremental cost-effectiveness ratio
(ICER).

## Examples

``` r
data(base_params)
res <- run_model(base_params)
get_icer(res)
#> [1] 6335.546
```
