from sqlalchemy import ForeignKey, Column, BigInteger, Integer, Float, String, Boolean, Date, DateTime, Text
from sqlalchemy.schema import UniqueConstraint
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
  {%- elif prop['foreign_key'] is defined and prop['notnull'] %}
  {{prop['name']}} = Column({{prop['type']}}{{prop['type_specs']}}, ForeignKey('{{prop['foreign_key']}}'), nullable=False)
  {%- elif prop['foreign_key'] is defined and not prop['notnull'] %}
  {{prop['name']}} = Column({{prop['type']}}{{prop['type_specs']}}, ForeignKey('{{prop['foreign_key']}}'))
  {%- elif prop['foreign_key'] is not defined and prop['notnull'] %}
  {{prop['name']}} = Column({{prop['type']}}{{prop['type_specs']}}, nullable=False)
  {%- elif prop['foreign_key'] is not defined and not prop['notnull'] %}
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

def __doFind(model):
  return []
{% else %}

class {{resource_name|capitalize}}(__db.Base):
  __tablename__ = "{{resource_name}}"

{%- for prop in props %}
  {%- if prop['primary_key'] %}
  {{prop['name']}} = Column({{prop['type']}}{{prop['type_specs']}}, primary_key = True)
  {%- elif prop['foreign_key'] is defined %}
    {%- if prop['notnull'] %}
  {{prop['name']}} = Column({{prop['type']}}{{prop['type_specs']}}, nullable=False, ForeignKey('{{prop['foreign_key']}}'))
    {%- else %}
  {{prop['name']}} = Column({{prop['type']}}{{prop['type_specs']}}, ForeignKey('{{prop['foreign_key']}}'))
    {%- endif %}
  {%- else %}
    {%- if prop['notnull'] %}
  {{prop['name']}} = Column({{prop['type']}}{{prop['type_specs']}}, nullable=False)
    {%- else %}
  {{prop['name']}} = Column({{prop['type']}}{{prop['type_specs']}})
    {%- endif %}
  {%- endif %}
{%- endfor %}

  constraints = list()
{%- for unique in uniques %}
  constraints.append(UniqueConstraint({%- for key in unique['keys'] -%}
    {%- if loop.last -%}
      '{{key['name']}}'
    {%- else -%}
      '{{key['name']}}',
    {%- endif -%}
  {%- endfor -%}))
{%- endfor %}
  if len(constraints) > 0:
    __table_args__ = tuple(constraints)
 
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
  result = __db.session().query({{resource_name|capitalize}}).all()
  __db.session().commit()
  return result  
  
def __doNew(instance):
  __db.session().add(instance)
  __db.session().commit()
  return instance

def __doGet(id):
  instance = __db.session().query({{resource_name|capitalize}}).filter({{resource_name|capitalize}}.id{{resource_name|capitalize}} == id).scalar()
  doLog("__doGet: {}".format(instance))
  __db.session().commit()
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
def __doFind(model):
  results = __db.session().query({{resource_name|capitalize}}).filter_by(**model).all()
  __db.session().commit()
  return results
{% endif %}

def list{{resource_name|capitalize}}s():
  doLog("list DAO function")
  try:
    return __doList()
  except OperationalError as e:
    doLog(e)
    __recover()
    return __doList()
  except InterfaceError as e:
    doLog(e)
    __recover()
    return __doList()
  except SQLAlchemyError as e:
    __db.session().rollback()
    raise e

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
  except SQLAlchemyError as e:
    __db.session().rollback()
    raise e

def get{{resource_name|capitalize}}(id):
  doLog("get DAO function", id)
  try:
    return __doGet(id)
  except OperationalError as e:
    doLog(e)
    __recover()
    return __doGet(id)
  except InterfaceError as e:
    doLog(e)
    __recover()
    return __doGet(id)
  except SQLAlchemyError as e:
    __db.session().rollback()
    raise e

def update{{resource_name|capitalize}}(id, model):
  doLog("update DAO function. Model: {}".format(model))
  try:
    return __doUpdate(id, model)
  except OperationalError as e:
    doLog(e)
    __recover()
    return __doUpdate(id, model)
  except SQLAlchemyError as e:
    __db.session().rollback()
    raise e

def delete{{resource_name|capitalize}}(id):
  doLog("delete DAO function", id)
  try:
    return __doDelete(id)
  except OperationalError as e:
    doLog(e)
    __recover()
    return __doDelete(id)
  except SQLAlchemyError as e:
    __db.session().rollback()
    raise e

def find{{resource_name|capitalize}}(model):
  doLog("find DAO function %s" % model)
  try:
    return __doFind(model)
  except OperationalError as e:
    doLog(e)
    __recover()
    return __doFind(model)
  except SQLAlchemyError as e:
    __db.session().rollback()
    raise e
