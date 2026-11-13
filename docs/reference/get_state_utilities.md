# Getter for state utilities

Getter for state utilities

## Usage

``` r
get_state_utilities(input, arm = NULL)
```

## Arguments

- input:

  A list of model parameters.

- arm:

  Optional treatment arm name (character) or index.

## Value

A vector of state utilities for the specified arm, or the full utility
matrix if `arm` is `NULL`.

## Examples

``` r
data(base_params)
get_state_utilities(base_params, "without_drug")
#> Asymptomatic  Progressive         Dead 
#>          0.9          0.6          0.0 
```
