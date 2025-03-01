function(input, output) {
    
    # Load data
    shiny::withProgress(
        min = 0,
        max = 2,
        message = "Henter data", {
            
            setProgress(value = 0, detail = "Global data")
            # GlobalTimeline <- get_GlobalTimeline()
            tidycovid19 <- get_tidycovid19()
            
            setProgress(value = 1, detail = "Data data")
            DanishTimeline <- get_DanishTimeline()
            
            
            setProgress(value = 2, detail = NULL)
            
        })
    
    source("server/DanishTimeline.R", local = TRUE)
     
    source("server/GlobalTimeline.R", local = TRUE)
     
    source("server/correlation.R", local = TRUE)
    
}