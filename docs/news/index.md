# Changelog

## testhta 0.1.0

- First release of the `testhta` validation framework for
  cost-effectiveness models in R.

### New Features

- Added getters to retrieve cohort simulation metrics:
  - [`get_costs()`](https://n8thangreen.github.io/testhta/reference/get_costs.md):
    Retrieve total discounted costs.
  - [`get_icer()`](https://n8thangreen.github.io/testhta/reference/get_icer.md):
    Calculate Incremental Cost-Effectiveness Ratio.
  - [`get_le()`](https://n8thangreen.github.io/testhta/reference/get_le.md):
    Retrieve total Life Expectancy.
  - [`get_qalys()`](https://n8thangreen.github.io/testhta/reference/get_qalys.md):
    Retrieve total discounted Quality-Adjusted Life Years.
- Added piping-compatible setters to dynamically override model
  parameters:
  - [`set_costs()`](https://n8thangreen.github.io/testhta/reference/set_costs.md):
    Modify state-occupancy costs.
  - [`set_discount_rate()`](https://n8thangreen.github.io/testhta/reference/set_discount_rate.md):
    Modify model discount rates.
  - [`set_p_matrix()`](https://n8thangreen.github.io/testhta/reference/set_p_matrix.md):
    Modify transition probability arrays.
  - [`set_time_horizon()`](https://n8thangreen.github.io/testhta/reference/set_time_horizon.md):
    Modify simulation time horizon.
  - [`set_utilities()`](https://n8thangreen.github.io/testhta/reference/set_utilities.md):
    Modify state-specific utilities.

### Testing & Validation Helpers

- Added validation test helper assertions for use with the `testthat`
  package:
  - [`check_model_costs()`](https://n8thangreen.github.io/testhta/reference/check_model_costs.md):
    Assert expected costs under bounding conditions.
  - [`check_model_le()`](https://n8thangreen.github.io/testhta/reference/check_model_le.md):
    Assert expected life expectancy under bounding conditions.
  - [`check_model_qalys()`](https://n8thangreen.github.io/testhta/reference/check_model_qalys.md):
    Assert expected QALYs under bounding conditions.
  - [`compare_model_runs()`](https://n8thangreen.github.io/testhta/reference/compare_model_runs.md):
    Assert directional and logical relationships between two model
    parameter configurations.
  - [`run_model()`](https://n8thangreen.github.io/testhta/reference/run_model.md):
    Core parameter-override wrapper for execution of the underlying
    Markov engine.

### Documentation & Infrastructure

- Created a professional `pkgdown` documentation website using the
  Bootstrap 5 `flatly` Bootswatch theme.
- Added comprehensive documentation website search index.
- Added a stylized hexagon logo (`man/figures/logo.png`).
- Added two introductory and guide vignettes:
  - `introduction`: Setup, execute, and inspect Markov
    cost-effectiveness models.
  - `validation-guide`: How to design and run unit tests to verify model
    logic under boundaries.
- Overhauled package metadata (DESCRIPTION, URLs, BugReports, and
  License).
