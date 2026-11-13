# Set costs for a scenario

Set costs for a scenario

## Usage

``` r
set_costs(input, scenario, values)
```

## Arguments

- input:

  A list of model parameters.

- scenario:

  The scenario name (character) or index (numeric).

- values:

  A vector of cost values for health states.

## Value

The modified list of parameters.

## Examples

``` r
data(base_params)
updated <- set_costs(base_params, "without_drug", c(100, 200, 0))
```
