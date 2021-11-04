from jinja2 import Environment,FileSystemLoader
import yaml
import sys
import os
from getopt import gnu_getopt

def file_content(filename):
  try:
    content = None
    f = open(filename, 'r')
    content = f.read()
    f.close()
    return content
  except:
    return None

def gen_namespace(nsconfig, location):
  gen_file(config=nsconfig,template_file='routes.tpl', output_file=os.path.join(location, 'routes.py'))
  gen_file(config=nsconfig,template_file='model.tpl', output_file=os.path.join(location, 'model.py'))
  gen_file(config=nsconfig,template_file='db.tpl', output_file=os.path.join(location, 'db.py'))
  gen_file(config=nsconfig,template_file='__init__.tpl', output_file=os.path.join(location, '__init__.py'))

def prepare_dir(odir):
  if os.path.isdir(odir):
    pass
  elif not os.path.exists(odir):
    os.makedirs(odir, exist_ok=True)
  else:
    sys.exit('%s exists' % output_dir)

def gen_file_content(config, template_file):
  tpl = env.get_template(template_file)
  output = tpl.render(config)
  return output

def merge_content(old_content, new_content):
  patches = dmp.patch_make(old_content, new_content)
  print(dmp.patch_toText(patches))
  result, _ = dmp.patch_apply(patches, old_content)
  print(result)
  return result
  
def gen_file(config, template_file='app.tpl', output_file='app.py'):
  output = gen_file_content(config, template_file)
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
  # gen gconfig
  gen_file(config = config, template_file = 'gconfig.tpl', output_file = 'gconfig.py')
  # gen app.py
  gen_file(config) 
  # gen main__init__.py
  gen_file(config = config, template_file = 'main__init__.tpl', output_file = os.path.join(output_dir, '__init__.py'))
  # gen config_utils.py
  gen_file(config = config, template_file = 'config_utils.tpl', output_file = os.path.join(output_dir, 'config_utils.py'))
  # gen db_utils.py
  gen_file(config = config, template_file = 'db_utils.tpl', output_file = os.path.join(output_dir, 'db_utils.py'))
  # gen app_utils.py
  gen_file(config = config, template_file = 'app_utils.tpl', output_file = os.path.join(output_dir, 'app_utils.py'))
  for ns in namespaces:
    odir = os.path.join(output_dir, ns['ns_name'])
    prepare_dir(odir)
    gen_namespace(ns, odir)
