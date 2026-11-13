#' Generate Skeleton Unit Tests for HTA Models
#'
#' @description
#' Creates a `testthat` directory structure (if needed) and generates a unit
#' test script aligned with the HTA Verification Registry (`T01` - `T12`).
#' Automatically substitutes the baseline dataset reference (`base_params`)
#' with your specified model data object name.
#'
#' @param path A character string specifying the root project directory.
#'   Defaults to the current working directory (`"."`).
#' @param filename A character string for the test file name.
#'   Defaults to `"test-hta_model.R"`. Note: `testthat` requires file names to
#'   begin with `"test-"`.
#' @param data_name A character string specifying the variable name of your
#'   model's data object. Defaults to `"base_params"`.
#' @param overwrite A logical value indicating whether to overwrite an existing
#'   file if it already exists. Defaults to `FALSE`.
#'
#' @return A logical value indicating whether the file was created
#'   successfully, returned invisibly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Generate default tests using 'base_params'
#' use_hta_unittests()
#'
#' # Substitute 'base_params' with your custom model object name
#' use_hta_unittests(data_name = "my_oncology_model")
#' }
use_hta_unittests <- function(path = ".",
                              filename = "test-hta_model.R",
                              data_name = "base_params",
                              overwrite = FALSE) {
  # Enforce testthat naming conventions
  if (!grepl("^test-", filename)) {
    warning(
      "testthat expects test files to begin with 'test-'. ",
      "Prepending 'test-' to filename."
    )
    filename <- paste0("test-", filename)
  }

  # Locate template within the installed package
  template_path <- system.file(
    "templates",
    "test_model_skeleton.R",
    package = "testhta"
  )

  if (template_path == "") {
    stop(
      "Template not found. ",
      "Please ensure the 'testhta' package is installed correctly."
    )
  }

  # Ensure the target directory structure exists
  test_dir <- file.path(path, "tests", "testthat")
  if (!dir.exists(test_dir)) {
    dir.create(test_dir, recursive = TRUE)
    message(sprintf("Created directory structure: '%s'", test_dir))
  }

  dest_path <- file.path(test_dir, filename)

  # Safeguard against accidental overwrites
  if (file.exists(dest_path) && !overwrite) {
    stop(sprintf(
      paste0(
        "A test file named '%s' already exists in '%s'. ",
        "Set `overwrite = TRUE` to replace it."
      ),
      filename,
      test_dir
    ))
  }

  # Read template and substitute dataset references
  template_lines <- readLines(template_path, warn = FALSE)
  modified_lines <- gsub(
    "\\bbase_params\\b(?!\\s*=)",
    data_name,
    template_lines,
    perl = TRUE
  )

  # Write the customized file
  writeLines(modified_lines, con = dest_path)

  success <- file.exists(dest_path)

  if (success) {
    message(sprintf(
      paste0(
        "v Successfully created '%s' in '%s'.\n",
        "* All test functions pre-configured for object: '%s'."
      ),
      filename,
      test_dir,
      data_name
    ))
  } else {
    warning("Failed to write the test script.")
  }

  invisible(success)
}
