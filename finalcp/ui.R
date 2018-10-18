library(shiny)
library(datasets)
library(plotly)
shinyUI(fluidPage(
  titlePanel("Car fuel economy predictor"),
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
      plotlyOutput("plot1")
    )
  ),
  fluidRow(
    column(4,
           h3("Predicted miles per gallon (mpg):")
    ),
    column(4,
          h3( textOutput("pred"))
    )
  ),
  fluidRow(
    column(12,
      h3(""),
      h4("How to use this application"),
      p("This Shiny app predicts Car Fuel Economy given by miles per gallon (MPG) 
        from horsepower, weight and transmission type. In the app interface, 
        please select the sliders to select the horsepower and the weight of the car 
        and select the transmission type of the car using the dropdown and click Submit."),
      p("The app shows some initial parameter values and outcomes at the time
        it gets loaded. The parameters can be changed according to the details
        above and the prediction for a new set of inputs are shown at the runtime.
        To see the 3D plot, you must have a browser that supports 3D plots.
        Also, the application takes a few seconds to show the output, 
        so please be patient with it.")
    )
  )
))