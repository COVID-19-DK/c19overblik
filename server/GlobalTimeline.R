
output$plot_GlobalTimeline <- highcharter::renderHighchart({
  
  show_y <- input$GT_show_y
  show_y2 <- input$GT_show_y2
  show_x <- input$GT_show_x
  country_select <- input$GT_country
  
  y_val <- switch(show_y, infected = "confirmed", dead = "deaths", recovered = "recovered")
  if(show_y2 == "100k") y_val <- paste0(y_val, "_100k")
  
  GlobalTimeline <- tidycovid19[country %in% country_select]

  if(show_x == "date") GlobalTimeline[, x := date]
  if(show_x == "day_infected"){
    GlobalTimeline <- GlobalTimeline[!is.na(confirmed) & confirmed >= 1000]
    setorder(GlobalTimeline, country, date)
    GlobalTimeline[, x := rowid(country)]
  }
  if(show_x == "day_dead"){
    GlobalTimeline <- GlobalTimeline[!is.na(deaths) & deaths >= 10]
    setorder(GlobalTimeline, country, date)
    GlobalTimeline[, x := rowid(country)]
  }
  
  GlobalTimeline <- remove_repeatedRow(GlobalTimeline, y_val, "country")
  GlobalTimeline[, y := round(get(y_val))]
  
  y_tootltip <- switch(show_y, infected = "Antal registrede smittede", dead = "Antal døde", recovered = "Antal raske")
  if(show_y2 == "100k") y_tootltip <- paste0(y_tootltip, " per 100.000")
  
  x_tootltip <- switch(show_x, date = "Den {point.dato}", day_infected = "{point.x} dage siden nr. 1000 smittede", day_dead = "{point.x} dage siden 10. dødsfald")
  
  hc_plot <- 
    highchart() %>%
    hc_add_theme(hc_theme_elementary()) %>%
    hc_exporting(enabled = TRUE, filename = "c19overblik_GlobalTidslinje") %>%
    hc_tooltip(shared = TRUE,
               headerFormat = paste0("<b>", y_tootltip, "</b><br/>", x_tootltip, "<br/>")) %>%
  # hc_tooltip(headerFormat = "",
    #            pointFormat = paste0(
    #              "<b>{series.name}</b><br/>
    #                            Dato: {point.dato}<br/>
    #                            ", x_tootltip, "
    #                            Antal registrede smittede: {point.infected}<br/>
    #                            Antal døde: {point.dead}<br/>
    #                            Antal raske: {point.recovered}<br/>")) %>%
    hc_add_series(data = GlobalTimeline,
                  type = "line",
                  mapping = hcaes(x = x, y = y, group = country, dato = format(date, "%d-%m-%y")))

  if(show_x == "date") hc_plot <- hc_xAxis(hc_plot, type = "datetime")
  
  hc_plot
  
})
