#!/bin/bash

sudo ln -s configs/supervisor.conf /etc/supervisor/conf.d/

sudo ln -s configs/nginx.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/mysite.conf /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
sudo cp /etc/nginx/sites-enabled/mysite.conf /etc/nginx/sites-enabled/default
