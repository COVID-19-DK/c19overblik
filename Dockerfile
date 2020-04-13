FROM r-base
MAINTAINER Emil Lykke Jensen <elj@pension.dk>


# Install dependencies for highchartr
RUN apt-get update && apt-get install -y libxml2-dev libcurl4-openssl-dev libssl-dev


# Install packages used by c19overblik
RUN R -e "install.packages(c('remotes', 'shiny', 'shinyWidgets', 'data.table', 'magrittr', 'highcharter', 'jsonlite', 'colorspace', 'shinycssloaders', 'ggplot2', 'plotly'))"

RUN R -e "remotes::install_github('joachim-gassen/tidycovid19')"


# Create app dir
RUN mkdir /app
WORKDIR /app


# Copy R files to Docker
COPY /functions /app/functions
COPY /server /app/server
COPY *.R /app/
COPY landeliste.csv /app/


# Expose Shiny port and run
EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('/app/', host = '0.0.0.0', port = 3838, launch.browser = FALSE)"]
