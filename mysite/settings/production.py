from .base import *

import os

DEBUG = False

SECRET_KEY = os.environ['SECRET_KEY']

with open('/home/ubuntu/var/url.loadbalancer') as file:
    data = file.read().strip()
    ALLOWED_HOSTS = [
        data
    ]

try:
    from .local import *
except ImportError:
    pass
