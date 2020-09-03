from flask_restplus.fields import Integer, String, String as Text, Date, DateTime, Boolean

def create_model(api):
  model = api.model('{{resource_name}}', { 
    {%- for prop in props %}
    {%- if loop.last %}
    '{{prop['name']}}': {{prop['type']}}
    {%- else %}
    '{{prop['name']}}': {{prop['type']}},
    {%- endif %}
    {%- endfor %} 
  }, {%- if mask is defined -%}
    mask='{{mask}}'
  {%- else -%}
    mask='*'
  {%- endif -%});
  return model
