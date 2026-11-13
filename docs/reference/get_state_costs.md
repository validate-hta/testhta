# Getter for state costs

Getter for state costs

## Usage

``` r
get_state_costs(input, arm = NULL)
```

## Arguments

- input:

  A list of model parameters.

- arm:

  Optional treatment arm name (character) or index.

## Value

A vector of state costs for the specified arm, or the full cost matrix
if `arm` is `NULL`.

## Examples

``` r
data(base_params)
get_state_costs(base_params, "without_drug")
#> Asymptomatic  Progressive         Dead 
#>          100          200            0 
```
