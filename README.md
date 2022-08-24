# docker-switchbot

## Create docker image

    $ docker login ghcr.io

    $ docker build -t ghcr.io/cty3000/docker-switchbot:latest .

    $ docker run -dit --rm -p 80:8080 --name switchbot ghcr.io/cty3000/docker-switchbot:latest

    $ docker ps -a

    $ docker stop switchbot

    $ docker push switchbot ghcr.io/cty3000/docker-switchbot:latest
