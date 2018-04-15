#!/bin/bash

sudo ln -s ${HOME}/configs/supervisor.conf /etc/supervisor/conf.d/

sudo ln -s ${HOME}/configs/nginx.conf /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/

sudo rm /etc/nginx/sites-enabled/default
