#!/bin/bash

/home/ubuntu/.local/bin/pipenv run ./manage.py collectstatic --noinput

sudo supervisorctl stop mysite

/home/ubuntu/.local/bin/pipenv run ./manage.py migrate

sudo supervisorctl start mysite
