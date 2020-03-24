FROM r-base
MAINTAINER Emil Lykke Jensen <elj@pension.dk>


# Install dependencies for highchartr
RUN apt-get update && apt-get install -y libxml2-dev libcurl4-openssl-dev


# Install packrat
RUN R -e "install.packages('packrat', repos='http://cran.rstudio.com', dependencies = TRUE)"


# Create app dir
RUN mkdir /app
WORKDIR /app


# Copy R files to Docker
COPY /functions /app/functions
COPY /server /app/server
COPY /packrat /app/packrat
COPY *.R /app/


# Restore packrat
RUN R -e "packrat::restore('/app/')"


# Expose Shiny port and run
EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('/app/', host = '0.0.0.0', port = 3838, launch.browser = FALSE)"]
