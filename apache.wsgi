import os
activate_this = os.path.join('/app/ckan/bin/activate_this.py')
execfile(activate_this, dict(__file__=activate_this))

from paste.deploy import loadapp
config_filepath = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'ckan.ini')
from paste.script.util.logging_config import fileConfig
fileConfig(config_filepath)
_application = loadapp('config:%s' % config_filepath)

def application(environ, start_response):
    environ['wsgi.url_scheme'] = environ.get('HTTP_X_URL_SCHEME', 'http')
    return _application(environ, start_response)
