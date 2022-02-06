# Ephemeral-container
## Docker
#### Build the app’s container image
In order to build the application, we need to use a Dockerfile. A Dockerfile is simply a text-based script of instructions that is used to create a container image.

```bash
FROM alpine

RUN apk update \
    && apk upgrade \
    && apk --no-cache add --update curl htop postgresql-client iputils busybox-extras 
```
Now build the container image using the docker build command:
```bash
docker build . -t ephemeralimage 
```
This command used the Dockerfile to build a new container image. 

In my case the image has been named "ephemeral-container" with tag "master" via github action.
This image built with Dockerfile in this repository.
```bash
docker pull ghcr.io/rfinland/ephemeral-container:master
```

#### Start an app container
Now that we have an image, let’s run the application. To do so, we will use the docker run command:
```bash
docker run -it --name EphemeralContainer ephemeralimage /bin/sh
```
Or
```bash
docker run -it --name EphemeralContainer ghcr.io/rfinland/ephemeral-container:master /bin/sh
```
You can run your command inside the container (EphemeralContainer).


## Kubernetes


