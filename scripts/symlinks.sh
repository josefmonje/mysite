#!/bin/bash

sudo ln -s /home/ubuntu/configs/supervisor.conf /etc/supervisor/conf.d/

sudo ln -s /home/ubuntu/configs/nginx.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/

sudo rm /etc/nginx/sites-enabled/default
sudo rm /etc/nginx/sites-available/default
