#!/bin/bash

supervisorctl stop mysite

pipenv run ./manage.py migrate
pipenv run ./manage.py collectstatic

supervisorctl start mysite
