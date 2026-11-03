#' Melbourne Airbnb Listings
#'
#' Cleaned Airbnb data for Melbourne from InsideAirbnb (16 Sep 2026)
#' for prospective hosts.
#'
#' @format A tibble with 5 columns:
#' \describe{
#'   \item{neighbourhood}{Suburb / neighbourhood}
#'   \item{room_type}{Entire home, Private room, etc.}
#'   \item{price}{Nightly price in AUD}
#'   \item{number_of_reviews}{Number of reviews}
#'   \item{review_scores_rating}{Rating score}
#' }
#' @source \url{https://data.insideairbnb.com/australia/vic/melbourne/2026-09-16/data/listings.csv.gz}
"melb_airbnb"
