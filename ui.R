fluidPage(
  
  titlePanel("C19 Overblik"),
  
  mainPanel(
    width = 12,
    
    tabsetPanel(
      type = "tabs",
      
      tabPanel(
        title = "Danmark",
        
        div(
          style="margin-top: 10px;",
          
          div(
            style = "float: left; margin-right: 20px;",
            checkboxGroupButtons(
              inputId = "DT_show_y1",
              label = "Vis:", 
              choices = c("Indlagte" = "hospitalized", "Testede/smittede" = "cases"), 
              justified = FALSE,
              size = "xs",
              selected = "hospitalized",
              checkIcon = list(
                yes = tags$i(class = "fa fa-circle", 
                             style = "color: steelblue"),
                no = tags$i(class = "fa fa-circle-o", 
                            style = "color: steelblue"))
            )
          ),
          
          div(
            style = "float: left;",
            checkboxGroupButtons(
              inputId = "DT_show_y2",
              label = "Vis:", 
              choices = c("Akkumulerede over tid" = "total", "Udvikling pr. dag" = "daily"), 
              justified = FALSE,
              size = "xs",
              selected = "total",
              checkIcon = list(
                yes = tags$i(class = "fa fa-circle", 
                             style = "color: steelblue"),
                no = tags$i(class = "fa fa-circle-o", 
                            style = "color: steelblue"))
            )
          )
          
        ),
        
        div(style = "clear: left", 
            shinycssloaders::withSpinner(
              highchartOutput("plot_DanishTimeline", height = "calc(100vh - 220px)"),
              proxy.height = "calc(100vh - 220px)")
            ),
        
        p("Kilde: ", a("covid19data.dk", href = "http://covid19data.dk", target = "_blank"))
        
        ),
      
      tabPanel(
        title = "Verden",

        div(
          style="margin-top: 10px; margin-right: 20px;",

          div(
            style = "float: left; margin-right: 20px;",
            pickerInput(
              inputId = "GT_country",
              label = "Lande:",
              choices = landeliste,
              selected = c("Denmark", "Finland", "Norway", "Sweden", "US", "United Kingdom", "Italy", "Spain", "China"),
              multiple = TRUE,
              options = list(
                `live-search` = TRUE,
                `actions-box` = TRUE)
            )
          ),
          
          div(
            style = "float: left; margin-right: 20px;",
            radioGroupButtons(
              inputId = "GT_show_y2",
              label = "Vis:",
              choices = c("Antal" = "count", "Pr. 100.000" = "100k"),
              justified = FALSE,
              size = "xs",
              selected = "count",
              checkIcon = list(
                yes = tags$i(class = "fa fa-circle",
                             style = "color: steelblue"),
                no = tags$i(class = "fa fa-circle-o",
                            style = "color: steelblue"))
            )
          ),

          div(
            style = "float: left; margin-right: 20px;",
            radioGroupButtons(
              inputId = "GT_show_x",
              label = "Vis tid efter:",
              choices = c("Dato" = "date", "Dage fra nr. 1000 smittede" = "day_infected", "Dage fra 10. dødsfald" = "day_dead"),
              justified = FALSE,
              size = "xs",
              selected = "date",
              checkIcon = list(
                yes = tags$i(class = "fa fa-circle",
                             style = "color: steelblue"),
                no = tags$i(class = "fa fa-circle-o",
                            style = "color: steelblue"))
            )
          ),

          div(
            style = "float: left;",
            radioGroupButtons(
              inputId = "GT_show_y",
              label = "Vis:",
              choices = c("Antal registrede smittede" = "infected", "Antal døde" = "dead", "Antal raske" = "recovered"),
              justified = FALSE,
              size = "xs",
              selected = "infected",
              checkIcon = list(
                yes = tags$i(class = "fa fa-circle",
                             style = "color: steelblue"),
                no = tags$i(class = "fa fa-circle-o",
                            style = "color: steelblue")
              )
            )
          )

        ),

        div(style = "clear: left",
            shinycssloaders::withSpinner(
              highchartOutput("plot_GlobalTimeline", height = "calc(100vh - 220px)"),
              proxy.height = "calc(100vh - 220px)")
            )

      ),
      
      
      tabPanel(
        title = "Korrelation",

        div(
          style="margin-top: 10px; margin-right: 20px;",
          
          div(
            style = "float: left; margin-right: 20px;",
            pickerInput(
              inputId = "correlation_x",
              label = "X:",
              choices = correlation_list,
              selected = "deaths_pctpop"
            )
          ),
          
          div(
            style = "float: left; margin-right: 20px;",
            pickerInput(
              inputId = "correlation_y",
              label = "Y:",
              choices = correlation_list,
              selected = "soc_dist"
            )
          ),

          div(
            style = "float: left; margin-right: 20px;",
            pickerInput(
              inputId = "correlation_size",
              label = "Størrelse:",
              choices = correlation_list,
              selected = "population"
            )
          ),
          
          div(
            style = "float: left;",
            sliderInput(
              inputId = "correlation_date",
              label = "Dato:",
              min = as.Date("2020-01-22"),
              max = Sys.Date()-1,
              value = Sys.Date()-1,
              timezone = "CET",
              timeFormat = "%d. %b %Y")
          ),
          
          div(style = "clear: left", 
              shinycssloaders::withSpinner(
                plotlyOutput("plot_correlation", height = "calc(100vh - 220px)"),
                proxy.height = "calc(100vh - 220px)")
          )
          
        )
        
      ),
      
      
      # tabPanel(
      #   title = "Fremskrivning",
      #   
      #   div(
      #     style="margin-top: 10px;",
      #     
      #     div(
      #       style = "float: left;",
      #       radioGroupButtons(
      #         inputId = "FS_fremskriv",
      #         label = "Fremskriv:", 
      #         choices = c("Indlagte" = "hospitalized", "Testede/smittede" = "cases"), 
      #         justified = FALSE,
      #         size = "sm",
      #         selected = "hospitalized",
      #         checkIcon = list(
      #           yes = tags$i(class = "fa fa-circle", 
      #                        style = "color: steelblue"),
      #           no = tags$i(class = "fa fa-circle-o", 
      #                       style = "color: steelblue"))
      #       )
      #     )
      #     
      #   )
      #   
      # ),
      
      tabPanel(
        title = "Om",
        
        fluidRow(
          column(width = 12,
                 style = "margin:40px 20px 0px 20px",
                 
                 p("Vil du bidrage til c19overblik.dk kontakt", tags$a(href = "https://www.linkedin.com/in/emillykkejensen/", target ="_blank", "Emil Lykke Jensen")),
                 
                 p(icon("github"), "Find koden på GitHub:", a("www.github.com/covid19dk/c19overblik", href = "https://github.com/covid19dk/c19overblik")),
                 
                 p("Kilde: ", a("covid19data.dk", href = "http://covid19data.dk", target = "_blank")),
                 
                 p("Kilde: ", a("thevirustracker.com", href = "https://thevirustracker.com", target = "_blank"))
                 
                 
          ))
        
      )
      
    )
  )
)