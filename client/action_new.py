from utils import *

def _doNew(cookies, namespace, instance):
  path = '/' + namespace + '/'
  method = 'POST'

  if cookies is not None and cookies.has_key('session') and cookies.has_key('key') and cookies.has_key('jwt'):
    success, data = request(method, path, instance, {
      'cookie': 'session=' + cookies['session'], 
      'auth-key': cookies['key'], 
      'authorization': cookies['jwt']
    }, processResponse)
  else:
    success, data = request(method, path, instance, { }, processResponse)

  if success:
    print(toYaml(data.decode('utf-8')))
  else:
    print(data.decode('utf-8'))

def doNew(cookiefile, specfile, datafile):
  cookies = loadYaml(cookiefile)
  specs = loadYaml(specfile)
  data = loadYaml(datafile)
  print(data)
  resource = data['resource_name']
  instances = data['instances']
  namespace = ""
  for ns in specs['namespaces']:
    if ns['resource_name'] == resource:
      namespace = ns['ns_name']
      break
  if namespace == "":
    end("no resource found")
  for instance in instances:
    _doNew(cookies, namespace, instance)
