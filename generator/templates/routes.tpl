from flask_restplus import Resource
from .db import *

def init_routes(api, model):
  @api.route('/')
  class ListInstances(Resource):
    {%- if list_api is defined %}
    @api.doc("{{list_api}}")
    @api.marshal_list_with(model)
    def get(self):
      '''{{list_api_description}}'''
      return list{{resource_name|capitalize}}s()
    {%- endif %}
    {%- if new_api is defined %}
    @api.doc('{{new_api}}', body=model)
    @api.expect(model)
    @api.marshal_with(model)
    def post(self):
      '''{{new_api_description}}'''
      return new{{resource_name|capitalize}}(api.payload)
    {%- endif %}

  @api.route('/<int:id>')
  class Instance(Resource):
    {%- if get_api is defined %}
    @api.doc('{{get_api}}')
    @api.marshal_with(model)
    def get(self, id):
      '''{{get_api_description}}'''
      return get{{resource_name|capitalize}}(id)
    {%- endif %}
    {%- if update_api is defined %}
    @api.doc('{{update_api}}', body=model)
    @api.expect(model)
    @api.marshal_with(model)
    def put(self, id):
      '''{{update_api_description}}'''
      return update{{resource_name|capitalize}}(id, api.payload)
    {%- endif %}
    {%- if delete_api is defined %}
    @api.doc('{{delete_api}}')
    @api.marshal_with(model)
    def delete(self, id):
      '''{{delete_api_description}}'''
      return delete{{resource_name|capitalize}}(id)
    {%- endif %}
    {%- if find_api is defined %}
    @api.doc('{{find_api}}')
    @api.expect(model)
    @api.marshal_list_with(model)
    def post(self, id):
      '''{{find_api_description}}'''
      return find{{resource_name|capitalize}}(id, api.payload)
    {%- endif %}
    pass
