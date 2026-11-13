# Set transition probabilities for a scenario

Set transition probabilities for a scenario

## Usage

``` r
set_p_matrix(input, scenario, values)
```

## Arguments

- input:

  A list of model parameters.

- scenario:

  The scenario name (character) or index (numeric).

- values:

  A matrix of transition probabilities.

## Value

The modified list of parameters.

## Examples

``` r
data(base_params)
mat <- base_params$p_matrix[, , "without_drug"]
updated <- set_p_matrix(base_params, "without_drug", mat)
```
