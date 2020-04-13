suppressPackageStartupMessages({
  library(shiny)
  library(jsonlite)
  library(data.table)
  library(highcharter)
  library(magrittr)
  library(shinyWidgets)
  library(colorspace)
  library(shinycssloaders)
  library(tidycovid19)
  library(ggplot2)
  library(plotly)
})


source_list <- list.files("functions", full.names = TRUE)
for(file in source_list) source(file)

landeliste <- c("Afghanistan", "Angola", "Albania", "Andorra", "United Arab Emirates", "Argentina", "Armenia", "Antigua and Barbuda", "Australia", "Austria", "Azerbaijan", "Burundi", "Belgium", "Benin", "Burkina Faso", "Bangladesh", "Bulgaria", "Bahrain", "Bahamas", "Bosnia and Herzegovina", "Belarus", "Belize", "Bolivia", "Brazil", "Barbados", "Brunei", "Bhutan", "Botswana", "Central African Republic", "Canada", "Switzerland", "Chile", "China", "Cote d'Ivoire", "Cameroon", "Congo (Kinshasa)", "Congo (Brazzaville)", "Colombia", "Cabo Verde", "Costa Rica", "Cuba", "Cyprus", "Czechia", "Germany", "Djibouti", "Dominica", "Denmark", "Dominican Republic", "Algeria", "Ecuador", "Egypt", "Eritrea", "Western Sahara", "Spain", "Estonia", "Ethiopia", "Finland", "Fiji", "France", "Gabon", "United Kingdom", "Georgia", "Ghana", "Guinea", "Gambia", "Guinea-Bissau", "Equatorial Guinea", "Greece", "Grenada", "Guatemala", "Guyana", "Honduras", "Croatia", "Haiti", "Hungary", "Indonesia", "India", "Ireland", "Iran", "Iraq", "Iceland", "Israel", "Italy", "Jamaica", "Jordan", "Japan", "Kazakhstan", "Kenya", "Kyrgyzstan", "Cambodia", "Saint Kitts and Nevis", "Korea", "South", "Kuwait", "Laos", "Lebanon", "Liberia", "Libya", "Saint Lucia", "Liechtenstein", "Sri Lanka", "Lithuania", "Luxembourg", "Latvia", "Morocco", "Monaco", "Moldova", "Madagascar", "Maldives", "Mexico", "North Macedonia", "Mali", "Malta", "Burma", "Montenegro", "Mongolia", "Mozambique", "Mauritania", "Mauritius", "Malawi", "Malaysia", "Namibia", "Niger", "Nigeria", "Nicaragua", "Netherlands", "Norway", "Nepal", "New Zealand", "Oman", "Pakistan", "Panama", "Peru", "Philippines", "Papua New Guinea", "Poland", "Portugal", "Paraguay", "West Bank and Gaza", "Qatar", "Romania", "Russia", "Rwanda", "Saudi Arabia", "Sudan", "Senegal", "Singapore", "Sierra Leone", "El Salvador", "San Marino", "Somalia", "Serbia", "South Sudan", "Suriname", "Slovakia", "Slovenia", "Sweden", "Eswatini", "Seychelles", "Syria", "Chad", "Togo", "Thailand", "Timor-Leste", "Trinidad and Tobago", "Tunisia", "Turkey", "Taiwan*", "Tanzania", "Uganda", "Ukraine", "Uruguay", "US", "Uzbekistan", "Holy See", "Saint Vincent and the Grenadines", "Venezuela", "Vietnam", "South Africa", "Zambia", "Zimbabwe")

correlation_list <- c(
  "Antal registrede smittede" = "confirmed",
  "Antal døde" = "deaths",
  "Antal raske" = "recovered",
  "Antal social afstand foranstaltninger" = "soc_dist",
  "Antal bevægelsesbegrænsende foranstaltninger" = "mov_rest",
  "Antal folkesundhedsforanstaltninger" = "pub_health",
  "Antal sociale og økonomiske foranstaltninger" = "soc_econ",
  "Antal lockdown foranstaltninger" = "lockdown",
  "Google Trends søgning på 'coronavirus'" = "gtrends_country_score",
  "Indkomstgruppe" = "income",
  "Antal indbyggere" = "population",
  "Areal" = "land_area_skm",
  "Befolkningstæthed" = "pop_density",
  "Befolkningstæthed i største by" = "pop_largest_city",
  "Forventede levealder" = "life_expectancy",
  "GDP pr. capita" = "gdp_capita",
  "Pct. registrede smittede af befolkning" = "confirmed_pctpop",
  "Pct. døde af befolkning" = "deaths_pctpop",
  "Pct. raske af befolkning" = "recovered_pctpop",
  "Antal registrede smittede pr. 100.000" = "confirmed_100k",
  "Antal døde pr. 100.000" = "deaths_100k",
  "Antal raske pr. 100.000" = "recovered_100k")

