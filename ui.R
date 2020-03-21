fluidPage(
  
  titlePanel("C19 Overblik"),
  
  mainPanel(
    width = 12,
    
    tabsetPanel(
      type = "tabs",
      
      # tabPanel("Danmark"),
      
      tabPanel(
        title = "Global",
        
        div(
          style="margin-top: 10px; margin-left: 10px;",
          
          div(
            style = "float: left;",
            pickerInput(
              inputId = "country",
              label = "Lande:", 
              choices = landelist,
              selected = c("Denmark", "Finland", "Norway", "Sweden", "USA", "UK", "Italy", "Germany", "France", "China"),
              multiple = TRUE,
              options = list(
                `live-search` = TRUE,
                `actions-box` = TRUE)
            )
          ),
          
          div(
            style = "float: left; margin-left: 20px;",
            radioGroupButtons(
              inputId = "show_x",
              label = "Vis tid efter:", 
              choices = c("Dato" = "date", "Dage fra første registerede smittede" = "infected", "Dage fra første registede død" = "dead"), 
              justified = FALSE,
              size = "sm",
              selected = "date",
              status = "primary",
              checkIcon = list(
                yes = tags$i(class = "fa fa-circle", 
                             style = "color: steelblue"),
                no = tags$i(class = "fa fa-circle-o", 
                            style = "color: steelblue"))
            )
          ),
          
          div(
            style = "float: left; margin-left: 20px;",
            radioGroupButtons(
              inputId = "show_y",
              label = "Vis:", 
              choices = c("Antal registrede smittede" = "infected", "Antal døde" = "dead", "Antal raske" = "recovered"), 
              justified = FALSE,
              size = "sm",
              selected = "infected",
              status = "primary",
              checkIcon = list(
                yes = tags$i(class = "fa fa-circle", 
                             style = "color: steelblue"),
                no = tags$i(class = "fa fa-circle-o", 
                            style = "color: steelblue")  
              )
            )
          )
          
        ),
        
        div(style = "clear: left", highchartOutput("plot_GlobalTimeline", height = "calc(100vh - 220px)")),
        
      )
      
    )
  )
)