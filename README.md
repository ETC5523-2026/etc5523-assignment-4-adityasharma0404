# melbairbnbexplore

## Overview
`melbairbnbexplore` is an R package deveeloped by Aditya Sharma, a student of Business Analytics at Monash University. It explores Melbourne Airbnb listing prices for **prospective hosts** who want to understand pricing by location and property type.

**Research Question:** How do location (Council Area / LGA) and property type affect nightly price in Melbourne?

**Important Data Note:** For Melbourne, InsideAirbnb provides `neighbourhood_cleansed` as **Local Government Area (LGA) / Council Area** (e.g., Banyule, Bayside, Stonnington, Glen Eira) rather than individual suburbs. This is documented in `R/data.R`, the vignette, and the Shiny app. We use LGA as our location proxy.

## Data

- **Source:** InsideAirbnb Melbourne 2026-09-16 (25k+ listings) - https://data.insideairbnb.com/australia/vic/melbourne/2026-09-16/data/listings.csv.gz
- **Raw:** `data-raw/listings.csv` (70MB, 90 columns) - gitignored via `.gitignore` to avoid GitHub large file error
- **Cleaning:** `data-raw/melb_airbnb_raw.R` creates `data/melb_airbnb.rda` with 5 relevant columns:
  - `neighbourhood` - LGA / Council Area (Banyule etc.)
  - `room_type` - Entire home/apt, Private room, Shared room
  - `price` - Cleaned from "$250.00" string to numeric, filtered >0 & <1000
  - `number_of_reviews`
  - `review_scores_rating`
- **Reproducibility:** Raw download and cleaning steps are fully documented in `data-raw/`

## Installation

You can install the development version from GitHub:

```r
# install.packages("pak")
pak::pak("ETC5523-2026/etc5523-assignment-4-adityasharma0404")
```

Or via devtools:

```r
# install.packages("devtools")
devtools::install_github("ETC5523-2026/etc5523-assignment-4-adityasharma0404")
```

## Usage

```r
library(melbairbnbexplore)

# View cleaned data
head(melb_airbnb)
dplyr::glimpse(melb_airbnb)

# Summarise prices by LGA and room type
summarise_prices(melb_airbnb)

# Launch interactive Shiny app
launch_app()
```

## Functions

- `summarise_prices(data)`: Returns a tibble with average price by `neighbourhood` (LGA) and `room_type`. Uses `.data$` pronoun and `utils::globalVariables()` to pass R CMD check 0-0-0.
- `launch_app()`: Launches Shiny app from `inst/app/app.R`. Includes fallback to `inst/app` when package is loaded via `devtools::load_all()`.

## Shiny App

Located in `inst/app/app.R`, launched via `launch_app()`.

Features:
- Filters: Council Area (LGA) multi-select, Room Type multi-select, Max Price slider
- Value boxes: Listings Found, Average Price, Top Council
- Interactive plot: `plotly` histogram with **aggregated bins** (stacked by room_type, Set2 palette). Hover shows true bin count and price bin, not individual tiny squares. Drag to zoom, double-click to reset.
- Summary table: Uses `summarise_prices()` on filtered data
- Insight: Explains why Shared Room can have higher average than Entire Home (rare luxury shared listings skew average, e.g., $225 shared in Bayside vs $98 entire in Banyule). Filter to single LGA for fair comparison.

## Vignette

`vignettes/melbairbnbexplore.qmd` (Quarto qmd, not Rmd) includes:
- Intended user and research question
- Data source and cleaning steps
- Function demo
- LGA note
- Shiny app usage
- Conclusion

Build with:
```r
quarto::quarto_render("vignettes/melbairbnbexplore.qmd")
```

## pkgdown Site

Site built with `pkgdown::build_home()` / `build_site()` and deployed via GitHub Pages (main branch /docs folder + `.nojekyll` file).

Live site: https://etc5523-2026.github.io/etc5523-assignment-4-adityasharma0404/

- `url` field fixed in both `DESCRIPTION` and `_pkgdown.yml`
- `docs/` folder is NOT gitignored (required for Pages)
- `vignettes/.quarto` and `.quarto` cache folders are gitignored to avoid hidden file NOTE and clock NOTE

## R CMD Check

```r
devtools::check() # 0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```

Fixes applied for NOTES:
- Hidden `vignettes/.quarto` folder deleted and gitignored
- `plotly` moved from Imports to Suggests (only used in app, not package R code)
- `utils::globalVariables()` in `R/globals.R` for `neighbourhood`, `room_type`, `price`, `avg_price`
- `R (>= 4.1.0)` added for native pipe `|>` syntax
- Future timestamp NOTE fixed by cleaning `docs/` and `.quarto` cache


## License

MIT + file LICENSE

## Developers

Aditya Sharma - Author, maintainer - asha0404@student.monash.edu

## AI Use Statement

I used Meta AI and for debugging help:

- Debugged `DATASET not found` error in data-raw script (file still said DATASET instead of melb_airbnb)
- Fixed `summarise_prices` not found and `VignetteBuilder quarto not declared` by adding `@export` and adding `quarto` to Suggests
- Fixed GitHub Pages build failing due to `docs` in `.gitignore` and missing `.nojekyll`
- Fixed plotly hover showing $99 for all properties 
- Helped draft README and vignette structure
