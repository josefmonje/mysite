#!/bin/bash

scripts/cronjobs.sh
scripts/symlinks.sh

pipenv install --three

sudo service nginx restart
sudo service supervisor restart
#sudo service jenkins restart
