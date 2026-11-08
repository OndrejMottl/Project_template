#----------------------------------------------------------#
# Inputs -----
#----------------------------------------------------------#

testthat::test_that("save_package_dependencies_manifest() checks names", {
  path_output <-
    withr::local_tempfile(fileext = ".R")

  testthat::expect_error(
    save_package_dependencies_manifest(
      vec_package_names = base::character(0),
      path_output_file = path_output
    ),
    regexp = "vec_package_names"
  )

  testthat::expect_error(
    save_package_dependencies_manifest(
      vec_package_names = c("here", NA_character_),
      path_output_file = path_output
    ),
    regexp = "vec_package_names"
  )

  testthat::expect_error(
    save_package_dependencies_manifest(
      vec_package_names = c("here", "1abc", "bad name"),
      path_output_file = path_output
    ),
    regexp = "Invalid package name"
  )
})

testthat::test_that("save_package_dependencies_manifest() checks the path", {
  testthat::expect_error(
    save_package_dependencies_manifest(
      vec_package_names = "here",
      path_output_file = base::file.path(
        base::tempdir(),
        "missing_folder",
        "package_dependencies.R"
      )
    ),
    regexp = "does not exist"
  )

  testthat::expect_error(
    save_package_dependencies_manifest(
      vec_package_names = "here",
      path_output_file = c("a.R", "b.R")
    ),
    regexp = "path_output_file"
  )
})


#----------------------------------------------------------#
# Outputs and side effects -----
#----------------------------------------------------------#

testthat::test_that("save_package_dependencies_manifest() writes calls", {
  path_output <-
    withr::local_tempfile(fileext = ".R")

  res <-
    save_package_dependencies_manifest(
      vec_package_names = c("here", "targets", "here"),
      path_output_file = path_output
    )

  vec_lines <-
    base::readLines(con = path_output)

  testthat::expect_true(res)

  testthat::expect_true(base::any(vec_lines == "  library(here)"))

  testthat::expect_true(base::any(vec_lines == "  library(targets)"))

  testthat::expect_equal(
    base::sum(vec_lines == "  library(here)"),
    1L
  )
})

testthat::test_that("save_package_dependencies_manifest() skips no-ops", {
  path_output <-
    withr::local_tempfile(fileext = ".R")

  res_first <-
    save_package_dependencies_manifest(
      vec_package_names = c("here", "targets"),
      path_output_file = path_output
    )

  res_second <-
    save_package_dependencies_manifest(
      vec_package_names = c("here", "targets"),
      path_output_file = path_output
    )

  testthat::expect_true(res_first)

  testthat::expect_false(res_second)
})

testthat::test_that("save_package_dependencies_manifest() never attaches", {
  path_output <-
    withr::local_tempfile(fileext = ".R")

  save_package_dependencies_manifest(
    vec_package_names = "tools",
    path_output_file = path_output
  )

  vec_search_before <-
    base::search()

  base::source(
    file = path_output,
    local = base::new.env()
  )

  testthat::expect_identical(base::search(), vec_search_before)
})
