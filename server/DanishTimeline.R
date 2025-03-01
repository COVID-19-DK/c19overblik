
output$plot_DanishTimeline <- highcharter::renderHighchart({
  
  show_y1 <- input$DT_show_y1
  show_y2 <- input$DT_show_y2
  
  colors <- colorspace::qualitative_hcl(5, palette = "Dark 3")
  
  if(!("cases" %in% show_y2)) DanishTimeline <- DanishTimeline[!is.na(hospitalized_total)]
  if(!("total" %in% show_y2)) DanishTimeline <- DanishTimeline[!is.na(cases_total)]
  
  hc_plot <- 
    highchart() %>%
    hc_add_theme(hc_theme_elementary()) %>%
    hc_exporting(enabled = TRUE, filename = "c19overblik_DanskTidslinje") %>%
    hc_xAxis(type = "datetime"
             # plotLines = list(list(
             #   value = mean(DanishTimeline$timestamp),
             #   color = '#ff0000',
             #   width = 3,
             #   zIndex = 4,
             #   label = list(text = "mean",
             #                style = list( color = '#ff0000', fontWeight = 'bold' )
             #   )))
             # plotBands = list(
             #   from = as.Date("2020-03-20"),
             #   to = as.Date("2020-04-05"),
             #   color = "#000000")
             ) %>%
    hc_plotOptions(column = list(stacking = "normal")) %>%
    hc_tooltip(shared = TRUE,
               headerFormat = "<span style=\"font-size: 12px\">{point.key}</span><br/>")
  
  if("total" %in% show_y2 & "hospitalized" %in% show_y1){
    hc_plot <- 
      hc_plot %>%
      hc_add_series(data = DanishTimeline, color = colors[1],
                    name = "Indlagte ialt", type = "line",
                    mapping = hcaes(x = timestamp, y = hospitalized_total)) %>%
      hc_add_series(data = DanishTimeline, color = colors[2],
                    name = "Intensiv indlagte ialt", type = "line",
                    mapping = hcaes(x = timestamp, y = critical_total)) %>%
      hc_add_series(data = DanishTimeline, color = colors[3],
                    name = "Intensiv indlagte i respirator ialt", type = "line",
                    mapping = hcaes(x = timestamp, y = respirator_total))
  }
  
  if("total" %in% show_y2 & "cases" %in% show_y1){
    hc_plot <- 
      hc_plot %>%
      hc_add_series(data = DanishTimeline, color = colors[4],
                    name = "Registrede smittede ialt", type = "line",
                    mapping = hcaes(x = timestamp, y = cases_total)) %>%
      hc_add_series(data = DanishTimeline, color = colors[5],
                    name = "Testede ialt", type = "line",
                    mapping = hcaes(x = timestamp, y = tests_total))
  }
  
  if("daily" %in% show_y2 & "hospitalized" %in% show_y1){
    hc_plot <- 
      hc_plot %>%
      hc_add_series(data = DanishTimeline, stack = "indlagt1", color = colors[1],
                    name = "Udvikling i indlagte pr. dag", type = "column",
                    mapping = hcaes(x = timestamp, y = hospitalized_daily)) %>%
      hc_add_series(data = DanishTimeline, stack = "indlagt2", color = colors[2],
                    name = "Udvikling i intensiv indlagte pr. dag", type = "column",
                    mapping = hcaes(x = timestamp, y = critical_daily)) %>%
      hc_add_series(data = DanishTimeline, stack = "indlagt3", color = colors[3],
                    name = "Udvikling i intensiv indlagte i respirator pr. dag", type = "column",
                    mapping = hcaes(x = timestamp, y = respirator_daily))
  }
  
  if("daily" %in% show_y2 & "cases" %in% show_y1){
    hc_plot <- 
      hc_plot %>%
      hc_add_series(data = DanishTimeline, stack = "smittede", color = colors[4],
                    name = "Udvikling i registrede smittede pr. dag", type = "column",
                    mapping = hcaes(x = timestamp, y = cases_daily)) %>%
      hc_add_series(data = DanishTimeline, stack = "smittede", color = colors[5],
                    name = "Udvikling i testede pr. dag", type = "column",
                    mapping = hcaes(x = timestamp, y = tests_daily))
  }
  
  hc_plot
  
})
