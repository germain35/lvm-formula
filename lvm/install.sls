{% from "lvm/map.jinja" import lvm with context %}

lvm_packages:
  pkg.installed:
    - pkgs: {{ lvm.pkgs  }}
