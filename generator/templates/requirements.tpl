{% for requirement in requirements -%}
{{ requirement }}=={{ requirements[requirement] }}
{% endfor -%}