# testhta

**A Unit Testing and Verification Framework for Health Technology
Assessment (HTA) Models**

`testhta` provides a robust, software-engineering-inspired framework for
applying **unit testing** and **behavioral verification** to health
economic and health technology assessment (HTA) models. By leveraging
the [`testthat`](https://testthat.r-lib.org/) testing framework,
`testhta` enables modelers to write automated checks that verify
mathematical, logical, and structural correctness under boundary
conditions. The package includes a built-in cohort Markov model as a
demonstration environment, showing how to define, group, and execute
these checks in practice.

Ensuring HTA model quality should not require manual spreadsheet audits.
`testhta` makes verification automated, reproducible, and
transparent—enhancing decision-maker confidence in cost-effectiveness
results.

------------------------------------------------------------------------

## Key Features

- 🧪 **Verification Helpers**: Out-of-the-box functions to test model
  behavior against expected bounds
  ([`check_model_qalys()`](https://n8thangreen.github.io/testhta/reference/check_model_qalys.md),
  [`check_model_costs()`](https://n8thangreen.github.io/testhta/reference/check_model_costs.md),
  [`check_model_le()`](https://n8thangreen.github.io/testhta/reference/check_model_le.md)).
- 🔄 **Relational Comparators**: Compare model behaviors across
  parameter spaces using
  [`compare_model_runs()`](https://n8thangreen.github.io/testhta/reference/compare_model_runs.md)
  (e.g., verifying that discounting reduces future values).
- 🔗 **Tidy Test API**: Modify parameters cleanly using setter functions
  ([`set_discount_rate()`](https://n8thangreen.github.io/testhta/reference/set_discount_rate.md),
  [`set_time_horizon()`](https://n8thangreen.github.io/testhta/reference/set_time_horizon.md))
  integrated with the base R pipe (`|>`) to isolate test runs.
- ⚙️ **Markov Engine Example Case Study**: An example discrete-time
  cohort Markov simulation environment built with time-dependent
  transitions, discounting, and state/transition-specific costs and
  utilities to demonstrate the test framework.

------------------------------------------------------------------------

## Installation

You can install the development version of `testhta` from GitHub:

``` r

# install.packages("devtools")
devtools::install_github("n8thangreen/testhta")
```

------------------------------------------------------------------------

## Quick Start: Build, Run, and Verify

Here is a basic example demonstrating how to run a cohort Markov model
and verify the economic logic of discounting using the tidy API.

### 1. Set Up and Run the Model

We use the package’s built-in baseline dataset `test_data` to execute a
cost-effectiveness model.

``` r

library(testhta)

# Load baseline dataset
data(test_data)

# Run the Markov simulation
results <- run_model(test_data)

# Extract key HTA outputs using getters
get_qalys(results)
#>   without_drug      with_drug 
#>       11.45892       12.12450 

get_costs(results)
#>   without_drug      with_drug 
#>       22354.21       34211.55 

get_icer(results)
#> [1] 17814.77
```

### 2. Modify Parameters with Pipe Setters

Easily perform scenario analyses or sensitivity sweeps by piping
parameter modifications:

``` r

# Evaluate a 10-year time horizon with no discounting
scenario_results <- test_data |>
  set_time_horizon(10) |>
  set_discount_rate(0) |>
  run_model()

get_icer(scenario_results)
#> [1] 12903.45
```

### 3. Automated Validation Assertions

`testhta` provides assertion functions that integrate seamlessly into
standard R package tests (using `testthat`).

``` r

library(testthat)

# Verify that QALYs with standard discounting (3.5%) are strictly less 
# than QALYs without discounting
compare_model_runs(
  extractor_fn = get_qalys,
  comparison_fn = expect_lt,
  params_1 = list(discount_rate = 0.035),
  params_2 = list(discount_rate = 0),
  data = test_data,
  label = "Discounted QALYs are lower than undiscounted QALYs"
)
```

------------------------------------------------------------------------

## The HTA Verification Framework

The validation checks in `testhta` are based on formal software
verification methodologies described by Tappenden et al. (2014) and
Elbasha & Dasbach (2017). The framework checks “black-box” model
behavior under extreme inputs to identify structural bugs:

| Test Case | Boundary Condition | Expected Behavior | Verification Helper |
|:---|:---|:---|:---|
| **QALY Zeroing** | Set all utilities to `0` | QALYs must equal `0` | `check_model_qalys(0, ...)` |
| **QALY Upper Bound** | Set utilities to `1`, discount to `0` | QALYs must equal Life Expectancy | `expect_equal(get_qalys(r), get_le(r))` |
| **Discount Sensitivity** | High discount rate vs Low discount rate | High discount rate must yield lower values | `compare_model_runs(..., expect_lt)` |
| **Absorbing States** | Transition to death state set to `1` | Life Expectancy must equal `1` cycle | `check_model_le(1, ...)` |
| **No-Death Horizon** | Transition to death state set to `0` | Life Expectancy must equal `n_cycles` | `check_model_le(n_cycles, ...)` |
| **Zero-Cost Bounding** | Set all costs to `0` | Total costs must equal `0` | `check_model_costs(0, ...)` |

------------------------------------------------------------------------

## References

1.  **Tappenden, P., & Chilcott, J. B.** (2014). Avoiding and
    Identifying Errors and Other Threats to the Credibility of Health
    Economic Models. *PharmacoEconomics*, 32, 967–979.
    <https://doi.org/10.1007/s40273-014-0186-2>
2.  **Elbasha, E. H., & Dasbach, E. J.** (2017). Verification of
    Decision-Analytic Models for Health Economic Evaluations: An
    Overview. *PharmacoEconomics*, 35, 673–683.
    <https://doi.org/10.1007/s40273-017-0508-2>
3.  **Alarid-Escudero, F., et al.** (2019). A Need for Change! A Coding
    Framework for Improving Transparency in Decision Modeling.
    *PharmacoEconomics*, 37(11), 1329–1339.
    <https://doi.org/10.1007/s40273-019-00837-x>
