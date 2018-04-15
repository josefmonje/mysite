#!/bin/bash

export HOST_IP=`wget -qO- http://instance-data/latest/meta-data/public-ipv4`
/home/ubuntu/.local/bin/pipenv run gunicorn -b 0.0.0.0:8000 mysite.wsgi
