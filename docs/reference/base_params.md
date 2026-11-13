# Baseline parameters for the cohort Markov model case study

A list containing the baseline input parameters for the 3-state
(`Asymptomatic`, `Progressive`, `Dead`) cohort Markov model comparing
`without_drug` and `with_drug`, as defined in the accompanying tutorial
paper.

## Usage

``` r
data(base_params)

data(test_data)
```

## Format

A list with 6 elements:

- start_pop:

  Named numeric vector of initial population counts across the 3 health
  states (`Asymptomatic = 1000`, `Progressive = 0`, `Dead = 0`).

- p_matrix:

  A 3 x 3 x 2 array of baseline transition probabilities for
  `without_drug` and `with_drug`.

- state_c_matrix:

  A 2 x 3 matrix of state occupancy costs for each treatment scenario
  and health state.

- state_q_matrix:

  A 2 x 3 matrix of health state utility weights for each treatment
  scenario and health state.

- n_cycles:

  Time horizon in model cycles (`15`).

- discount_rate:

  Annual discount rate for costs and QALYs (`0.035`).

An object of class `list` of length 6.

## Examples

``` r
data(base_params)
str(base_params)
#> List of 6
#>  $ start_pop     : Named num [1:3] 1000 0 0
#>   ..- attr(*, "names")= chr [1:3] "Asymptomatic" "Progressive" "Dead"
#>  $ p_matrix      : num [1:3, 1:3, 1:2] 0.75 0 0 0.2 0.9 0 0.05 0.1 1 0.85 ...
#>   ..- attr(*, "dimnames")=List of 3
#>   .. ..$ : chr [1:3] "Asymptomatic" "Progressive" "Dead"
#>   .. ..$ : chr [1:3] "Asymptomatic" "Progressive" "Dead"
#>   .. ..$ : chr [1:2] "without_drug" "with_drug"
#>  $ state_c_matrix: num [1:2, 1:3] 100 500 200 200 0 0
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:2] "without_drug" "with_drug"
#>   .. ..$ : chr [1:3] "Asymptomatic" "Progressive" "Dead"
#>  $ state_q_matrix: num [1:2, 1:3] 0.9 0.9 0.6 0.6 0 0
#>   ..- attr(*, "dimnames")=List of 2
#>   .. ..$ : chr [1:2] "without_drug" "with_drug"
#>   .. ..$ : chr [1:3] "Asymptomatic" "Progressive" "Dead"
#>  $ n_cycles      : num 15
#>  $ discount_rate : num 0.035
```
