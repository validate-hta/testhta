# testhta 0.1.0

- First release of the `testhta` validation framework for cost-effectiveness models in R.

## New Features

- Added getters to retrieve cohort simulation metrics:
  - `get_costs()`: Retrieve total discounted costs.
  - `get_icer()`: Calculate Incremental Cost-Effectiveness Ratio.
  - `get_le()`: Retrieve total Life Expectancy.
  - `get_qalys()`: Retrieve total discounted Quality-Adjusted Life Years.
- Added piping-compatible setters to dynamically override model parameters:
  - `set_costs()`: Modify state-occupancy costs.
  - `set_discount_rate()`: Modify model discount rates.
  - `set_p_matrix()`: Modify transition probability arrays.
  - `set_time_horizon()`: Modify simulation time horizon.
  - `set_utilities()`: Modify state-specific utilities.

## Testing & Validation Helpers

- Added validation test helper assertions for use with the `testthat` package:
  - `check_model_costs()`: Assert expected costs under bounding conditions.
  - `check_model_le()`: Assert expected life expectancy under bounding conditions.
  - `check_model_qalys()`: Assert expected QALYs under bounding conditions.
  - `compare_model_runs()`: Assert directional and logical relationships between two model parameter configurations.
  - `run_model()`: Core parameter-override wrapper for execution of the underlying Markov engine.

## Documentation & Infrastructure

- Created a professional `pkgdown` documentation website using the Bootstrap 5 `flatly` Bootswatch theme.
- Added comprehensive documentation website search index.
- Added a stylized hexagon logo (`man/figures/logo.png`).
- Added two introductory and guide vignettes:
  - `introduction`: Setup, execute, and inspect Markov cost-effectiveness models.
  - `validation-guide`: How to design and run unit tests to verify model logic under boundaries.
- Overhauled package metadata (DESCRIPTION, URLs, BugReports, and License).
