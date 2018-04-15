from .base import *

import os

DEBUG = False

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "mysite.settings.production")
SECRET_KEY = os.environ.setdefault("SECRET_KEY", "am9zZWZtb25qZW15c2l0ZQo=")

try:
    from .local import *
except ImportError:
    pass
