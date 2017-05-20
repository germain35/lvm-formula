{% from "lvm/map.jinja" import lvm with context %}

{% set lvs = salt['pillar.get']('lvm:absent:lvs', {}) %}

include:
  - lvm.install
  - lvm.unmount

{% for lv_name, lv_params in lvs.items() %}
lvm_vg_{{lv_params.vg}}_lv_{{lv_name}}_absent:
  lvm.lv_absent:
    - name: {{lv_name}}
    - vgname: {{lv_params.vg}}
    - require:
      - sls: lvm.unmount
{% endfor %}