# landeliste <- fread("landeliste.csv")
# landeliste[, V1 := sapply(V1, function(x){
#   x <- stringr::str_squish(x) %>% strsplit(" ") %>% magrittr::extract2(1)
#   x <- paste(x[-1], collapse = " ")
#   return(x)
# })]
# names(landeliste) <- c("country", "Stat Code", "Timeline Code")
# fwrite(landeliste, file = "landeliste.csv")


# landelist <- c("Afghanistan", "Albania", "Algeria", "Angola", "Argentina", "Armenia", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bangladesh", "Belarus", "Belgium", "Belize", "Benin", "Bhutan", "Bolivia (Plurinational State of)", "Bosnia and Herzegovina", "Botswana", "Brazil", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Central African Republic", "Chad", "Chile", "China", "Colombia", "Congo Republic", "DR Congo", "Costa Rica", "Côte d'Ivoire", "Croatia", "Cuba", "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falklands", "Fiji", "Finland", "France", "French Guiana", "French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Greece", "Greenland", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Honduras", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "North Korea", "South Korea", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Lithuania", "Luxembourg", "Macedonia", "Madagascar", "Malawi", "Malaysia", "Mali", "Mauritania", "Mexico", "Moldova", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nepal", "Netherlands", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Norway", "Oman", "Pakistan", "Palestine", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Puerto Rico", "Qatar", "Kosovo", "Romania", "Russia", "Rwanda", "Saudi Arabia", "Senegal", "Serbia", "Sierra Leone", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Sudan", "Spain", "Sri Lanka", "Sudan", "Suriname", "Svalbard and Jan Mayen", "Swaziland", "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Tanzania", "Thailand", "Timor-Leste", "Togo", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Uganda", "Ukraine", "UAE", "UK", "USA", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "Western Sahara", "Yemen", "Zambia", "Zimbabwe", "Singapore", "Hong Kong", "Diamond Princess")
# landelist <- c("Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Antigua and Barbuda", "Argentina", "Armenia", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Benin", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Brazil", "Brunei", "Bulgaria", "Burkina Faso", "Cabo Verde", "Cambodia", "Cameroon", "Canada", "Central African Republic", "Chad", "Chile", "China", "Colombia", "Congo (Brazzaville)", "Congo (Kinshasa)", "Costa Rica", "Cote d'Ivoire", "Croatia", "Diamond Princess", "Cuba", "Cyprus", "Czechia", "Denmark", "Djibouti", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Eswatini", "Ethiopia", "Fiji", "Finland", "France", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Greece", "Guatemala", "Guinea", "Guyana", "Haiti", "Holy See", "Honduras", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Korea", "South", "Kuwait", "Kyrgyzstan", "Latvia", "Lebanon", "Liberia", "Liechtenstein", "Lithuania", "Luxembourg", "Madagascar", "Malaysia", "Maldives", "Malta", "Mauritania", "Mauritius", "Mexico", "Moldova", "Monaco", "Mongolia", "Montenegro", "Morocco", "Namibia", "Nepal", "Netherlands", "New Zealand", "Nicaragua", "Niger", "Nigeria", "North Macedonia", "Norway", "Oman", "Pakistan", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Qatar", "Romania", "Russia", "Rwanda", "Saint Lucia", "Saint Vincent and the Grenadines", "San Marino", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Singapore", "Slovakia", "Slovenia", "Somalia", "South Africa", "Spain", "Sri Lanka", "Sudan", "Suriname", "Sweden", "Switzerland", "Taiwan*", "Tanzania", "Thailand", "Togo", "Trinidad and Tobago", "Tunisia", "Turkey", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "Uruguay", "US", "Uzbekistan", "Venezuela", "Vietnam", "Zambia", "Zimbabwe", "Dominica", "Grenada", "Mozambique", "Syria", "Timor-Leste", "Belize", "Laos", "Libya", "West Bank and Gaza", "Guinea-Bissau", "Mali", "Saint Kitts and Nevis", "Kosovo", "Burma", "MS Zaandam", "Botswana", "Burundi", "Sierra Leone", "Malawi")