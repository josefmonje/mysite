#!/bin/bash

/home/ubuntu/.local/bin/pipenv run ./manage.py collectstatic --noinput

sudo supervisorctl stop mysite

/home/ubuntu/.local/bin/pipenv run ./manage.py migrate
sudo service nginx restart

sudo supervisorctl start mysite
