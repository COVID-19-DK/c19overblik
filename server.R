function(input, output) {

    output$plot_GlobalTimeline <- highcharter::renderHighchart({
        
        show_x <- input$show_x
        show_y <- input$show_y
        
        shiny::withProgress(message = "Henter data...", value = NULL, {
            
            GlobalTimeline <- copy(get_GlobalTimeline())
            
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
            
            highchart() %>% 
                hc_add_theme(hc_theme_elementary()) %>%
                hc_tooltip(headerFormat = "",
                           pointFormat = "<b>{series.name}</b><br/>Antal registrede smittede: {point.infected}<br/>Antal døde: {point.dead}<br/>Antal raske: {point.recovered}<br/>") %>%
                hc_add_series(data = GlobalTimeline,
                              type = "line",
                              mapping = hcaes(x = x, y = y, group = countrylabel, infected = totalcases, dead = totaldeaths, recovered = totalrecovered))
            
            
        })
        
        
        
    })
}