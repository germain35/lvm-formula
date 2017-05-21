{% from "lvm/map.jinja" import lvm with context %}

{% set vgs = salt['pillar.get']('lvm:present:vgs', {}) %}

include:
  - lvm.install
  - lvm.vg

{% for vg_name, vg_params in vgs.items() %}
  {% for lv_name, lv_params in vg_params.get('lvs', {}).items() %}
lvm_vg_{{vg_name}}_lv_{{lv_name}}:
  lvm.lv_present:
    - name: {{lv_name}}
    - vgname: {{vg_name}}
    {%- if lv_params.size is defined %}
    - size: {{lv_params.size}}
    {%- elif lv_params.extents is defined %}
    - extents: {{lv_params.extents}}
    {%- endif %}
    - require:
      - sls: lvm.vg

    {% if lv_params.resize|default(false) %}
      {% set lv_path = '/dev/' + vg_name + '/' + lv_name %}
      # get current lv size in KB
      {# set lv_size = salt['cmd.shell']("lvdisplay " + lv_path + " --units k -C | awk 'FNR > 1 {print $4}' | awk -F, '{print $1}'") #}

lvm_vg_{{vg_name}}_lv_{{lv_name}}_resize:
  module.run:
    - name: lvm.lvresize
    - size: {{lv_params.size}}
    - lvpath: {{lv_path}}
    - require:
      - lvm: lvm_vg_{{vg_name}}_lv_{{lv_name}}

lvm_vg_{{vg_name}}_lv_{{lv_name}}_resize2fs:
  module.run:
    - name: disk.resize2fs
    - device: {{lv_path}}
    - require:
      - module: lvm_vg_{{vg_name}}_lv_{{lv_name}}_resize
    {% endif %}
  {% endfor %}
{% endfor %}
