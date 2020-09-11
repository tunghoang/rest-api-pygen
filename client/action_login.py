from utils import *
def processLoginResponse(res):
  success, data = processResponse(res)
  if success: 
    cookieData = res.getheader('set-cookie')
    cookieParser = cookies.SimpleCookie()
    cookieParser.load(cookieData)
    session = cookieParser['session'].value
    key = res.getheader('x-key')
    jwt = res.getheader('x-jwt')
    return True, {'session': session, 'key': key, 'jwt': jwt}

  return False,data

def doLogin(cookiefile, datafile):
  credential = loadYaml(datafile)
  success, data = post('/login/', json.dumps(credential), {}, processLoginResponse)
  if success:
    writeYaml(cookiefile, data)
  else:
    print(data)

