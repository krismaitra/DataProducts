library(shiny)
library(datasets)
library(plotly)
shinyUI(fluidPage(
  titlePanel("Predict Car Fuel Economy (MPG) from horsepower, weight and transmission type"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("sliderHP", "What is the horse-power of the car?", 
                  min = round(min(mtcars$hp), -1), max = round(max(mtcars$hp), -1), value = min(mtcars$hp),
                  step = 1), 
      sliderInput("sliderWT", "What is the weight of the car (in 1000 lbs.)?", 
                  min = floor(min(mtcars$wt)), max = ceiling(max(mtcars$wt)), value = min(mtcars$wt), 
                  step = 0.001), 
      selectInput("am", "Transmission:",
                  c("Automatic" = "0",
                    "Manual" = "1")),
      submitButton("Submit")
    ),
    mainPanel(
      plotlyOutput("plot1"),
      h3("Predicted miles per gallon (mpg):"),
      textOutput("pred")
    )
  )
))