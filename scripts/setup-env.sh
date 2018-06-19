#!/bin/bash

scripts/cronjobs.sh
scripts/symlinks.sh

cd /home/ubuntu && sudo -u ubuntu pipenv install --three

sudo service nginx restart
sudo service supervisor restart
#sudo service jenkins restart
