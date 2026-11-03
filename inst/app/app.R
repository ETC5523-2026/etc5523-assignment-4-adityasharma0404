library(shiny)
library(bslib)
library(dplyr)
library(plotly)
library(melbairbnbexplore)
ui <- page_sidebar(
  theme = bs_theme(bootswatch = "flatly"),
  title = "Melbourne Airbnb Price Explorer - Find Your Hosting Sweet Spot",
  sidebar = sidebar(
    h5("Filter Listings"),
    selectInput("neigh", "Choose Council Area (LGA)", 
                choices = sort(unique(melb_airbnb$neighbourhood)), 
                selected = c("Banyule","Bayside"), multiple = TRUE),
    selectInput("type", "Room Type", 
                choices = unique(melb_airbnb$room_type), 
                selected = unique(melb_airbnb$room_type), multiple = TRUE),
    sliderInput("price", "Max Price (AUD)", min=0, max=1000, value=700, step=50),
    hr(),
    helpText("Note: Melbourne data uses Council/LGA (Banyule, Bayside etc.) not individual suburbs."),
    helpText("Tip: Hover shows true bin count, drag to zoom, double-click to reset!")
  ),
  layout_columns(
    value_box(title="Listings Found", value=textOutput("count"), showcase=icon("house")),
    value_box(title="Avg Price", value=textOutput("avgPrice"), showcase=icon("dollar")),
    value_box(title="Top Council", value=textOutput("topSub"), showcase=icon("map-pin"))
  ),
  card(
    card_header("Interactive Price Distribution - What Can You Charge?"),
    plotlyOutput("pricePlot")
  ),
  card(
    card_header("Price Summary by Council Area & Room Type"),
    tableOutput("summaryTable")
  ),
  card(
    card_header("Data Insight"),
    p("Why can Shared Room avg > Entire Home? Shared rooms are only 1% of data. One luxury shared room at $225 in Bayside can push its avg above a cheap entire home at $98 in Banyule. Filter to one Council to compare fairly. Council names are used because InsideAirbnb Melbourne provides LGA not suburb.")
  )
)
server <- function(input, output, session) {
  filtered <- reactive({
    melb_airbnb |>
      filter(neighbourhood %in% input$neigh,
             room_type %in% input$type,
             price <= input$price)
  })
  output$count <- renderText({ nrow(filtered()) })
  output$avgPrice <- renderText({ paste0("$", round(mean(filtered()$price, na.rm=TRUE),1)) })
  output$topSub <- renderText({
    req(nrow(filtered())>0)
    filtered() |> count(neighbourhood, sort=TRUE) |> slice(1) |> pull(neighbourhood)
  })
  output$pricePlot <- renderPlotly({
    req(nrow(filtered())>0)
    plot_ly(filtered(), x=~price, color=~room_type, colors="Set2",
            type="histogram", nbinsx=30, alpha=0.85,
            hovertemplate="Room: %{fullData.name}<br>Price Bin: $%{x}<br>Listings in bin: %{y}<extra></extra>") |>
      layout(
        xaxis=list(title="Nightly Price (AUD) - Your Earning Potential"),
        yaxis=list(title="Number of Listings"),
        barmode="stack",
        hovermode="x unified"
      )
  })
  output$summaryTable <- renderTable({
    summarise_prices(filtered())
  })
}
shinyApp(ui, server)
