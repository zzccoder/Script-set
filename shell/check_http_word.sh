#!/bin/bash

WEBSITE="http://192.168.149.131/" NUM=`curl -s $WEBSITE|grep -c "ATM"` echo $NU

#UserParameter=check_http_word,sh /data/sh/check_http_word.sh

# /usr/local/zabbix/bin/zabbix_get -s 192.168.149.131 -k