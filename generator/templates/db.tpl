from sqlalchemy import ForeignKey, Column, Integer, String, Boolean, Date, DateTime, Text
from sqlalchemy.orm import relationship
from sqlalchemy.exc import *
from ..db_utils import DbInstance
from ..app_utils import *
from werkzeug.exceptions import *
from flask import session,request,after_this_request

__db = DbInstance.getInstance()

{% if (nodb is defined) and nodb %}
class {{resource_name|capitalize}}:
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

  def json(self):
    return {
      {% for prop in props -%} "{{prop['name']}}":self.{{prop['name']}},{% endfor %}
    }

  def update(self, dictModel):
  {%- for prop in props %}
    if ("{{prop['name']}}" in dictModel) and (dictModel["{{prop['name']}}"] != None):
      self.{{prop['name']}} = dictModel["{{prop['name']}}"]
  {%- endfor %}

def __recover():
  pass

def __doList():
  return []
  
def __doNew(instance):
  return {}

def __doUpdate(id, model):
  return {}

def __doDelete(id):
  return {}
{% else %}

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

  def json(self):
    return {
      {% for prop in props -%} "{{prop['name']}}":self.{{prop['name']}},{% endfor %}
    }

  def update(self, dictModel):
  {%- for prop in props %}
    if ("{{prop['name']}}" in dictModel) and (dictModel["{{prop['name']}}"] != None):
      self.{{prop['name']}} = dictModel["{{prop['name']}}"]
  {%- endfor %}

def __recover():
  __db.newSession()

def __doList():
  return __db.session().query({{resource_name|capitalize}}).all()
  
def __doNew(instance):
  __db.session().add(instance)
  __db.session().commit()
  return instance

def __doGet(id):
  instance = __db.session().query({{resource_name|capitalize}}).filter({{resource_name|capitalize}}.id{{resource_name|capitalize}} == id).scalar()
  doLog("__doGet: {}".format(instance))
  return instance

def __doUpdate(id, model):
  instance = get{{resource_name|capitalize}}(id)
  if instance == None:
    return {}
  instance.update(model)
  __db.session().commit()
  return instance
def __doDelete(id):
  instance = get{{resource_name|capitalize}}(id)
  __db.session().delete(instance)
  __db.session().commit()
  return instance
{% endif %}



def list{{resource_name|capitalize}}s():
  doLog("list DAO function")
  try:
    return __doList()
  except OperationalError as e:
    doLog(e)
    __recover()
    return __doList()

def new{{resource_name|capitalize}}(model):
  doLog("new DAO function. model: {}".format(model))
  instance = {{resource_name|capitalize}}(model)
  res = False
  try:
    return __doNew(instance)
  except OperationalError as e:
    doLog(e)
    __recover()
    return __doNew(instance)

def get{{resource_name|capitalize}}(id):
  doLog("get DAO function", id)
  try:
    return __doGet(id)
  except OperationalError as e:
    doLog(e)
    __recover()
    return __doGet(id)

def update{{resource_name|capitalize}}(id, model):
  doLog("update DAO function. Model: {}".format(model))
  try:
    return __doUpdate(id, model)
  except OperationalError as e:
    doLog(e)
    __recover()
    return __doUpdate(id, model)

def delete{{resource_name|capitalize}}(id):
  doLog("delete DAO function", id)
  try:
    return __doDelete(id)
  except OperationalError as e:
    doLog(e)
    __recover()
    return __doDelete(id)
