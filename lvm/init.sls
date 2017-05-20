{% from "lvm/map.jinja" import lvm with context %}

include:
  - lvm.install
  - lvm.unmount
  - lvm.lv_remove
  - lvm.vg_remove
  - lvm.vg
  - lvm.lv
  - lvm.format
  - lvm.mount
