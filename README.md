<img src="https://avatars1.githubusercontent.com/u/3853758?v=4&s=100">

# HEP-Switch = OpenSIPS 2.2+
This repository provides a generic OpenSIPS HEP Switching capable container image for rapid development and prototyping of HEP playgrounds. Presented methods are suitable for production usage when properly configured.


### Quick Start
Automated builds of the image are usually available on [DockerHub](https://hub.docker.com/r/qxip/homer-hepswitch)
```sh
$ docker pull qxip/docker-hepswitch
```

### Configuration
**HEP Switch** allows users to route/fork/balance **HEP** UDP/TCP packets across multiple [HOMER](https://github.com/sipcapture/homer/wiki) deployments, based on *Type* and *SIP content* using the full power and speed of *OpenSIPS* just like they would with regular SIP messages.

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
The HEP Switch configuration can be modified and OpenSIPS restarted while running containers
```
vi /usr/local/etc/opensips/opensips.cfg
opensipsctl reload
```
