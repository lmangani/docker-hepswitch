# Dockerizing OpenSIPS/RTPEngine/HEP Services
Dockerfile to build a OpenSIPS/RTPEngine/HEP container image. The container provides rapid deployment of VoIP service monitoring prototyping and should not be used for much else. This build is specialized for Carina Docker and might fail elsewhere.

### Quick Start
Automated builds of the image are available on [DockerHub](https://hub.docker.com/r/qxip/homer-hepswitch)
```sh
$ docker pull qxip/docker-hepswitch
```

Use the following command to start the container：
```sh
$ docker run --name hepswitch -d -p 5060:5060/udp \
-e ADVERTISED_IP="<ADVERTISED_IP>" \
-e ADVERTISED_PORT="<ADVERTISED_PORT>" \
qxip/docker-hepswitch
```
