#!/bin/bash

PWD=${HOME}/mysite
${PWD}/scripts/cronjobs.sh
${PWD}/scripts/symlinks.sh

pipenv install --three

sudo service nginx restart
sudo service supervisor restart
sudo service jenkins restart
