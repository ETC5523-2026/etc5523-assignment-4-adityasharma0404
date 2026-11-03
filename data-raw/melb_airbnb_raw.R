library(readr)
library(dplyr)
library(janitor)

raw <- read_csv("data-raw/listings.csv") |> clean_names()

melb_airbnb <- raw |>
  mutate(neighbourhood = neighbourhood_cleansed) |>
  select(neighbourhood, room_type, price, number_of_reviews, review_scores_rating) |>
  mutate(price = as.numeric(gsub("\\$|,", "", price))) |>
  filter(!is.na(price), price > 0, price < 1000, !is.na(neighbourhood))

usethis::use_data(melb_airbnb, overwrite = TRUE)
