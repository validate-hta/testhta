# Package index

## Test Suite Generator

Scaffolding functions to automatically generate unit testing
infrastructure for HTA models.

- [`use_hta_unittests()`](https://validate-hta.github.io/testhta/reference/use_hta_unittests.md)
  : Generate Skeleton Unit Tests for HTA Models

## Model Validation & Verification Helpers

Exported assertion functions to write automated unit tests and check
model boundaries.

- [`run_model()`](https://validate-hta.github.io/testhta/reference/run_model.md)
  : Run Markov model with parameters and overrides
- [`check_model_qalys()`](https://validate-hta.github.io/testhta/reference/check_model_qalys.md)
  : Run model and check QALYs against an expected value
- [`check_model_costs()`](https://validate-hta.github.io/testhta/reference/check_model_costs.md)
  : Run model and check Costs against an expected value
- [`check_model_le()`](https://validate-hta.github.io/testhta/reference/check_model_le.md)
  : Run model and check Life Expectancy against an expected value
- [`check_model_le_pp()`](https://validate-hta.github.io/testhta/reference/check_model_le_pp.md)
  : Run model and check per-person Life Expectancy against an expected
  value
- [`compare_model_runs()`](https://validate-hta.github.io/testhta/reference/compare_model_runs.md)
  : Compare model outputs from two different parameter sets

## Model Setters & Getters

Helper functions to modify input parameters, query parameter matrices by
treatment arm, and extract outcomes during test execution.

- [`set_discount_rate()`](https://validate-hta.github.io/testhta/reference/set_discount_rate.md)
  : Set discount rate
- [`set_costs()`](https://validate-hta.github.io/testhta/reference/set_costs.md)
  : Set costs for a scenario
- [`set_p_matrix()`](https://validate-hta.github.io/testhta/reference/set_p_matrix.md)
  : Set transition probabilities for a scenario
- [`set_utilities()`](https://validate-hta.github.io/testhta/reference/set_utilities.md)
  : Set utilities for a scenario
- [`set_time_horizon()`](https://validate-hta.github.io/testhta/reference/set_time_horizon.md)
  : Set time horizon
- [`get_state_costs()`](https://validate-hta.github.io/testhta/reference/get_state_costs.md)
  : Getter for state costs
- [`get_state_utilities()`](https://validate-hta.github.io/testhta/reference/get_state_utilities.md)
  : Getter for state utilities
- [`get_transition_matrix()`](https://validate-hta.github.io/testhta/reference/get_transition_matrix.md)
  : Getter for transition probability matrix
- [`get_qalys()`](https://validate-hta.github.io/testhta/reference/get_qalys.md)
  : Getter for QALYs
- [`get_qalys_pp()`](https://validate-hta.github.io/testhta/reference/get_qalys_pp.md)
  : Getter for per-person QALYs
- [`get_costs()`](https://validate-hta.github.io/testhta/reference/get_costs.md)
  : Getter for costs
- [`get_costs_pp()`](https://validate-hta.github.io/testhta/reference/get_costs_pp.md)
  : Getter for per-person costs
- [`get_le()`](https://validate-hta.github.io/testhta/reference/get_le.md)
  : Getter for life expectancy (LE)
- [`get_le_pp()`](https://validate-hta.github.io/testhta/reference/get_le_pp.md)
  : Getter for per-person life expectancy (LE)
- [`get_icer()`](https://validate-hta.github.io/testhta/reference/get_icer.md)
  : Getter for ICER
- [`get_incremental_costs()`](https://validate-hta.github.io/testhta/reference/get_incremental_costs.md)
  : Getter for incremental costs
- [`get_incremental_qalys()`](https://validate-hta.github.io/testhta/reference/get_incremental_qalys.md)
  : Getter for incremental QALYs
- [`get_arm_names()`](https://validate-hta.github.io/testhta/reference/get_arm_names.md)
  : Getter for treatment arm names

## Example Case Study Model

The cohort Markov model engine and baseline dataset used as the
demonstration environment in the tutorial paper.

- [`ce_markov()`](https://validate-hta.github.io/testhta/reference/ce_markov.md)
  : Run cost-effectiveness Markov model
- [`p_matrix_cycle()`](https://validate-hta.github.io/testhta/reference/p_matrix_cycle.md)
  : Time-dependent probability matrix
- [`sample_psa_parameters()`](https://validate-hta.github.io/testhta/reference/sample_psa_parameters.md)
  : Sample probabilistic sensitivity analysis (PSA) parameters
- [`base_params`](https://validate-hta.github.io/testhta/reference/base_params.md)
  [`test_data`](https://validate-hta.github.io/testhta/reference/base_params.md)
  : Baseline parameters for the cohort Markov model case study
