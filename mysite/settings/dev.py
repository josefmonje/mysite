try:
    from future.standard_library import install_aliases
    install_aliases()
except ImportError:
    pass
finally:
    from urllib.request import urlopen
    from urllib.error import URLError

from .base import *

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = ')e!$h3b7l(gsb#t1k+16sscq6p=)%8j=#)ous^z&esu5b676r&'

EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

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

try:
    from .local import *
except ImportError:
    pass
