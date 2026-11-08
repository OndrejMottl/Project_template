#----------------------------------------------------------#
# Inputs -----
#----------------------------------------------------------#

testthat::test_that("resolve_data_storage_path() validates `path_default`", {
  dir_project <-
    withr::local_tempdir()

  testthat::expect_error(
    resolve_data_storage_path(
      path_default = 1,
      path_secrets = base::file.path(dir_project, "secrets.yaml"),
      path_project = dir_project
    ),
    regexp = "path_default"
  )

  testthat::expect_error(
    resolve_data_storage_path(
      path_default = NA_character_,
      path_secrets = base::file.path(dir_project, "secrets.yaml"),
      path_project = dir_project
    ),
    regexp = "path_default"
  )

  testthat::expect_error(
    resolve_data_storage_path(
      path_default = "",
      path_secrets = base::file.path(dir_project, "secrets.yaml"),
      path_project = dir_project
    ),
    regexp = "path_default"
  )
})

testthat::test_that("resolve_data_storage_path() rejects a bad secrets entry", {
  dir_project <-
    withr::local_tempdir()

  path_secrets <-
    base::file.path(dir_project, "secrets.yaml")

  base::writeLines(
    text = "Data: 5",
    con = path_secrets
  )

  testthat::expect_error(
    resolve_data_storage_path(
      path_default = "Data",
      path_secrets = path_secrets,
      path_project = dir_project
    ),
    regexp = "Data"
  )
})


#----------------------------------------------------------#
# Outputs and functionality -----
#----------------------------------------------------------#

testthat::test_that("resolve_data_storage_path() uses the default", {
  dir_project <-
    withr::local_tempdir()

  res <-
    resolve_data_storage_path(
      path_default = "Data",
      path_secrets = base::file.path(dir_project, "secrets.yaml"),
      path_project = dir_project
    )

  testthat::expect_type(res, "character")

  testthat::expect_length(res, 1L)

  testthat::expect_equal(
    res,
    base::file.path(dir_project, "Data")
  )
})

testthat::test_that("resolve_data_storage_path() prefers secrets.yaml", {
  dir_project <-
    withr::local_tempdir()

  path_secrets <-
    base::file.path(dir_project, "secrets.yaml")

  base::writeLines(
    text = "Data: \"D:/Shared/Project_data\"",
    con = path_secrets
  )

  res <-
    resolve_data_storage_path(
      path_default = "Data",
      path_secrets = path_secrets,
      path_project = dir_project
    )

  testthat::expect_equal(res, "D:/Shared/Project_data")
})


#----------------------------------------------------------#
# Edge cases -----
#----------------------------------------------------------#

testthat::test_that("resolve_data_storage_path() ignores secrets w/o Data", {
  dir_project <-
    withr::local_tempdir()

  path_secrets <-
    base::file.path(dir_project, "secrets.yaml")

  base::writeLines(
    text = "Other: \"value\"",
    con = path_secrets
  )

  res <-
    resolve_data_storage_path(
      path_default = "Data",
      path_secrets = path_secrets,
      path_project = dir_project
    )

  testthat::expect_equal(
    res,
    base::file.path(dir_project, "Data")
  )
})

testthat::test_that("resolve_data_storage_path() expands a home path", {
  dir_project <-
    withr::local_tempdir()

  res <-
    resolve_data_storage_path(
      path_default = "~/Project_data",
      path_secrets = base::file.path(dir_project, "secrets.yaml"),
      path_project = dir_project
    )

  testthat::expect_equal(res, base::path.expand("~/Project_data"))
})

testthat::test_that("resolve_data_storage_path() keeps UNC secrets paths", {
  dir_project <-
    withr::local_tempdir()

  path_secrets <-
    base::file.path(dir_project, "secrets.yaml")

  base::writeLines(
    text = "Data: '\\\\server\\share\\data'",
    con = path_secrets
  )

  res <-
    resolve_data_storage_path(
      path_default = "Data",
      path_secrets = path_secrets,
      path_project = dir_project
    )

  testthat::expect_equal(res, "\\\\server\\share\\data")
})

testthat::test_that("resolve_data_storage_path() keeps an absolute default", {
  dir_project <-
    withr::local_tempdir()

  res <-
    resolve_data_storage_path(
      path_default = "D:/Elsewhere/Data",
      path_secrets = base::file.path(dir_project, "secrets.yaml"),
      path_project = dir_project
    )

  testthat::expect_equal(res, "D:/Elsewhere/Data")
})
