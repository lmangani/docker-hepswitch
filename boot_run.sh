#!/bin/bash
# OpenSIPS Docker bootstrap

MYSQL_PWD=${MYSQL_PWD:-"passwd"}
EXTERNAL_IP=$(cat /etc/public_ip.txt)
ADVERTISED_IP=${ADVERTISED_IP:-$EXTERNAL_IP}
ADVERTISED_PORT=${ADVERTISED_PORT:-"5060"}
HEP_PORT=${HEP_PORT:-"9060"}
HOST_IP=$(ip route get 8.8.8.8 | awk '{print $NF; exit}')

echo "Your IP : ${HOST_IP}"
echo "Public IP : ${EXTERNAL_IP}"
echo -e "Advertised HEP IP:PORT : ${ADVERTISED_IP}:${HEP_PORT}\n\n"

# Configure opensips.cfg
sed -i "s/advertised_address=.*/advertised_address=\"${ADVERTISED_IP}\"/g" /usr/local/etc/opensips/opensips.cfg
sed -i "s/listen=hep_udp.*/listen=hep_udp:${HOST_IP}:${HEP_PORT}/g" /usr/local/etc/opensips/opensips.cfg

# Starting OpenSIPS process
/usr/local/sbin/opensips -c
/usr/local/sbin/opensipsctl start
rsyslogd -n
