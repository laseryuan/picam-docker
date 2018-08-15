#!/bin/bash

IP=`ip -f inet addr show wlan0 | grep -Po 'inet \K[\d.]+'`
/usr/bin/wget -O - "http://freedns.afraid.org/dynamic/update.php?SDBxVldYdWVuYTJaNk1QT2NGcjhlc0drOjE3NzA1ODM3&address=${IP}"
