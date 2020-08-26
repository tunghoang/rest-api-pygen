from flask_restplus import Api
api = Api(title="{{title}}", version="{{version}}")

{% for s in namespaces -%}
from .{{s['ns_name']}} import create_api as create_{{s['ns_name']}}
api.add_namespace(create_{{s['ns_name']}}())
{% endfor %}
