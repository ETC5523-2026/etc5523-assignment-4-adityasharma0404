#' Launch Shiny App
#' @export
launch_app <- function() {
  shiny::runApp(system.file("app", package = "melbairbnbexplore"))
}