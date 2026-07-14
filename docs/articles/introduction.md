# Introduction to testhta

``` r

library(testhta)
```

`testhta` provides a software-engineering-inspired framework for
building and validating Health Technology Assessment (HTA)
cost-effectiveness models in R. By combining cohort Markov models with
structured unit tests, it ensures model transparency, correctness, and
reproducibility.

This vignette covers: 1. Setting up a Markov model. 2. Running the model
under baseline parameters. 3. Accessing model outputs using getters.

## 1. The HTA Markov Model Setup

The core function in `testhta` is
[`ce_markov()`](https://n8thangreen.github.io/testhta/reference/ce_markov.md),
which runs a cohort Markov model. The model expects: - `start_pop`:
Initial counts of the cohort across health states. - `p_matrix`: A
3-dimensional array of transition probabilities (states $`\times`$
states $`\times`$ treatments). - `state_c_matrix`: A matrix of costs for
state occupancy. - `trans_c_matrix`: A matrix of costs incurred during
state transitions. - `state_q_matrix`: A matrix of quality-of-life
weights (utilities) for each state.

The package includes a built-in baseline dataset called `test_data`.
Let’s inspect its structure:

``` r

# Load baseline dataset
data(test_data)
names(test_data)
#>  [1] "start_pop"      "p_matrix"       "state_c_matrix" "trans_c_matrix"
#>  [5] "state_q_matrix" "n_cycles"       "init_age"       "s_names"       
#>  [9] "t_names"        "discount_rate"
```

It contains: - `start_pop`: Vector of length 3 (Asymptomatic disease,
Progressive disease, Dead) - `p_matrix`: $`3 \times 3 \times 2`$ array
for `without_drug` and `with_drug` - `state_c_matrix`: State cost matrix
for each treatment - `state_q_matrix`: Utility matrix for each
treatment - `discount_rate`: Standard HTA discount rate (typically 3.5%
or 0.035) - `n_cycles`: Time horizon of the model

## 2. Running the Model

We can run the model by passing `test_data` parameters directly to
[`ce_markov()`](https://n8thangreen.github.io/testhta/reference/ce_markov.md),
or using the wrapper helper
[`run_model()`](https://n8thangreen.github.io/testhta/reference/run_model.md).

Here is how you execute the Markov simulation:

``` r

# Run with the helper wrapper
results <- run_model(test_data)
```

The output of
[`run_model()`](https://n8thangreen.github.io/testhta/reference/run_model.md)
is a list containing the population distributions, cycle-specific costs
and QALYs, and summary metrics.

## 3. Extracting Results using Getters

`testhta` provides clean getter functions to extract the key outcomes
from your model results:

- [`get_qalys()`](https://n8thangreen.github.io/testhta/reference/get_qalys.md):
  Extracts total Quality-Adjusted Life Years (QALYs).
- [`get_costs()`](https://n8thangreen.github.io/testhta/reference/get_costs.md):
  Extracts total costs.
- [`get_le()`](https://n8thangreen.github.io/testhta/reference/get_le.md):
  Extracts total Life Expectancy (undiscounted life-years).
- [`get_icer()`](https://n8thangreen.github.io/testhta/reference/get_icer.md):
  Calculates the Incremental Cost-Effectiveness Ratio (ICER) between the
  two arms.

Let’s retrieve these values from our results:

``` r

# Get total QALYs
get_qalys(results)
#> without_drug    with_drug 
#>     9.048517     9.589129

# Get total Costs
get_costs(results)
#> without_drug    with_drug 
#>     9205.744    16977.576

# Get life expectancy
get_le(results)
#> without_drug    with_drug 
#>     12.06416     12.68332

# Calculate the ICER
get_icer(results)
#> [1] 14375.98
```

## 4. Parameter Modification with Setters

The package provides setter functions that follow a tidy workflow using
the base R pipe (`|>`). These allow you to easily modify input
parameters for scenario or sensitivity analyses before running the
model:

- `set_discount_rate(input, discount_rate)`
- `set_time_horizon(input, n_cycles)`
- `set_costs(input, scenario, values)`
- `set_utilities(input, scenario, values)`

For example, to calculate the ICER with no discounting and a shorter
time horizon (20 cycles):

``` r

scenario_results <- test_data |>
  set_discount_rate(0) |>
  set_time_horizon(20) |>
  run_model()

get_icer(scenario_results)
#> [1] 7392.202
```

This piping framework makes scenario analysis clean, readable, and less
prone to copy-paste errors.
