#!/bin/bash

FILE=/etc/.java/.systemPrefs/com/netapp/occm/prefs.xml
key=`cat $FILE | grep -i passkey |awk '{print $3}' | cut -f2 -d'"'`
if [ ! -z $1 ];then
        sudo sed -i "s/$key/$1/g" $FILE
else
        echo "$key"
fi
