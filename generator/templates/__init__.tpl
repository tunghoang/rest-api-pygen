from .model import create_model
from .routes import init_routes
from .db import {{resource_name|capitalize}}
from flask_restplus import Namespace

def create_api():
  api = Namespace('{{ns_name}}', description="{{ns_description}}")
  model = create_model(api)
  init_routes(api, model)
  return api
