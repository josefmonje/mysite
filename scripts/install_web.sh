#!/bin/bash

export LC_ALL='en_US.UTF-8'
export LANG='en_US.UTF-8'

# Install web deps
sudo apt-get update && sudo apt-get install -y \
    git \
    curl \
    unzip \
    libwww-perl \
    libdatetime-perl \
    python \
    python3 \
    python-pip \
    python3-pip \
    nginx \
    supervisor \
    fail2ban

# Install pipenv
pip3 install pipenv

# Install cloudwatch monitoring scripts
curl https://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip -O
unzip CloudWatchMonitoringScripts-1.2.2.zip && rm CloudWatchMonitoringScripts-1.2.2.zip
mv aws-scripts-mon /home/ubuntu

# Clone repo
git clone https://github.com/josefmonje/mysite.git /tmp/mysite
sudo chown ubuntu:ubuntu -R /tmp/mysite/*
cp -r /tmp/mysite/* /home/ubuntu

cd /home/ubuntu && scripts/setup-env.sh
cd /home/ubuntu && scripts/setup-app.sh

# # Install cron for monitoring scripts
# sudo -u ubuntu crontab /home/ubuntu/configs/cron-disk-80

# # Install symlinks
# sudo ln -s /home/ubuntu/configs/supervisor.conf /etc/supervisor/conf.d/
# sudo ln -s /home/ubuntu/configs/nginx.conf /etc/nginx/sites-available/
# sudo ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/

# # Remove nginx defaults
# sudo rm /etc/nginx/sites-available/default
# sudo rm /etc/nginx/sites-enabled/default

# sudo service nginx restart
# sudo service supervisor restart

# # Pipenv install
# cd /home/ubuntu && sudo -u ubuntu pipenv install --three && sudo -u ubuntu pipenv run ./manage.py collectstatic --noinput

# sudo supervisorctl stop mysite
# cd /home/ubuntu && sudo -u ubuntu pipenv run ./manage.py migrate
# sudo supervisorctl start mysite
