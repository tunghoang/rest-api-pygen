#!/bin/python
from getopt import getopt
import sys

from action_login import *
from action_list import *
from action_new import *
from action_delete import *
from action_logout import *

def help() :
  print('This is help')  

def main(args):
  #print("======= %s ========" % args, file=sys.stderr)
  action = None
  datafile =''
  specfile = ''
  cookiefile = ''
  queryfile = ''
  configfile = ''
  base = 'localhost:8000'
  no_cookies = False
  try:
    optlist, _ = getopt(args, 'c:a:d:s:q:k:b:', ['config=', 'action=', 'file=', 'specs=', 'query=', 'cookies=', "base=", "no-cookies"])
    for opt in optlist:
      if opt[0] == '--config' or opt[0] == '-c':
        configfile = opt[1]
      if opt[0] == '--action' or opt[0] == '-a':
        action = opt[1]
      elif opt[0] == '--file' or opt[0] == '-d':
        datafile = opt[1]
      elif opt[0] == '--specs' or opt[0] == '-s':
        specfile = opt[1]
      elif opt[0] == '--query' or opt[0] == '-q':
        queryfile = opt[1]
      elif opt[0] == '--cookies' or opt[0] == '-k':
        cookiefile = opt[1]
      elif opt[0] == '--base' or opt[0] == '-b':
        base = opt[1]
      elif opt[0] == '--no-cookies':
        no_cookies = True
  except:
    help()

  if len(configfile) > 0 :
    config = loadYaml(configfile)
    action = action if action != None and len(action) > 0 else config['action']
    datafile = datafile if len(datafile) > 0 else config['datafile']
    specfile = specfile if len(specfile) > 0 else config['specfile']
    cookiefile = cookiefile if len(cookiefile) > 0 else config['cookiefile']
    queryfile = queryfile if len(queryfile) > 0 else config['queryfile']

  initConn(base)

  if action == 'login':
    doLogin(cookiefile, datafile)
  elif action == 'list':
    doList(cookiefile, specfile, queryfile)
  elif action == 'new':
    doNew(cookiefile, specfile, datafile)
  elif action == 'delete':
    doDelete(cookiefile, specfile, datafile)
  elif action == 'logout':
    doLogout(cookiefile)

if __name__ == '__main__' :
  main(sys.argv[1:])
