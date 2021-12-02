#!/bin/sh
set -v

#run this form the git repository

HOSTNAME=`hostname`

OLD_IP=`cat hosts/$HOSTNAME`
IP=`curl -s icanhazip.com`

echo $IP

if test "$IP" = "$OLD_IP"
then
    echo IP address of $HOSTNAME did not change.
else
    echo NEW IP:$IP OLD IP:$OLD_IP
    git checkout ip
    echo "$IP" > hosts/$HOSTNAME
    git add "hosts/$HOSTNAME"
    git commit -m "NEW IP ADDRESS AS OF `date`"
    git push
    git checkout main
fi
