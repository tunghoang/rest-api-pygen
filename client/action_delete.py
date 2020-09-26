from utils import *

def _doDelete(cookies, namespace, id):
  path = '/' + namespace + '/' + str(id)
  method = 'DELETE'

  if cookies is not None and 'session' in cookies and 'key' in cookies and 'jwt' in cookies:
    success, data = request(method, path, {}, {
      'cookie': 'session=' + cookies['session'], 
      'auth-key': cookies['key'], 
      'authorization': cookies['jwt']
    }, processResponse)
  else:
    success, data = request(method, path, {}, {}, processResponse)

  if success:
    print(toYaml(data.decode('utf-8')))
  else:
    print(data.decode('utf-8'))

def doDelete(cookiefile, specfile, datafile):
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
    _doDelete(cookies, namespace, instance['id' + resource.capitalize()])
