def __parse(columns, line):
  obj = {}
  tokens = line.split("\t")
  for i in range(0, len(tokens)):
    if i in columns:
      obj[columns[i]] = tokens[i]
  return obj

def toObj(config, inputfile='', objs = None):
  result = []
  f = open(inputfile, 'r', encoding='utf-8')
  lines = f.readlines()
  for line in lines:
    obj = __parse(config, line)
    result.append(obj)
  return result
