#' Launch Shiny App
#' @export
launch_app <- function() {
  appDir <- system.file("app", package = "melbairbnbexplore")
  # for dev with load_all() where system.file is empty
  if (appDir == "") {
    appDir <- "inst/app"
  }
  shiny::runApp(appDir)
}