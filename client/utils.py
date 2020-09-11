import json
import sys
from yaml import load, dump, Loader, Dumper
from http import client, cookies
conn = client.HTTPConnection("localhost:8000")

def request(method, path, payload, headers, process):
  hdrs = {
    'accept': "application/json",
    'content-type': "application/json"
  }
  for k in headers:
    hdrs[k] = headers[k]

  conn.request(method, path, json.dumps(payload), hdrs)
  res = conn.getresponse()
  return process(res)
  
def post(path, payload,headers, process):
  hdrs = {
    'accept': "application/json",
    'content-type': "application/json"
  }
  for k in headers:
    hdrs[k] = headers[k]

  conn.request('POST', path, payload, hdrs)
  res = conn.getresponse()
  return process(res)

def get(path, payload, headers, process):
  hdrs = {
    'accept': "application/json",
    'content-type': "application/json"
  }
  for k in headers:
    hdrs[k] = headers[k]

  conn.request('GET', path, headers=hdrs)
  res = conn.getresponse()
  return process(res)

def loadYaml(fname):
  with open(fname, 'r') as f:
    return load(f, Loader = Loader)

def writeYaml(fname, data):
  with open(fname, 'w') as f:
    f.write(dump(data, Dumper = Dumper))
    f.close()

def toYaml(data):
  return dump(data, Dumper = Dumper, allow_unicode=True)

def end(message):
  print(message)
  sys.exit()

def processResponse(res):
  data = res.read()
  if res.status == 200: 
    return True, data
  return False,data
