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
#### Use as a Pod (This is not best practice)
In some cases we need to use this troubleshooter as a pod.
From now on we'll use "ghcr.io/rfinland/ephemeral-container:master" image as base image
To create a pod using the ephemeral image , our manifest will be:
```bash
apiVersion: v1
kind: Pod
metadata:
  name: troubleshooter
  namespace: default
spec:
  containers:
  - name: ephemeral-container
    image: ghcr.io/rfinland/ephemeral-container:master
    command:
      - sleep
      - "3600"
    imagePullPolicy: IfNotPresent
  restartPolicy: Always
```
#### Use as a initContainer (best practice)
Let's take a look at philosophy of ephemeral containers: a special type of container that runs temporarily in an existing Pod to accomplish user-initiated actions such as troubleshooting. You use ephemeral containers to inspect services rather than to build applications.
Sometimes it's necessary to inspect the state of an existing Pod, however, for example to troubleshoot a hard-to-reproduce bug. In these cases you can run an ephemeral container in an existing Pod to inspect its state and run arbitrary commands.
Ephemeral containers are useful for interactive troubleshooting when kubectl exec is insufficient because a container has crashed or a container image doesn't include debugging utilities.
We have to use ephemeral containers as an initContainer. Your pod(deployment) will look like:
```bash
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app.kubernetes.io/name: nginx
spec:
  containers: 
    - name: web
      image: nginx
      ports:
       - name: web
         containerPort: 80
         protocol: TCP
  initContainers:
      - name: my-init-containers
        image: ghcr.io/rfinland/ephemeral-container:master
        command: ["/bin/sh"]
        args: ["-c", "YOURCOMMAND"]
```
#### Debug Running Pods
   [Creating Ephemeral Containers using kubectl](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-running-pod/#ephemeral-container)
   
Have fun.


