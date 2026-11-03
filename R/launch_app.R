#' Launch Shiny App
#' @export
launch_app <- function() {
  appDir <- system.file("app", package = "melbairbnbexplore")
  if (appDir == "") appDir <- "inst/app"
  shiny::runApp(appDir)
}
