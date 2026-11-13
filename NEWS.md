# testhta 0.1.0

- First release of the `testhta` verification and automated testing framework for health economic and HTA models in R, accompanying the tutorial paper *"Automated Verification for Health Economic Models in R: A Hands-On Tutorial"*.

## New Features

- Added the 3-state (`Asymptomatic`, `Progressive`, `Dead`) discrete-time cohort Markov model (`ce_markov()`, `p_matrix_cycle()`, `sample_psa_parameters()`) and baseline parameter dataset (`base_params`, aliased as `test_data`).
- Added getters to retrieve total and per-person cohort simulation metrics:
  - `get_costs()` and `get_costs_pp()`: Retrieve total and per-person discounted costs.
  - `get_icer()`, `get_incremental_costs()`, `get_incremental_qalys()`: Calculate incremental cost-effectiveness metrics.
  - `get_le()` and `get_le_pp()`: Retrieve total and per-person Life Expectancy.
  - `get_qalys()` and `get_qalys_pp()`: Retrieve total and per-person discounted Quality-Adjusted Life Years.
  - `get_arm_names()`, `get_state_costs()`, `get_state_utilities()`, `get_transition_matrix()`: Extract parameter-level structures by treatment arm.
- Added `use_hta_unittests()` to automatically generate `testthat` directory structures and pre-configured verification test scripts aligned with the HTA Verification Registry (`T01` – `T12`).
- Added piping-compatible setters to dynamically override model parameters:
  - `set_costs()`: Modify state-occupancy costs.
  - `set_discount_rate()`: Modify model discount rates.
  - `set_p_matrix()`: Modify transition probability arrays.
  - `set_time_horizon()`: Modify simulation time horizon.
  - `set_utilities()`: Modify state-specific utilities.

## Testing & Verification Helpers

- Added custom expectation helpers for use with the `testthat` package:
  - `check_model_costs()`: Assert expected costs under bounding conditions.
  - `check_model_le()` and `check_model_le_pp()`: Assert expected total and per-person life expectancy under bounding conditions.
  - `check_model_qalys()`: Assert expected QALYs under bounding conditions.
  - `compare_model_runs()`: Assert directional and logical relationships between two model parameter configurations.
  - `run_model()`: Core parameter-override wrapper for executing the underlying Markov engine.

## Documentation & Infrastructure

- Created a `pkgdown` documentation website using the Bootstrap 5 `flatly` Bootswatch theme.
- Added comprehensive tutorial vignettes aligned with the accompanying paper:
  - `introduction`: Case study overview, model architecture ("separation of concerns"), and setters/getters.
  - `verification-framework`: Software engineering Test Pyramid and the `T01` – `T12` HTA Verification Test Registry.
  - `basic-tests`: Step-by-step R test code examples for discounting (`T06`, `T07`, `T11`), costs (`T08`), and population (`T03`).
  - `validation-guide`: Custom expectations (`T01` – `T11`) and reproducible stochastic PSA testing with `withr` (`T12`).
  - `automating-hta-unit-tests`: Automating test execution, scaffolding with `use_hta_unittests()`, and AI-assisted testing (`model-context.md`).
