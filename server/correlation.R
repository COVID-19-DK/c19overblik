
output$plot_correlation <- renderPlotly({
  
  correlation_x <- input$correlation_x
  correlation_y <- input$correlation_y
  correlation_size <- input$correlation_size
  correlation_date <- input$correlation_date
  
  correlationData <- tidycovid19[date == correlation_date]
  correlationData <- unique(correlationData, by = "iso3c")
  
  correlationData <- correlationData[!is.na(get(correlation_x)) | get(correlation_x) != 0]
  correlationData <- correlationData[!is.na(get(correlation_y)) | get(correlation_y) != 0]
  
  xlist <- list(
    title = names(correlation_list[correlation_list == correlation_x])
  )
  
  ylist <- list(
    title = names(correlation_list[correlation_list == correlation_y])
  )
  
  plot_ly(
    data = correlationData,
    x = ~get(correlation_x),
    y = ~get(correlation_y),
    size = ~get(correlation_size),
    text = ~country) %>%
    layout(xaxis = xlist,
           yaxis = ylist)
  
  
})

