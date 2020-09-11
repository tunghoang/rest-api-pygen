from utils import *
from datetime import datetime

def toObj(config, inputfile = "", objs = None):
  objs = objs if objs != None else loadYaml(inputfile)
  for obj in objs:
    try:
      dtObj = datetime.strptime(obj[config['name']], config['format'])
      obj[config['name']] = dtObj.date().isoformat()
    except:
      pass
  return objs
