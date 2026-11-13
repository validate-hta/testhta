test_that("use_hta_unittests generates test file with custom data_name in temp dir", {
  tmp_dir <- withr::local_tempdir()

  res <- use_hta_unittests(
    path = tmp_dir,
    filename = "test-custom.R",
    data_name = "my_model_data"
  )

  expect_true(res)
  target_file <- file.path(tmp_dir, "tests", "testthat", "test-custom.R")
  expect_true(file.exists(target_file))

  content <- readLines(target_file)
  expect_true(any(grepl("my_model_data", content)))
})

test_that("use_hta_unittests automatically prepends test- to filename", {
  tmp_dir <- withr::local_tempdir()

  expect_warning(
    use_hta_unittests(path = tmp_dir, filename = "custom.R"),
    "testthat expects test files to begin with 'test-'"
  )

  target_file <- file.path(tmp_dir, "tests", "testthat", "test-custom.R")
  expect_true(file.exists(target_file))
})

test_that("use_hta_unittests errors when file exists and overwrite is FALSE", {
  tmp_dir <- withr::local_tempdir()

  use_hta_unittests(path = tmp_dir, filename = "test-dup.R")

  expect_error(
    use_hta_unittests(path = tmp_dir, filename = "test-dup.R", overwrite = FALSE),
    "already exists"
  )
})
