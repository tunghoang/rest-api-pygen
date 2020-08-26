from jinja2 import Environment,FileSystemLoader
import yaml
import sys
import os
from getopt import gnu_getopt

def gen_file(config, template, location):
  tpl = env.get_template(template + '.tpl')
  output = tpl.render(config)
  f = open(os.path.join(location, template + '.py'), 'w')
  f.write(output)
  f.close()

def gen_namespace(nsconfig, location):
  gen_file(nsconfig,'routes', location)
  gen_file(nsconfig,'model', location)
  gen_file(nsconfig,'db', location)
  gen_file(nsconfig,'__init__', location)

def prepare_dir(odir):
  if os.path.isdir(odir):
    pass
  elif not os.path.exists(odir):
    os.makedirs(odir, exist_ok=True)
  else:
    sys.exit('%s exists' % output_dir)

def gen_file1(config, template_file='app.tpl', output_file='app.py'):
  tpl = env.get_template(template_file)
  output = tpl.render(config)
  f = open(output_file, 'w')
  f.write(output)
  f.close()

print('ARGV: {}'.format(sys.argv[1:]))

options,remainder = gnu_getopt(sys.argv[1:], "d:s:", ["template-dir=", "spec-file="])

spec_file = '../specs/apple.yaml'
template_dir = 'templates'
output_dir = 'apis'

for opt,arg in options:
  if opt in ('-d', '--template-dir'):
    template_dir = arg
  elif opt in ('-s', '--spec-file'):
    spec_file = arg

prepare_dir(output_dir)

file_loader = FileSystemLoader(template_dir)
env = Environment(loader=file_loader)

with open(spec_file) as f:
  config = yaml.load(f, Loader=yaml.FullLoader)
  namespaces = config['namespaces']
  # gen app.py
  gen_file1(config) 
  # gen main__init__.py
  gen_file1(config = config, template_file = 'main__init__.tpl', output_file = os.path.join(output_dir, '__init__.py'))
  # gen db_utils.py
  gen_file1(config = config, template_file = 'db_utils.tpl', output_file = os.path.join(output_dir, 'db_utils.py'))
  for ns in namespaces:
    odir = os.path.join(output_dir, ns['ns_name'])
    prepare_dir(odir)
    gen_namespace(ns, odir)
