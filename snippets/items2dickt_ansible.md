---
date: "2024-10-15T14:24:15+02:00"
draft: false
title: Items2dickt ansible
---

*Takes a dictionary and transforms it into a list of dictionaries*

``` yml
env_vars:
  - { key: "LD_SUPERUSER_NAME", value: "{{ user_name }}" }
  - { key: "LD_SUPERUSER_PASSWORD", value: "{{ user_password }}" }

# too loo over it and create a list
env: "{{ env_vars | items2dict }}"


```
