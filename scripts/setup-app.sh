#!/bin/bash

sudo supervisorctl stop mysite

echo "DJANGO_SETTINGS_MODULE=mysite.settings.production" > .env

/home/ubuntu/.local/bin/pipenv run ./manage.py migrate
/home/ubuntu/.local/bin/pipenv run ./manage.py collectstatic --noinput

sudo supervisorctl start mysite
sudo service nginx restart
