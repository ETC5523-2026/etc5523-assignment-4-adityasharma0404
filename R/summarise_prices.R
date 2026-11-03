#' Summarise average prices by room type and neighbourhood
#' @param data A data frame, melb_airbnb
#' @return A tibble with average price
#' @export
summarise_prices <- function(data) {
  data |>
    dplyr::group_by(.data$neighbourhood, .data$room_type) |>
    dplyr::summarise(avg_price = mean(.data$price, na.rm = TRUE), .groups = "drop")
}
