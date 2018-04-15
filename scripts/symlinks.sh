#!/bin/bash

sudo ln -s configs/supervisor.conf /etc/supervisor/conf.d/

sudo ln -s configs/nginx.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/mysite.conf /etc/nginx/sites-enabled/
