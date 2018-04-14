#!/bin/bash

sudo ln -s configs/supervisor.conf /etc/supervisor/conf.d/mysite.conf

sudo ln -s configs/nginx.conf /etc/nginx/sites-available/mysite.conf
sudo ln -s /etc/nginx/sites-available/mysite.conf /etc/nginx/sites-enabled/mysite.conf
