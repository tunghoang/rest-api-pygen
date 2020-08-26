from sqlalchemy import ForeignKey, Column, Integer, String, Boolean, Date, DateTime
from sqlalchemy.orm import relationship
from ..db_utils import DbInstance

__db = DbInstance.getInstance()

class {{resource_name|capitalize}}(__db.Base):
  __tablename__ = "{{resource_name}}"

{%- for prop in props %}
  {%- if prop['primary_key'] %}
  {{prop['name']}} = Column({{prop['type']}}{{prop['type_specs']}}, primary_key = True)
  {%- elif prop['foreign_key'] is defined %}
  {{prop['name']}} = Column({{prop['type']}}{{prop['type_specs']}}, ForeignKey('{{prop['foreign_key']}}'))
  {%- else %}
  {{prop['name']}} = Column({{prop['type']}}{{prop['type_specs']}})
  {%- endif %}
{%- endfor %}

  def __init__(self, dictModel):
  {%- for prop in props %}
    if ("{{prop['name']}}" in dictModel) and (dictModel["{{prop['name']}}"] != None):
      self.{{prop['name']}} = dictModel["{{prop['name']}}"]
  {%- endfor %}

  def __repr__(self):
    return '<{{resource_name|capitalize}} {% for prop in props -%} {{prop["name"]}}={} {% endfor %}>'.format({% for prop in props -%}self.{{prop['name']}}, {% endfor %})

  def update(self, dictModel):
  {%- for prop in props %}
    if ("{{prop['name']}}" in dictModel) and (dictModel["{{prop['name']}}"] != None):
      self.{{prop['name']}} = dictModel["{{prop['name']}}"]
  {%- endfor %}


def __doList():
  return __db.session().query({{resource_name|capitalize}}).all()
  
def list{{resource_name|capitalize}}s():
  print("list DAO function")
  try:
    return __doList()
  except:
    __db.newSession()
    return __doList()

def __doNew(instance):
  __db.session().add(instance)
  __db.session().commit()

def new{{resource_name|capitalize}}(model):
  print("new DAO function. model: {}".format(model))
  instance = {{resource_name|capitalize}}(model)
  try:
    __doNew(instance)
  except:
    __db.newSession()
    __doNew(instance)
  return model


def __doGet(id):
  instance = __db.session().query({{resource_name|capitalize}}).filter({{resource_name|capitalize}}.id{{resource_name|capitalize}} == id).scalar()
  print("__doGet: {}".format(instance))
  return instance

def get{{resource_name|capitalize}}(id):
  print("get DAO function", id)
  try:
    return __doGet(id)
  except:
    __db.newSession()
    return __doGet(id)

def __doUpdate(id, model):
  instance = get{{resource_name|capitalize}}(id)
  if instance == None:
    return {}
  instance.update(model)
  __db.session().commit()
  return instance

def update{{resource_name|capitalize}}(id, model):
  print("update DAO function. Model: {}".format(model))
  try:
    return __doUpdate(id, model)
  except:
    __db.newSession()
    return __doUpdate(id, model)

def __doDelete(id):
  instance = get{{resource_name|capitalize}}(id)
  __db.session().delete(instance)
  __db.session().commit()
  return instance


def delete{{resource_name|capitalize}}(id):
  print("delete DAO function", id)
  try:
    return __doDelete(id)
  except:
    __db.newSession()
    return __doDelete(id)
