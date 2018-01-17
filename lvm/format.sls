{%- from "lvm/map.jinja" import lvm with context %}

{%- set vgs = salt['pillar.get']('lvm:present:vgs', {}) %}

include:
  - lvm.install
  - lvm.vg
  - lvm.lv

{%- for vg_name, vg_params in vgs.items() %}
  {%- for lv_name, lv_params in vg_params.get('lvs', {}).items() %}
    {%- if lv_params.format|default(lvm.format.enabled) %}
lvm_vg_{{vg_name}}_lv_{{lv_name}}_format:
  blockdev.formatted:
    - name: {{lvm.fs_root|path_join(vg_name, lv_name)}}
    - fs_type: {{lv_params.fs_type}}
    - force: {{lv_params.force|default(lvm.format.force)}}
    - require:
      - sls: lvm.lv
    {%- endif %}
  {%- endfor %}
{%- endfor %}
