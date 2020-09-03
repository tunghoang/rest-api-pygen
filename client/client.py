from getopt import getopt
import sys

from action_login import *
from action_list import *

def help() :
  print('This is help')  

def main(args):
  print(args)
  action = None
  datafile ='data.csv'
  specfile = 'specs.yaml'
  cookiefile = 'cookies.yaml'
  resource = None
  try:
    optlist, _ = getopt(args, '', ['action=', 'file=', 'specs=', 'resource=', 'cookies='])
    for opt in optlist:
      if opt[0] == '--action':
        action = opt[1]
      elif opt[0] == '--file':
        datafile = opt[1]
      elif opt[0] == '--specs':
        specfile = opt[1]
      elif opt[0] == '--resource':
        resource = opt[1]
      elif opt[0] == '--cookies':
        cookiefile = opt[1]
  except:
    help()
  print("datafile: %s, specfile: %s, cookiefile: %s, resource: %s" % (datafile, specfile, cookiefile, resource))
  if action == 'login':
    doLogin(cookiefile, datafile)
  elif action == 'list':
    doList(cookiefile, specfile, resource)

  print("End")


if __name__ == '__main__' :
  main(sys.argv[1:])
