FROM r-base
MAINTAINER Emil Lykke Jensen <elj@pension.dk>


# Install dependencies for highchartr
RUN apt-get update && apt-get install -y libxml2-dev libcurl4-openssl-dev


# Install packages from packrat source
COPY /packrat/src/ /src/
RUN R -e "install.packages(list.files(list.files('/src/', full.names = TRUE), full.names = TRUE), repos = NULL)"


# Create app dir
RUN mkdir /app
WORKDIR /app


# Copy R files to Docker
COPY /functions /app/functions
COPY /server /app/server
COPY *.R /app/


# Expose Shiny port and run
EXPOSE 3838
CMD ["R", "-e", "shiny::runApp('/app/', host = '0.0.0.0', port = 3838, launch.browser = FALSE)"]
