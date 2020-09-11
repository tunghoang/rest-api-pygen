from utils import *
def toObj(config, inputfile = '', objs = None):
  objs = objs if objs != None else loadYaml(inputfile)
  for obj in objs:
    if obj[config['name']] == config['test']:
      obj[config['name']] = config['value']
  return objs
