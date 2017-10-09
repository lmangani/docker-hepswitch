# Dockerizing OpenSIPS/RTPEngine/HEP Services
Dockerfile to build a OpenSIPS/RTPEngine/HEP container image. The container provides rapid deployment of VoIP service monitoring prototyping and should not be used for much else. This build is specialized for Carina Docker and might fail elsewhere.

<!--
### Quick Start
Automated builds of the image are available on [DockerHub](https://hub.docker.com/r/qxip/homer-hepswitch)
```sh
$ docker pull qxip/docker-hepswitch
```
-->


### Custom Build w/ RTPEngine kernel modules
In order for RTPEngine to insert and use its kernel modules, the container must be built for the specific system w/ corresponding modules and kernel version
```
git clone https://github.com/lmangani/docker-hepswitch
cd docker-hepswitch
docker build -t qxip/docker-hepswitch .
```

### Usage
Use docker-compose to manage the containerïstatus¼š
```sh
$ docker-compose up
```
