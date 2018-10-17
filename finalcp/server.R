library(shiny)
library(datasets)
library(plotly)
library(dplyr)
shinyServer(function(input, output){
  fit <- lm(mpg ~  factor(am) + wt + hp, data = mtcars)
  labs <- c("Horsepower", "Weight (in 1000 lbs.)", "Miles per Gallon")

  minhp <- round(min(mtcars$hp), -1)
  maxhp <- round(max(mtcars$hp), -1)
  minwt <- floor(min(mtcars$wt))
  maxwt <- ceiling(max(mtcars$wt))
  
  pred <- reactive({
    hpInput <- input$sliderHP
    wtInput <- input$sliderWT
    amInput <- factor(input$am)
    p <- predict(fit, newdata = data.frame(
      hp = hpInput, wt = wtInput, am  = amInput))
    inputPred <- data.frame(hp = hpInput, wt = wtInput, mpg = p)
    inputPred
  })

  planePoints <- reactive({
    amInput <- factor(input$am)
    df <- data.frame(
      hp = c(array(rep(minhp, 5)),
             seq(minhp, maxhp, length.out = 5),
             array(rep(maxhp, 5)),
             seq(maxhp, minhp, length.out = 5)
),
      wt = c(seq(minwt, maxwt, length.out = 5),
             array(rep(maxwt, 5)),
             seq(maxwt, minwt, length.out = 5),
             array(rep(minwt, 5))
),
      am = array(rep(amInput, 20))
    )
    rplane <- predict(fit, newdata = df)
    df <- df[, c("hp", "wt")]
    df$mpg <- rplane
    df
  })
  

  
  output$plot1 <- renderPlotly({
    pl <- planePoints()
    p <- pred()
    plot_ly(mtcars) %>% 
      add_trace(x = ~hp[am==0], y = ~wt[am==0], z = ~mpg[am==0],  
            color = I("blue"), size = ~1,
            type = "scatter3d", mode = "markers", name = "Automatic") %>%
      layout(scene = list(xaxis = list(title = "Horsepower"), 
             yaxis = list(title = "Weight in 1000 lbs."), 
             zaxis = list(title = "Miles per Gallon, mpg"),
             camera = list(eye = list(x = -1.25, y = 1.25, z = 1.25)))) %>%
      add_trace(x = ~hp[am==1], y = ~wt[am==1], z = ~mpg[am==1],  
                color = I("green"), size = ~1,
                type = "scatter3d", mode = "markers", name = "Manual") %>%
      add_trace(x = pl$hp, y = pl$wt, z = pl$mpg,
                type = "scatter3d",
                mode = "lines", 
                color = I("black"), 
                surfacecolor = I("cyan"),
                opacity = 0.3,
                surfaceaxis = 1,
                name = "Regression plane") %>%
#      add_trace(x = pl$hp, y = pl$wt, z = ~pl$mpg,
#                type = "surface", name = "Regression plane") %>%
      add_trace(x = p$hp, y = p$wt, z = p$mpg,
                color = I("red"), 
                type = "scatter3d", mode = "markers", 
                marker = list(symbol = "cross"),
                name = "Predicted")

    
  })
  output$pred <- renderText({
    pred()$mpg
  })
})