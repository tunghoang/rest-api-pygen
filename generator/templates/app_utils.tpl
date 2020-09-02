from hashlib import sha256
from flask import jsonify
from jwt import encode, decode
SALT = 'hwman'
def doHash(str):
  str1 = 'SALT' + str
  hashObj = sha256(str1.encode('UTF-8'))
  return hashObj.hexdigest()
def doGenJWT(obj, salt):
  return encode(obj, salt)
def doParseJWT(key, salt):
  try:
    return decode(key, salt)
  except: 
    return None
def doLog(message, error = False):
  if error:
    print("*** %s" % message)
  else:
    print("--- %s" % message)
def doAuthenticate(request):
  secret = request.cookies.get('key')
  jwtKey = request.cookies.get('jwt')
  doLog("Do AUTHENTICATION " + secret + " " + jwtKey)
  return True
