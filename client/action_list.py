from utils import *

def processListResponse(res):
  data = res.read()
  if res.status == 200: 
    return True, data

  return False,data

def doList(cookiefile, specfile, resource):
  specs = loadYaml(specfile)
  cookies = loadYaml(cookiefile)
  resourceMeta = None
  path = None
  for ns in specs['namespaces']:
    if resource == ns['resource_name']:
      resourceMeta = ns['props']
      path = '/'+ns['ns_name']+'/'
  success, data = get(path, {
    'cookie': 'session='+ cookies['session'], 
    'auth-key': cookies['key'], 
    'authorization': cookies['jwt']
  }, processListResponse)
  if success:
    toYaml(data.decode('utf-8'))
  else:
    print(data.decode('utf-8'))

