{% from "lvm/map.jinja" import lvm with context %}

{% set vgs = salt['pillar.get']('lvm:vgs', {}) %}

include:
  - lvm.install
  - lvm.vg

{% for vg_name, vg_params in vgs.items() %}
  {% for lv_name, lv_params in vg_params.get('lvs', {}).items() %}
lvm_vg_{{vg_name}}_lv_{{lv_name}}:
  lvm.lv_present:
    - name: {{lv_name}}
    - vgname: {{vg_name}}
    - size: {{lv_params.size}}
    - require:
      - sls: lvm.vg
  {% endfor %}
{% endfor %}
