#!/bin/bash

cd /home/ubuntu && sudo -u ubuntu pipenv run ./manage.py collectstatic --noinput

sudo supervisorctl stop mysite

cd /home/ubuntu && sudo -u ubuntu pipenv run ./manage.py migrate

sudo supervisorctl start mysite
