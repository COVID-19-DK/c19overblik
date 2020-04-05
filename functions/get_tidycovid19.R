get_tidycovid19 <- function(){
  
  tidycovid19 <- download_merged_data(cached = TRUE)
  tidycovid19 <- as.data.table(tidycovid19)

  tidycovid19[, confirmed_pctpop := (confirmed / population) * 100]
  tidycovid19[, deaths_pctpop := (deaths / population) * 100]
  tidycovid19[, recovered_pctpop := (recovered / population) * 100]
  
  tidycovid19[, confirmed_100k := (confirmed / population) * 100000]
  tidycovid19[, deaths_100k := (deaths / population) * 100000]
  tidycovid19[, recovered_100k := (recovered / population) * 100000]
  
  return(tidycovid19)
  
}