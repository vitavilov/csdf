context("CSIXML")

Sys.setenv(TZ='GMT')
fpath <- system.file("extdata", "CSIXML_Station_Daily.dat", package="csdf")
fpath.toa5 <- system.file("extdata", "Station_Daily.dat", package="csdf")
obj <- read.csixml(fpath)

test_that("valid csdf object created", {
  expect_s4_class(obj, "csdf")
  expect_true(validObject(obj))
})

test_that("identical to source TOA5", {
  expect_output_file(write.toa5(obj), fpath.toa5)
})

test_that("written file is identical to original", {
  expect_output_file(write.csixml(obj), fpath)
})

test_that("Can write files", {
  f <- tempfile()
  on.exit(unlink(f))
  expect_null( write.csixml(obj, f) )
  expect_null( write.csixml(obj, file(f)) )
})
