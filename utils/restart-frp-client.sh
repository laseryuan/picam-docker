#!/bin/bash

cd /home/pi/projects/picam
/usr/local/bin/docker-compose up -d --force-recreate frp-client
