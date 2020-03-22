
# Load GlobalTimeline data
GlobalTimeline <- get_GlobalTimeline()

output$plot_GlobalTimeline <- highcharter::renderHighchart({
  
  show_x <- input$GT_show_x
  show_y <- input$GT_show_y
  country <- input$GT_country
  
  GlobalTimeline <- GlobalTimeline[countrylabel %in% country]
  
  if(show_x == "date") GlobalTimeline[, x := date]
  if(show_x == "infected"){
    GlobalTimeline <- GlobalTimeline[!is.na(totalcases)]
    setorder(GlobalTimeline, countrylabel, date)
    GlobalTimeline[, x := rowid(countrylabel)]
  }
  if(show_x == "dead"){
    GlobalTimeline <- GlobalTimeline[!is.na(totaldeaths)]
    setorder(GlobalTimeline, countrylabel, date)
    GlobalTimeline[, x := rowid(countrylabel)]
  }
  
  if(show_y == "infected") GlobalTimeline[, y := totalcases]
  if(show_y == "dead") GlobalTimeline[, y := totaldeaths]
  if(show_y == "recovered") GlobalTimeline[, y := totalrecovered]
  
  x_tootltip <- switch(show_x, date = "", infected = "{point.x} dage siden første registerede smittede<br/>", dead = "{point.x} dage siden første dødsfald<br/>")
  
  hc_plot <- 
    highchart() %>%
    hc_add_theme(hc_theme_elementary()) %>%
    hc_exporting(enabled = TRUE, filename = "c19overblik_GlobalTidslinje") %>%
    hc_tooltip(headerFormat = "",
               pointFormat = paste0(
                 "<b>{series.name}</b><br/>
                               Dato: {point.dato}<br/>
                               ", x_tootltip, "
                               Antal registrede smittede: {point.infected}<br/>
                               Antal døde: {point.dead}<br/>
                               Antal raske: {point.recovered}<br/>")) %>%
    hc_add_series(data = GlobalTimeline,
                  type = "line",
                  mapping = hcaes(x = x, y = y, group = countrylabel, dato = format(date, "%d-%m-%y"), infected = totalcases, dead = totaldeaths, recovered = totalrecovered))
  
  if(show_x == "date") hc_plot <- hc_xAxis(hc_plot, type = "datetime")
  
  hc_plot
  
})
