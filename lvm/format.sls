{% from "lvm/map.jinja" import lvm with context %}

{% set vgs = salt['pillar.get']('lvm:vgs', {}) %}

include:
  - lvm.install
  - lvm.vg
  - lvm.lv

{% for vg_name, vg_params in vgs.items() %}
  {% for lv_name, lv_params in vg_params.get('lvs', {}).items() %}
lvm_vg_{{vg_name}}_lv_{{lv_name}}_format:
  blockdev.formatted:
    - name: /dev/{{vg_name}}/{{lv_name}}
    - fs_type: {{lv_params.fs_type}}
    - force: True
    - require:
      - sls: lvm.lv
  {% endfor %}
{% endfor %}
