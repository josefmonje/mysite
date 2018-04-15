#!/bin/bash

sudo ln -s $PWD/configs/supervisor.conf /etc/supervisor/conf.d/

sudo ln -s $PWD/configs/nginx.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/mysite.conf /etc/nginx/sites-enabled/
