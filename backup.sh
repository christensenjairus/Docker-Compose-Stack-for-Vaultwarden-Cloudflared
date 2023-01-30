#!/bin/bash
cd /home/<username>/VaultWarden/
sudo docker-compose stop
echo Stack Stopped
sudo tar cvzf ./Backups/vw-data-$(date +"%m-%d-%y").tar.gz ./vw-data
echo Content Backed Up
sudo docker-compose start
echo Stack Started
