# Package index

## Model Validation & Verification Helpers

Exported assertion functions to write automated unit tests and check
model boundaries.

- [`run_model()`](https://n8thangreen.github.io/testhta/reference/run_model.md)
  : Run Markov model with parameters and overrides
- [`check_model_qalys()`](https://n8thangreen.github.io/testhta/reference/check_model_qalys.md)
  : Run model and check QALYs against an expected value
- [`check_model_costs()`](https://n8thangreen.github.io/testhta/reference/check_model_costs.md)
  : Run model and check Costs against an expected value
- [`check_model_le()`](https://n8thangreen.github.io/testhta/reference/check_model_le.md)
  : Run model and check Life Expectancy against an expected value
- [`compare_model_runs()`](https://n8thangreen.github.io/testhta/reference/compare_model_runs.md)
  : Compare model outputs from two different parameter sets

## Model Setters & Getters

Helper functions to modify input parameters and extract outcomes during
test execution.

- [`set_discount_rate()`](https://n8thangreen.github.io/testhta/reference/set_discount_rate.md)
  : Set discount rate
- [`set_costs()`](https://n8thangreen.github.io/testhta/reference/set_costs.md)
  : Set costs for a scenario
- [`set_p_matrix()`](https://n8thangreen.github.io/testhta/reference/set_p_matrix.md)
  : Set transition probabilities for a scenario
- [`set_utilities()`](https://n8thangreen.github.io/testhta/reference/set_utilities.md)
  : Set utilities for a scenario
- [`set_time_horizon()`](https://n8thangreen.github.io/testhta/reference/set_time_horizon.md)
  : Set time horizon
- [`get_qalys()`](https://n8thangreen.github.io/testhta/reference/get_qalys.md)
  : Getter for QALYs
- [`get_costs()`](https://n8thangreen.github.io/testhta/reference/get_costs.md)
  : Getter for costs
- [`get_le()`](https://n8thangreen.github.io/testhta/reference/get_le.md)
  : Getter for life expectancy (LE)
- [`get_icer()`](https://n8thangreen.github.io/testhta/reference/get_icer.md)
  : Getter for ICER

## Example Case Study Model

The cohort Markov model engine used as the demonstration environment for
these testing tools.

- [`ce_markov()`](https://n8thangreen.github.io/testhta/reference/ce_markov.md)
  : run cost-effectiveness model
- [`p_matrix_cycle()`](https://n8thangreen.github.io/testhta/reference/p_matrix_cycle.md)
  : Time-dependent probability matrix
- [`test_data`](https://n8thangreen.github.io/testhta/reference/test_data.md)
  : Standard baseline parameters for cost-effectiveness testing
