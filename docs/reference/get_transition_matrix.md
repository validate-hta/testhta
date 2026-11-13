# Getter for transition probability matrix

Getter for transition probability matrix

## Usage

``` r
get_transition_matrix(input, arm = NULL)
```

## Arguments

- input:

  A list of model parameters.

- arm:

  Optional treatment arm name (character) or index.

## Value

A matrix of transition probabilities for the specified arm, or the 3D
array if `arm` is `NULL`.

## Examples

``` r
data(base_params)
get_transition_matrix(base_params, "without_drug")
#>              Asymptomatic Progressive Dead
#> Asymptomatic         0.75         0.2 0.05
#> Progressive          0.00         0.9 0.10
#> Dead                 0.00         0.0 1.00
```
