#!/bin/bash

supervisorctl mysite stop
pipenv run ./manage.py migrate
pipenv run ./manage.py collectstatic
supervisorctl mysite start
