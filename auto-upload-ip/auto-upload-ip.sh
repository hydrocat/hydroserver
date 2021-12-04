#!/bin/sh

#run this form the root of this git repository

HOSTNAME=`hostname`

git checkout ip

OLD_IP=`cat hosts/$HOSTNAME`
IP=`curl -s icanhazip.com`

echo Curent IP: $IP
echo IP on Github: $OLD_IP

if test "$IP" = "$OLD_IP"
then
    echo IP address of $HOSTNAME did not change.
else
    echo NEW IP:$IP OLD IP:$OLD_IP
    echo "$IP" > hosts/$HOSTNAME
    git add "hosts/$HOSTNAME"
    git commit -m "NEW IP ADDRESS AS OF `date`"
    git push
fi

git checkout main
