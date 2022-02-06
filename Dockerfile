FROM alpine

RUN apk update \
    && apk upgrade \
    && apk --no-cache add --update curl htop postgresql-client iputils busybox-extras 
