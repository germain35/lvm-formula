{% from "lvm/map.jinja" import lvm with context %}

include:
  - lvm.install
  - lvm.vg
  - lvm.lv
  - lvm.format
  - lvm.mount
