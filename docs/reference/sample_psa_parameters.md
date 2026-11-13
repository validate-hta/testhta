# Sample probabilistic sensitivity analysis (PSA) parameters

Generates Monte Carlo samples of health state utility parameters from
Beta distributions for stochastic verification tests (e.g., Registry
test `T12`).

## Usage

``` r
sample_psa_parameters(n_sim = 1000, base_params = NULL)
```

## Arguments

- n_sim:

  Number of Monte Carlo simulation draws (default: `1000`).

- base_params:

  Optional baseline parameter list.

## Value

A `data.frame` with columns `utility_Asymptomatic` and
`utility_Progressive`.

## Examples

``` r
data(base_params)
samples <- sample_psa_parameters(n_sim = 10, base_params = base_params)
head(samples)
#>   utility_Asymptomatic utility_Progressive
#> 1            0.9777782           0.7957858
#> 2            0.9364630           0.6900421
#> 3            0.9912845           0.8753849
#> 4            0.9453825           0.7020413
#> 5            0.9212340           0.8910305
#> 6            0.8909070           0.7932808
```
