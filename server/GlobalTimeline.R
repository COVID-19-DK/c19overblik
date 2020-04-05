
output$plot_GlobalTimeline <- highcharter::renderHighchart({
  
  show_x <- input$GT_show_x
  show_y <- input$GT_show_y
  country_select <- input$GT_country
  
  selected_countries <- landeliste[country %in% country_select]$`Timeline Code`
  
  GlobalTimeline <- GlobalTimeline[countrycode %in% selected_countries]
  GlobalTimeline <- 
    merge(GlobalTimeline,
          landeliste[, .(countrycode = `Timeline Code`, countrylabel = country)],
          all.x = TRUE,
          sort = FALSE)
  
  if(show_x == "date") GlobalTimeline[, x := date]
  if(show_x == "day_infected"){
    GlobalTimeline <- GlobalTimeline[!is.na(totalcases)]
    setorder(GlobalTimeline, countrylabel, date)
    GlobalTimeline[, x := rowid(countrylabel)]
  }
  if(show_x == "day_dead"){
    GlobalTimeline <- GlobalTimeline[!is.na(totaldeaths)]
    setorder(GlobalTimeline, countrylabel, date)
    GlobalTimeline[, x := rowid(countrylabel)]
  }
  
  if(show_y == "infected"){
    GlobalTimeline <- remove_repeatedRow(GlobalTimeline, "totalcases", "countrylabel")
    GlobalTimeline[, y := totalcases]
  }
  if(show_y == "dead"){
    GlobalTimeline <- remove_repeatedRow(GlobalTimeline, "totaldeaths", "countrylabel")
    GlobalTimeline[, y := totaldeaths]
  }
  if(show_y == "recovered"){
    GlobalTimeline <- remove_repeatedRow(GlobalTimeline, "totalrecovered", "countrylabel")
    GlobalTimeline[, y := totalrecovered] 
  }
  
  y_tootltip <- switch(show_y, infected = "Antal registrede smittede", dead = "Antal døde", recovered = "Antal raske")
  x_tootltip <- switch(show_x, date = "Den {point.dato}", day_infected = "{point.x} dage siden første registerede smittede", day_dead = "{point.x} dage siden første dødsfald")
  
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
                  mapping = hcaes(x = x, y = y, group = countrylabel, dato = format(date, "%d-%m-%y")))
  # hc_add_series(data = GlobalTimeline,
  #                 type = "line",
  #                 mapping = hcaes(x = x, y = y, group = countrylabel, dato = format(date, "%d-%m-%y"), infected = totalcases, dead = totaldeaths, recovered = totalrecovered))
  
  if(show_x == "date") hc_plot <- hc_xAxis(hc_plot, type = "datetime")
  
  hc_plot
  
})
