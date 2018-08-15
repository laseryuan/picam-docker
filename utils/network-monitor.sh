#!/bin/bash

##################################################################
# Settings
# Which Interface do you want to check/fix
wlan='wlan0'
# Which address do you want to ping to see if the network interface is alive?
pingip='114.114.114.114'
##################################################################

current_path=`dirname "$0"`

echo "Performing Network check for $wlan"
/bin/ping -c 1 -I $wlan $pingip > /dev/null 2> /dev/null
if [ $? -ge 1 ] ; then
    echo "Looks like down! Try aggain..."
    /bin/ping -c 1 -I $wlan $pingip
    if [ $? -ge 1 ] ; then
        echo "Network: $wlan connection down! Attempting to reconnect..."
        wpa_cli -i wlan0 reconfigure
        ip link set $wlan down
        ip link set $wlan up
        echo "... Done"
        echo "Do we bring up the network after the effort?..."
        /bin/ping -c 1 -I $wlan $pingip
        if [ $? -ge 1 ] ; then
          echo "Still not get connectted. Reboot the system..."
          reboot
        fi
        echo "Yes!. Finished"
        echo "Restart frp-client..."
        $current_path/restart-frp-client.sh
        echo "Done"
    fi
else
    echo "Network is Okay"
fi
