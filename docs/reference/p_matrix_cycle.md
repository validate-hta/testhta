# Time-dependent probability matrix

Calculates time-dependent transition probabilities for a Markov model

## Usage

``` r
p_matrix_cycle(
  p_matrix,
  age,
  cycle,
  tpProg = 0.01,
  tpDcm = 0.15,
  effect = 0.5,
  p_healthy_death = NULL,
  p_sick_death = NULL,
  ...
)
```

## Arguments

- p_matrix:

  The base transition probability matrix

- age:

  The age of the individual

- cycle:

  The current cycle number

- tpProg:

  The probability of progression from asymptomatic to progressive
  disease

- tpDcm:

  The probability of death from progressive disease

- effect:

  The effectiveness of the drug

- p_healthy_death:

  Optional override for transition probability from healthy to dead

- p_sick_death:

  Optional override for transition probability from sick to dead

- ...:

  Extra arguments

## Value

The updated transition probability matrix
