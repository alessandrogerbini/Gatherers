import os, datetime
ROOT_PATH = os.path.dirname(__file__)

# Django needs absolute paths for template rendering
CONTENT_DIR = os.path.join(ROOT_PATH,'content')
DEPLOY_DIR = os.path.join(ROOT_PATH,'deploy')

IGNORE = (
    'sass',
    'coffee',
    'media_includes',
)


# Add handlers for different filetypes here.
# e.g. template renderers, CSS compressors, JS compilers, etc...

PROCESSORS = {
    '.django': 'handle_django',
}

# Django template rendering stuff
TEMPLATE_DIRS = (
    os.path.join(ROOT_PATH,'content'),
)

CONTEXT = {

}

try:
    from local_settings import *
except ImportError:
    pass