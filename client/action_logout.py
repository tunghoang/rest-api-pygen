from utils import *

def processResponse(res):
  data = res.read()
  if res.status == 200: 
    return True, data

  return False,data

def doLogout(cookiefile):
  cookies = loadYaml(cookiefile)
  method = 'GET'
  path = '/logout/'
  success, data = request(method, path, {}, {
    'cookie': 'session='+ cookies['session'], 
    'auth-key': cookies['key'], 
    'authorization': cookies['jwt']
  }, processResponse)
  if success:
    print(toYaml(data.decode('utf-8')))
  else:
    print(data.decode('utf-8'))

