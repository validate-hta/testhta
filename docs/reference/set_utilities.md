# Set utilities for a scenario

Set utilities for a scenario

## Usage

``` r
set_utilities(input, scenario, values)
```

## Arguments

- input:

  A list of model parameters.

- scenario:

  The scenario name (character) or index (numeric).

- values:

  A vector of utility values for health states.

## Value

The modified list of parameters.

## Examples

``` r
data(base_params)
updated <- set_utilities(base_params, "without_drug", c(0.8, 0.5, 0))
```
