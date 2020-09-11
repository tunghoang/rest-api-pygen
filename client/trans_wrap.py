from utils import *

def toObj(config, inputfile = '', objs = None):
  wrapObj = {}
  objs = objs if objs != None else loadYaml(inputfile)
  wrapObj[config['name']] = config['value']
  wrapObj[config['wrap']] = objs
  return wrapObj
