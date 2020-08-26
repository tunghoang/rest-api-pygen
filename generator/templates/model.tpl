from flask_restplus import fields

def create_model(api):
  model = api.model('{{resource_name}}', { 
    {%- for prop in props %}
    {%- if loop.last %}
    '{{prop['name']}}': fields.{{prop['type']}}
    {%- else %}
    '{{prop['name']}}': fields.{{prop['type']}},
    {%- endif %}
    {%- endfor %} 
  });
  return model
