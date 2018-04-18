from .base import *

import os

ADMINS = [
    ('Josef', 'josefmonje@gmail.com'),
]

EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_USE_TLS = True
EMAIL_PORT = 587
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_HOST_USER = None
EMAIL_HOST_PASSWORD = None
DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
SERVER_EMAIL = EMAIL_HOST_USER

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
