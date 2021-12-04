#!/bin/sh

set -e
set -v

HOSTNAME=`hostname`

if test -e $HOSTNAME
then
	OLD_IP=`cat $HOSTNAME`
else
	OLD_IP='No previous ip for this host'
fi

IP=`curl -s icanhazip.com`

echo Curent IP: $IP
echo IP on Github: $OLD_IP

if test "$IP" = "$OLD_IP"
then
    echo IP address of $HOSTNAME did not change.
else
    echo NEW IP:$IP OLD IP:$OLD_IP
    echo "$IP" > $HOSTNAME
    git add "$HOSTNAME"
    git commit -m "NEW IP ADDRESS OF $HOSTNAME AS OF `date`"
    git push
fi
