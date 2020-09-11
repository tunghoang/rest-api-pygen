import sys
from utils import *
from getopt import getopt
from importlib import import_module

def help():
  print('Help')

def __doIt(configfile, inputfile='', objs = None):
  config = loadYaml(configfile)
  transform = config['transform']
  tflib = import_module("trans_" + transform)
  result = tflib.toObj(config, inputfile=inputfile, objs=objs)
  return result

def processChain(configchain, inputfile):
  chain = configchain.split(':')
  objs = __doIt(chain[0], inputfile=inputfile)
  for ch in chain[1:] :
    objs = __doIt(ch, objs = objs)
  return objs

configfile ='column.yaml'
inputfile = 'input.csv'
configchain = ''

try:
  optlist, _ = getopt(sys.argv[1:], 'i:c:C:', ['input=', 'config=', 'config-chain='])
  for opt in optlist:
    if opt[0] == '-i' or opt[0] == '--input' :
      inputfile = opt[1]
    elif opt[0] == '-c' or opt[0] == '--config' :
      configfile = opt[1]
    elif opt[0] == '-C' or opt[0] == '--config-chain' :
      configchain = opt[1]

except:
  help()

if len(configchain) > 0 :
  result = processChain(configchain, inputfile)
else:
  result = __doIt(configfile, inputfile = inputfile)

print(toYaml(result))
