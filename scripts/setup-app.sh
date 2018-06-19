#!/bin/bash

pipenv run ./manage.py collectstatic --noinput

sudo supervisorctl stop mysite

pipenv run ./manage.py migrate

sudo supervisorctl start mysite
