from flask_restplus import Resource
from .db import *

def init_routes(api, model):
  @api.route('/')
  class ListInstances(Resource):
    @api.doc("{{list_api}}")
    @api.marshal_list_with(model)
    def get(self):
      '''{{list_api_description}}'''
      return list{{resource_name|capitalize}}s()

    @api.doc('{{new_api}}', body=model)
    @api.expect(model)
    @api.marshal_with(model)
    def post(self):
      '''{{new_api_description}}'''
      return new{{resource_name|capitalize}}(api.payload)

  @api.route('/<int:id>')
  class Instance(Resource):
    @api.doc('{{get_api}}')
    @api.marshal_with(model)
    def get(self, id):
      '''{{get_api_description}}'''
      return get{{resource_name|capitalize}}(id)

    @api.doc('{{update_api}}', body=model)
    @api.expect(model)
    @api.marshal_with(model)
    def put(self, id):
      '''{{update_api_description}}'''
      return update{{resource_name|capitalize}}(id, api.payload)

    @api.doc('{{delete_api}}')
    @api.marshal_with(model)
    def delete(self, id):
      '''{{delete_api_description}}'''
      return delete{{resource_name|capitalize}}(id)
