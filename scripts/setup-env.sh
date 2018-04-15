#!/bin/bash

PWD=${HOME}/mysite
${PWD}/scripts/cronjobs.sh
${PWD}/scripts/symlinks.sh

sudo service nginx restart
sudo service supervisor restart
sudo service jenkins restart
