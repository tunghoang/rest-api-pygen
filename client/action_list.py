from utils import *

def doList(cookiefile, specfile, queryfile):
  specs = loadYaml(specfile)
  query = loadYaml(queryfile)
  cookies = loadYaml(cookiefile)
  resourceMeta = None
  path = None
  method = query['method'] if 'method' in query else 'GET'
  payload = query['payload'] if 'payload' in query else None
  for ns in specs['namespaces']:
    print(ns['resource_name'], query['resource_name'])
    if query['resource_name'] == ns['resource_name']:
      resourceMeta = ns['props']
      path = '/'+ns['ns_name']+'/'

  if cookies is not None and 'session' in cookies and 'key' in cookies and 'jwt' in cookies:
    success, data = request(method, path, payload, {
      'cookie': 'session='+ cookies['session'], 
      'auth-key': cookies['key'], 
      'authorization': cookies['jwt']
    }, processResponse)
  else:
    success, data = request(method, path, payload, { }, processResponse)

  if success:
    print(toYaml(json.loads(data)))
  else:
    print(data.decode('utf-8'))

