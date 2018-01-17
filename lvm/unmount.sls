{% from "lvm/map.jinja" import lvm with context %}

{% set lvs = salt['pillar.get']('lvm:absent:lvs', {}) %}

{% for lv_name, lv_params in lvs.items() %}
lvm_vg_{{lv_params.vg}}_lv_{{lv_name}}_unmount:
  mount.unmounted:
    - name: {{lv_params.mount_point}}
    - device: {{lvm.fs_root|path_join(lv_params.vg) ~ '-' ~ lv_name}}
    - persist: True
{% endfor %}
