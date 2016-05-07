#!/bin/bash
# Program:
#       This program is install boot run script.
# History:
# 2016/04/08 Kyle Bai Release
#

MYSQL_PWD=${MYSQL_PWD:-"passwd"}
EXTERNAL_IP=$(cat /etc/public_ip.txt)
ADVERTISED_IP=${ADVERTISED_IP:-"127.0.0.1"}
ADVERTISED_PORT=${ADVERTISED_PORT:-"5060"}
HOST_IP=$(ip route get 8.8.8.8 | awk '{print $NF; exit}')

echo "Your IP : ${HOST_IP}"
echo "Public IP : ${EXTERNAL_IP}"
echo -e "Your Advertised IP:PORT : ${ADVERTISED_IP}:${ADVERTISED_PORT}\n\n"

# Starting MySQL
service mysql start

# Auto Create Database
expect -c "
spawn /usr/local/sbin/opensipsdbctl create \"\"
expect \"MySQL password for root: \"
send \"${MYSQL_PWD}\r\"
expect \"Install presence related tables? (y/n):\"
send \"y\r\"
expect \"Install tables for imc cpl siptrace domainpolicy carrierroute userblacklist b2b cachedb_sql registrant call_center fraud_detection emergency? (y/n)\"
send \"y\r\"

expect \"END\"
"

# Configure opensips.cfg
sed -i "s/advertised_address=.*/advertised_address=\"${ADVERTISED_IP}\"/g" /usr/local/etc/opensips/opensips.cfg

if [ ! -z "$EXTERNAL_IP" ]; then
	sed -i "s/alias=.*/a alias=\"${EXTERNAL_IP}"" /usr/local/etc/opensips/opensips.cfg
fi

sed -i "s/alias=.*/alias=\"${ADVERTISED_IP}\"/g" /usr/local/etc/opensips/opensips.cfg
sed -i "s/listen=.*/listen=udp:${HOST_IP}:${ADVERTISED_PORT}/g" /usr/local/etc/opensips/opensips.cfg

# Starting RTPEngine process
rtpengine -p /var/run/rtpengine.pid -i eth0/$ADVERTISED_IP -n 127.0.0.1:60000 -c 127.0.0.1:60001 -m 20000 -M 30000 -E -L 7

# Starting OpenSIPS process
/usr/local/sbin/opensips -c
/usr/local/sbin/opensipsctl start
rsyslogd -n
