#!/bin/bash

sudo supervisorctl stop mysite

PWD=${HOME}/mysite
/home/ubuntu/.local/bin/pipenv run ${PWD}/manage.py migrate
/home/ubuntu/.local/bin/pipenv run ${PWD}/manage.py collectstatic --noinput

sudo supervisorctl start mysite
