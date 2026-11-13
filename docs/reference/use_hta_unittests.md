# Generate Skeleton Unit Tests for HTA Models

Creates a `testthat` directory structure (if needed) and generates a
unit test script aligned with the HTA Verification Registry (`T01` -
`T12`). Automatically substitutes the baseline dataset reference
(`base_params`) with your specified model data object name.

## Usage

``` r
use_hta_unittests(
  path = ".",
  filename = "test-hta_model.R",
  data_name = "base_params",
  overwrite = FALSE
)
```

## Arguments

- path:

  A character string specifying the root project directory. Defaults to
  the current working directory (`"."`).

- filename:

  A character string for the test file name. Defaults to
  `"test-hta_model.R"`. Note: `testthat` requires file names to begin
  with `"test-"`.

- data_name:

  A character string specifying the variable name of your model's data
  object. Defaults to `"base_params"`.

- overwrite:

  A logical value indicating whether to overwrite an existing file if it
  already exists. Defaults to `FALSE`.

## Value

A logical value indicating whether the file was created successfully,
returned invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
# Generate default tests using 'base_params'
use_hta_unittests()

# Substitute 'base_params' with your custom model object name
use_hta_unittests(data_name = "my_oncology_model")
} # }
```
