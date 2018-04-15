#!/bin/bash

sudo supervisorctl stop mysite

/home/ubuntu/.local/bin/pipenv run ./manage.py migrate
/home/ubuntu/.local/bin/pipenv run ./manage.py collectstatic --noinput

sudo supervisorctl start mysite
