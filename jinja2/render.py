#!/usr/bin/env python
#
# 
"""\

"""
# Make coding more python3-ish
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

import os
import jinja2
import sys 

TEMPLATE = os.environ.get('TEMPLATE')
TEMPLATES_DIR = os.environ.get('TEMPLATES_DIR')
JINJA_ENVIRONMENT = jinja2.Environment(
    loader=jinja2.FileSystemLoader(TEMPLATES_DIR),
    extensions=['jinja2.ext.autoescape', 'jinja2.ext.do', 'jinja2.ext.loopcontrols', 'jinja2.ext.with_'],
    autoescape=True)
# [END imports]

def env_override(value, key):
  return os.getenv(key, value)

def render_template(argv):
    # our template values are just passed in as cli arguments (e.g. key=value);
    # so parse them into a dictionary that jinja2 template will accept
    context = {}
    for cliarg in argv:
        x = cliarg.split('=')
        context[x[0]] = x[1]
    
    JINJA_ENVIRONMENT.filters['env_override'] = env_override 
    template = JINJA_ENVIRONMENT.get_template(TEMPLATE)
    sys.stdout.write(template.render(context))
    
if __name__ == '__main__':
    render_template(sys.argv[1:])
