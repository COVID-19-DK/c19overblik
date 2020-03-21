fluidPage(
  
  # Application title
  titlePanel("C19 Overblik"),
  
  mainPanel(width = 12,
    
    highcharter::highchartOutput("plot_GlobalTimeline"),
    
    radioGroupButtons(
      inputId = "show_x",
      label = "Vis tid efter:", 
      choices = c("Dato" = "date", "Dage fra første registerede smittede" = "infected", "Dage fra første registede død" = "dead"), 
      justified = FALSE,
      size = "sm",
      selected = "date",
      status = "primary",
      checkIcon = list(yes = icon("ok", lib = "glyphicon"), no = icon("remove", lib = "glyphicon"))
    ),
    
    radioGroupButtons(
      inputId = "show_y",
      label = "Vis:", 
      choices = c("Antal registrede smittede" = "infected", "Antal døde" = "dead", "Antal raske" = "recovered"), 
      justified = FALSE,
      size = "sm",
      selected = "infected",
      status = "primary",
      checkIcon = list(yes = icon("ok", lib = "glyphicon"), no = icon("remove", lib = "glyphicon"))
    )
    
    
  )
  
)