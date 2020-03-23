# c19overblik


### Server setup with docker-compose

Make sure to look through the docker-compose files and verify that the settings are correct.

Step 1) Build docker image or pull it from somewhere. **important** it needs to be called `c19overblik:latest`.

Step 2) Start the letsencrypt containers to make sure your domain will have ssl encryption:

```
docker-compose -f docker-compose-letsencrypt.yml up -d
```

Step 3) Start the shiny dash board

```
docker-compose -f docker-compose-shiny.yml up -d
```
