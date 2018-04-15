#!/bin/bash

sudo supervisorctl stop mysite

pipenv run ./manage.py migrate
pipenv run ./manage.py collectstatic --noinput

sudo supervisorctl start mysite
