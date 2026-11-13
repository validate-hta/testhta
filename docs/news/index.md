# Changelog

## testhta 0.1.0

- First release of the `testhta` verification and automated testing
  framework for health economic and HTA models in R, accompanying the
  tutorial paper *“Automated Verification for Health Economic Models in
  R: A Hands-On Tutorial”*.

### New Features

- Added the 3-state (`Asymptomatic`, `Progressive`, `Dead`)
  discrete-time cohort Markov model
  ([`ce_markov()`](https://validate-hta.github.io/testhta/reference/ce_markov.md),
  [`p_matrix_cycle()`](https://validate-hta.github.io/testhta/reference/p_matrix_cycle.md),
  [`sample_psa_parameters()`](https://validate-hta.github.io/testhta/reference/sample_psa_parameters.md))
  and baseline parameter dataset (`base_params`, aliased as
  `test_data`).
- Added getters to retrieve total and per-person cohort simulation
  metrics:
  - [`get_costs()`](https://validate-hta.github.io/testhta/reference/get_costs.md)
    and
    [`get_costs_pp()`](https://validate-hta.github.io/testhta/reference/get_costs_pp.md):
    Retrieve total and per-person discounted costs.
  - [`get_icer()`](https://validate-hta.github.io/testhta/reference/get_icer.md),
    [`get_incremental_costs()`](https://validate-hta.github.io/testhta/reference/get_incremental_costs.md),
    [`get_incremental_qalys()`](https://validate-hta.github.io/testhta/reference/get_incremental_qalys.md):
    Calculate incremental cost-effectiveness metrics.
  - [`get_le()`](https://validate-hta.github.io/testhta/reference/get_le.md)
    and
    [`get_le_pp()`](https://validate-hta.github.io/testhta/reference/get_le_pp.md):
    Retrieve total and per-person Life Expectancy.
  - [`get_qalys()`](https://validate-hta.github.io/testhta/reference/get_qalys.md)
    and
    [`get_qalys_pp()`](https://validate-hta.github.io/testhta/reference/get_qalys_pp.md):
    Retrieve total and per-person discounted Quality-Adjusted Life
    Years.
  - [`get_arm_names()`](https://validate-hta.github.io/testhta/reference/get_arm_names.md),
    [`get_state_costs()`](https://validate-hta.github.io/testhta/reference/get_state_costs.md),
    [`get_state_utilities()`](https://validate-hta.github.io/testhta/reference/get_state_utilities.md),
    [`get_transition_matrix()`](https://validate-hta.github.io/testhta/reference/get_transition_matrix.md):
    Extract parameter-level structures by treatment arm.
- Added
  [`use_hta_unittests()`](https://validate-hta.github.io/testhta/reference/use_hta_unittests.md)
  to automatically generate `testthat` directory structures and
  pre-configured verification test scripts aligned with the HTA
  Verification Registry (`T01` – `T12`).
- Added piping-compatible setters to dynamically override model
  parameters:
  - [`set_costs()`](https://validate-hta.github.io/testhta/reference/set_costs.md):
    Modify state-occupancy costs.
  - [`set_discount_rate()`](https://validate-hta.github.io/testhta/reference/set_discount_rate.md):
    Modify model discount rates.
  - [`set_p_matrix()`](https://validate-hta.github.io/testhta/reference/set_p_matrix.md):
    Modify transition probability arrays.
  - [`set_time_horizon()`](https://validate-hta.github.io/testhta/reference/set_time_horizon.md):
    Modify simulation time horizon.
  - [`set_utilities()`](https://validate-hta.github.io/testhta/reference/set_utilities.md):
    Modify state-specific utilities.

### Testing & Verification Helpers

- Added custom expectation helpers for use with the `testthat` package:
  - [`check_model_costs()`](https://validate-hta.github.io/testhta/reference/check_model_costs.md):
    Assert expected costs under bounding conditions.
  - [`check_model_le()`](https://validate-hta.github.io/testhta/reference/check_model_le.md)
    and
    [`check_model_le_pp()`](https://validate-hta.github.io/testhta/reference/check_model_le_pp.md):
    Assert expected total and per-person life expectancy under bounding
    conditions.
  - [`check_model_qalys()`](https://validate-hta.github.io/testhta/reference/check_model_qalys.md):
    Assert expected QALYs under bounding conditions.
  - [`compare_model_runs()`](https://validate-hta.github.io/testhta/reference/compare_model_runs.md):
    Assert directional and logical relationships between two model
    parameter configurations.
  - [`run_model()`](https://validate-hta.github.io/testhta/reference/run_model.md):
    Core parameter-override wrapper for executing the underlying Markov
    engine.

### Documentation & Infrastructure

- Created a `pkgdown` documentation website using the Bootstrap 5
  `flatly` Bootswatch theme.
- Added comprehensive tutorial vignettes aligned with the accompanying
  paper:
  - `introduction`: Case study overview, model architecture (“separation
    of concerns”), and setters/getters.
  - `verification-framework`: Software engineering Test Pyramid and the
    `T01` – `T12` HTA Verification Test Registry.
  - `basic-tests`: Step-by-step R test code examples for discounting
    (`T06`, `T07`, `T11`), costs (`T08`), and population (`T03`).
  - `validation-guide`: Custom expectations (`T01` – `T11`) and
    reproducible stochastic PSA testing with `withr` (`T12`).
  - `automating-hta-unit-tests`: Automating test execution, scaffolding
    with
    [`use_hta_unittests()`](https://validate-hta.github.io/testhta/reference/use_hta_unittests.md),
    and AI-assisted testing (`model-context.md`).
