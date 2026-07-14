# run cost-effectiveness model

Runs a Markov model to calculate costs, QALYs, and life expectancy for
different treatments

## Usage

``` r
ce_markov(
  start_pop,
  p_matrix,
  state_c_matrix,
  trans_c_matrix,
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

  A vector of initial population counts for each health state

- p_matrix:

  A 3D array of transition probabilities for each treatment

- state_c_matrix:

  A matrix of state costs for each treatment

- trans_c_matrix:

  A matrix of transition costs for each treatment

- state_q_matrix:

  A matrix of state utilities for each treatment

- n_cycles:

  The number of cycles to run the model for

- init_age:

  The initial age of the population

- s_names:

  Optional names for the health states

- t_names:

  Optional names for the treatments

- discount_rate:

  The discount rate to apply to costs and QALYs

- ...:

  Additional arguments passed to p_matrix_cycle.

## Value

A list containing the population array, total life expectancy, total
life-years, cycle costs, cycle QALYs, total costs, and total QALYs for
each treatment
