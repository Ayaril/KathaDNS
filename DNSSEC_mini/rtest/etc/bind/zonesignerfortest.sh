#!/bin/sh
PDIR='keys'
ZONEDIR="/etc/bind"
ZONE=$1
ZONEFILE=$2
DNSSERVICE="bind" 
cd $ZONEDIR
SERIAL='/usr/sbin/named-checkzone $ZONE $ZONEFILE | egrep -ho '[0-9]{10}'';
sed -i 's/'$SERIAL'/'$(($SERIAL+1))'/' $ZONEFILE
dnssec-signzone -t -g -o $1 $2 /etc/bind/keys/K*.private
systemctl $DNSSERVICE reload
cd $PDIR

