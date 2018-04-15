#!/bin/bash

scripts/cronjobs.sh
scripts/symlinks.sh

source scripts/get_ip.sh

sudo service nginx restart
sudo service supervisor restart
