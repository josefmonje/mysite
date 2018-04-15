#!/bin/bash

sudo supervisorctl stop mysite

PWD=${HOME}/mysite
pwd
pipenv run ./manage.py migrate
pipenv run ./manage.py collectstatic --noinput

sudo supervisorctl start mysite
