import os

try:
    from future.standard_library import install_aliases
    install_aliases()
except ImportError:
    pass
finally:
    from urllib.request import urlopen
    from urllib.error import URLError

from .base import *

ADMINS = [
    ('Josef', 'josefmonje@gmail.com'),
]

EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_USE_TLS = True
EMAIL_PORT = 587
EMAIL_HOST = 'smtp.gmail.com'
EMAIL_HOST_USER = os.environ['EMAIL_HOST_USER']
EMAIL_HOST_PASSWORD = os.environ['EMAIL_HOST_PASSWORD']
DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
SERVER_EMAIL = EMAIL_HOST_USER

SECRET_KEY = os.environ['SECRET_KEY']

DEBUG = False

ALLOWED_HOSTS = [
    'localhost',
    '127.0.0.1',
]

try:
    ipv4_api = 'http://instance-data/latest/meta-data/public-ipv4'
    HOST_IP = urlopen(ipv4_api).read().decode()
    ALLOWED_HOSTS.append(HOST_IP)
except URLError:
    pass

with open('/home/ubuntu/var/url.loadbalancer') as file:
    loadbalancer = file.read().strip()
    ALLOWED_HOSTS.append(loadbalancer)

try:
    from .local import *
except ImportError:
    pass
