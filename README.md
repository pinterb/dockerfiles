dockerfiles
===========

A collection of [Docker](http://www.docker.io/) Dockerfiles and configs.

### Example Commands (for newbs young and old)

* **Build** a Dockerfile

    sudo docker build -t pinter/golang:latest golang/. 

* **Verify** a Dockerfile build by logging on to container

    sudo docker run -i -t pinter/golang:latest /bin/bash 
