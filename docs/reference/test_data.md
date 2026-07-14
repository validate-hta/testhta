# Standard baseline parameters for cost-effectiveness testing

A list containing the default setup for the cohort Markov model.

## Usage

``` r
data(test_data)
```

## Format

A list with 10 elements:

- start_pop:

  Initial population counts vector

- p_matrix:

  Transition probability 3D array

- state_c_matrix:

  State occupancy cost matrix

- trans_c_matrix:

  Transition cost matrix

- state_q_matrix:

  State utility matrix

- n_cycles:

  Number of model cycles

- init_age:

  Initial cohort age

- s_names:

  Health state names vector

- t_names:

  Treatment names vector

- discount_rate:

  Discount rate
