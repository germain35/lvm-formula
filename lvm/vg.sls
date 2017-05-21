{% from "lvm/map.jinja" import lvm with context %}

{% set vgs = salt['pillar.get']('lvm:present:vgs', {}) %}

include:
  - lvm.install

{% for vg_name, vg_params in vgs.items() %}
lvm_vg_{{vg_name}}:
  lvm.vg_present:
    - name: {{vg_name}}
    - devices: {{ vg_params.devices }}
    - require:
      - sls: lvm.install
{% endfor %}
