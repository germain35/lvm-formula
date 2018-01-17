{%- from "lvm/map.jinja" import lvm with context %}

{%- set vgs = salt['pillar.get']('lvm:present:vgs', {}) %}

include:
  - lvm.install
  - lvm.vg
  - lvm.lv
  - lvm.format

{%- for vg_name, vg_params in vgs.items() %}
  {%- for lv_name, lv_params in vg_params.get('lvs', {}).items() %}
    {%- if lv_params.mount|default(false) %}
lvm_vg_{{vg_name}}_lv_{{lv_name}}_mount:
  mount.mounted:
    - name: {{lv_params.mount_point}}
    - device: /dev/{{vg_name}}/{{lv_name}}
    - fstype: {{lv_params.fs_type}}
    - mkmnt: True
    - persist: {{ lv_params.persist|default(lvm.mount.persist) }}
    - opts:
      - defaults
      {%- if lv_params.format|default(lvm.format.enabled) %}
    - require:
      - sls: lvm.format
      {%- endif %}
    {%- endif %}
  {%- endfor %}
{%- endfor %}
