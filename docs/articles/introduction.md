# Introduction to testhta

``` r

library(testhta)
```

`testhta` provides a software-engineering-inspired framework for
building and verifying Health Technology Assessment (HTA) and health
economic models in R. By combining a modular cohort Markov model
architecture with structured automated tests via `testthat`, it ensures
model transparency, internal consistency, and reproducibility.

This vignette covers the case study presented in Section 5 and Section
6.1–6.2 of the accompanying tutorial paper:

1.  **Model Overview**: Defining the 3-state discrete-time Markov cohort
    model and baseline input parameters (`base_params`).
2.  **Model Architecture**: Applying “separation of concerns” across
    input parameters, the simulation engine
    ([`ce_markov()`](https://validate-hta.github.io/testhta/reference/ce_markov.md)),
    and helper functions
    ([`run_model()`](https://validate-hta.github.io/testhta/reference/run_model.md),
    getters, and setters).
3.  **Running and Interacting with the Model**: Extracting outcomes and
    modifying parameters cleanly.

------------------------------------------------------------------------

## 1. Case Study: A 3-State Discrete-Time Markov Model

We consider a 3-state (`Asymptomatic`, `Progressive`, `Dead`) cohort
Markov model with two intervention scenarios: **Without Drug**
($`s = 1`$, `"without_drug"`) and **With Drug** ($`s = 2`$,
`"with_drug"`).

The drug unit cost is 400 monetary units. Let $`p^s_{xy}`$ denote the
transition probability from state $`x`$ to state $`y`$ for scenario
$`s`$, and let $`c^s_x`$ and $`q^s_x`$ denote the state occupancy costs
and utility weights for state $`x`$ and scenario $`s`$:

``` math
C^1 = \begin{pmatrix} 100 \\ 200 \\ 0 \end{pmatrix}, \quad
C^2 = \begin{pmatrix} 500 \\ 200 \\ 0 \end{pmatrix}, \quad
Q^s = \begin{pmatrix} 0.9 \\ 0.6 \\ 0 \end{pmatrix}
```

and the baseline transition probability matrices are:

``` math
P^1 = \begin{pmatrix}
0.75 & 0.2 & 0.05 \\
0 & 0.9 & 0.1 \\
0 & 0 & 1
\end{pmatrix}, \quad
P^2 = \begin{pmatrix}
0.85 & 0.1 & 0.05 \\
0 & 0.95 & 0.05 \\
0 & 0 & 1
\end{pmatrix}
```

A cohort of size $`n = 1000`$ starts in state $`x = 1`$ (`Asymptomatic`)
at time $`t = 0`$ and is simulated over a time horizon of
$`n_{\text{cycles}} = 15`$ cycles with a $`3.5\%`$ annual discount rate
(`discount_rate = 0.035`).

### Baseline Input Parameters (`base_params`)

In R, this model definition is stored as a list named `base_params`
(also available via `data(base_params)`):

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

------------------------------------------------------------------------

## 2. Model Architecture: Separation of Concerns

To effectively implement automated verification using `testthat`, the
underlying R code should not be written as a single monolithic script
that relies on global variables. Instead, `testhta` separates the
computational pipeline into three modular domains:

1.  **Input Parameters (`base_params`)**: Transition matrices, cost
    vectors, utility weights, time horizon, and discount rate are
    isolated in a structured list so that individual tests can inject
    boundary values without contaminating the global environment.
2.  **Simulation Engine
    ([`ce_markov()`](https://validate-hta.github.io/testhta/reference/ce_markov.md))**:
    Accepts the input parameters, executes the matrix multiplication
    across the specified time horizon, and returns a single list object
    containing all cohort traces and summary outputs.
3.  **Helper Functions (Wrappers, Setters, and Getters)**: Abstract away
    the internal structure of the input and output lists so that test
    scripts remain concise and resilient to future refactoring.

### Running the Model with `run_model()`

The convenience wrapper `run_model(data, ...)` merges `base_params` with
any named parameter overrides passed via `...` (using
[`modifyList()`](https://rdrr.io/r/utils/modifyList.html)) and calls
[`ce_markov()`](https://validate-hta.github.io/testhta/reference/ce_markov.md):

``` r

# Run the model with baseline parameters
results <- run_model(base_params)
names(results)
#>  [1] "pop"            "total_LE"       "total_LYs"      "total_LE_pp"   
#>  [5] "total_LYs_pp"   "cycle_costs"    "cycle_QALYs"    "total_costs"   
#>  [9] "total_QALYs"    "total_costs_pp" "total_QALYs_pp"
```

------------------------------------------------------------------------

## 3. Extracting Results Using Getters

`testhta` provides getter (accessor) functions to extract targeted
outputs from a model run without hard-coding list element names
throughout your test suite:

- `get_qalys(res)` / `get_qalys_pp(res)`: Extract total cohort QALYs or
  per-person QALYs.
- `get_costs(res)` / `get_costs_pp(res)`: Extract total cohort costs or
  per-person costs.
- `get_le(res)` / `get_le_pp(res)`: Extract total cohort Life Expectancy
  or per-person Life Expectancy (undiscounted life-years).
- `get_icer(res)`: Calculate the Incremental Cost-Effectiveness Ratio
  (ICER) comparing `with_drug` against `without_drug`.

``` r

# Total cohort QALYs and per-person QALYs
get_qalys(results)
#> without_drug    with_drug 
#>     8394.580     8981.496
get_qalys_pp(results)
#> without_drug    with_drug 
#>     8.394580     8.981496

# Total cohort Costs and per-person Costs
get_costs(results)
#> without_drug    with_drug 
#>      1147099      4865536
get_costs_pp(results)
#> without_drug    with_drug 
#>     1147.099     4865.536

# Total and per-person Life Expectancy (LE)
get_le(results)
#> without_drug    with_drug 
#>     12064.16     12683.32
get_le_pp(results)
#> without_drug    with_drug 
#>     12.06416     12.68332

# Incremental Cost-Effectiveness Ratio (ICER)
get_icer(results)
#> [1] 6335.546
```

------------------------------------------------------------------------

## 4. Modifying Parameters Using Setters

Similarly, setter (mutator) functions safely modify a specific parameter
within `base_params` and return the updated parameter list, enabling
clean pipelines with the base R pipe (`|>`):

- `set_discount_rate(input, discount_rate)`
- `set_time_horizon(input, n_cycles)`
- `set_costs(input, scenario, values)`
- `set_utilities(input, scenario, values)`
- `set_p_matrix(input, scenario, values)`

For example, to evaluate the model with a $`0\%`$ discount rate over a
10-cycle time horizon:

``` r

scenario_results <- base_params |>
  set_discount_rate(0) |>
  set_time_horizon(10) |>
  run_model()

get_icer(scenario_results)
#> [1] 11902.39
```
