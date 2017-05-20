{% from "lvm/map.jinja" import lvm with context %}

{% set vgs = salt['pillar.get']('lvm:absent:vgs', {}) %}

include:
  - lvm.install
  - lvm.unmount
  - lvm.lv_remove

{% for vg_name in vgs %}
lvm_vg_{{vg_name}}_absent:
  lvm.vg_absent:
    - name: {{vg_name}}
    - require:
      - sls: lvm.lv_remove
{% endfor %}
