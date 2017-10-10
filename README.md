<img src="https://avatars1.githubusercontent.com/u/3853758?v=4&s=100">

# HEP-Switch = OpenSIPS
This repository provides a generic OpenSIPS + HEP Switching capable container image for rapid development and prototyping of HEP architectures. Prenseted methods are suitable for production usage.

<!--
### Quick Start
Automated builds of the image are available on [DockerHub](https://hub.docker.com/r/qxip/homer-hepswitch)
```sh
$ docker pull qxip/docker-hepswitch
```
-->

### Configuration
HEP Switch allows you to route HEP UDP/TCP packets based on their type and SIP content using OpenSIPS.

##### Example
```
route{
      xlog("L_DEBUG","Request $rm from $si with domain $rd");
      /* Conditional HEP Routing based on Source IP */
      if ($si == "10.20.30.40" || $rd == "qxip.net")
      {
        $du="sip:10.0.0.1:9060";
        hep_relay();
      } else {
        $du="sip:10.0.0.2:9060";
        hep_relay();
      }
}
```

### Usage
Use docker-compose to manage the container status
```sh
$ docker-compose up
```
The configuration can be modified and OpenSIPS restarted while running
```
vi /usr/local/etc/opensips/opensips.cfg
opensipsctl reload
```
