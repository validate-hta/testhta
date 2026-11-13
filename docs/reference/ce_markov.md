# Run cost-effectiveness Markov model

Runs a discrete-time cohort Markov model to calculate costs, QALYs, and
life expectancy for different treatments.

## Usage

``` r
ce_markov(
  start_pop,
  p_matrix,
  state_c_matrix,
  state_q_matrix,
  n_cycles = 46,
  init_age = 55,
  s_names = NULL,
  t_names = NULL,
  discount_rate = 0.035,
  ...
)
```

## Arguments

- start_pop:

  A vector of initial population counts for each health state.

- p_matrix:

  A 3D array of transition probabilities for each treatment.

- state_c_matrix:

  A matrix of state costs for each treatment.

- state_q_matrix:

  A matrix of state utilities for each treatment.

- n_cycles:

  The number of cycles to run the model for.

- init_age:

  The initial age of the population.

- s_names:

  Optional names for the health states.

- t_names:

  Optional names for the treatments.

- discount_rate:

  The discount rate to apply to costs and QALYs.

- ...:

  Additional arguments passed to
  [`p_matrix_cycle()`](https://validate-hta.github.io/testhta/reference/p_matrix_cycle.md).

## Value

A list containing the population array, total and per-person life
expectancy (`total_LE`, `total_LE_pp`), total and per-person life-years
(`total_LYs`, `total_LYs_pp`), cycle costs, cycle QALYs, and total and
per-person costs (`total_costs`, `total_costs_pp`) and QALYs
(`total_QALYs`, `total_QALYs_pp`) for each treatment.

## Examples

``` r
data(base_params)
res <- do.call(ce_markov, base_params)
res$total_costs
#> without_drug    with_drug 
#>      1147099      4865536 
```
