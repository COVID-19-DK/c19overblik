function(input, output) {
    
    # Load data
    GlobalTimeline <- get_GlobalTimeline()
    DanishTimeline <- get_DanishTimeline()
    
    source("server/DanishTimeline.R", local = TRUE)
     
    source("server/GlobalTimeline.R", local = TRUE)
     
    # source("server/Fremskrivning.R", local = TRUE)
    
}