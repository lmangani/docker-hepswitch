FROM debian:jessie
MAINTAINER "Lorenzo Mangani <lorenzo.mangani@gmail.com>"

USER root

RUN apt-get update && apt-get install -y sudo git make bison flex curl && \
    echo "mysql-server mysql-server/root_password password passwd" | sudo debconf-set-selections && \
    echo "mysql-server mysql-server/root_password_again password passwd" | sudo debconf-set-selections && \
    apt-get install -y mysql-server libmysqlclient-dev \
                       libncurses5 libncurses5-dev mysql-client expect

RUN curl ipinfo.io/ip > /etc/public_ip.txt

RUN git clone https://github.com/OpenSIPS/opensips.git -b 2.2 ~/opensips_2_2 && \
    sed -i 's/db_http db_mysql db_oracle/db_http db_oracle/g' ~/opensips_2_2/Makefile.conf.template && \
    cd ~/opensips_2_2 && \
    make all && make prefix=/usr/local install && \
    cd .. && rm -rf ~/opensips_2_2

RUN export DEBIAN_FRONTEND=noninteractive && \
    git clone https://github.com/sipwise/rtpengine.git && cd rtpengine && \
    touch ./debian/flavors/no_ngcp && \
    apt-get install -qqy dpkg-dev debhelper libevent-dev iptables-dev libcurl4-openssl-dev libglib2.0-dev libhiredis-dev libpcre3-dev libssl-dev libxmlrpc-core-c3-dev markdown zlib1g-dev module-assistant dkms gettext \
    libbencode-perl libcrypt-rijndael-perl libdigest-hmac-perl libio-socket-inet6-perl libsocket6-perl netcat linux-image-3.13.0-40-generic && \
    dpkg-checkbuilddeps && \
    dpkg-buildpackage -b -us -uc && \
    dpkg -i ../*.deb && \
    ( ( apt-get install -y linux-headers-$(uname -r) linux-image-$(uname -r) && \
        module-assistant update && \
        module-assistant auto-install ngcp-rtpengine-kernel-source ) || true ) && \
    rm -rf rtpengine
    
RUN apt-get purge -y bison build-essential ca-certificates flex git m4 pkg-config curl  && \
    apt-get autoremove -y && \
    apt-get install -y libmicrohttpd10 rsyslog sngrep && \
    apt-get clean

COPY conf/opensipsctlrc /usr/local/etc/opensips/opensipsctlrc
COPY conf/opensips-rtpengine.cfg /usr/local/etc/opensips/opensips.cfg

COPY boot_run.sh /etc/boot_run.sh
RUN chown root.root /etc/boot_run.sh && chmod 700 /etc/boot_run.sh

EXPOSE 5060/udp
EXPOSE 5060/tcp
EXPOSE 9060/udp
EXPOSE 9060/tcp
EXPOSE 6060/udp
EXPOSE 20000-30000/udp

ENTRYPOINT ["/etc/boot_run.sh"]
