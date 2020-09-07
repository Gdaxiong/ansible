---
- name: move config file
  yum: name=mariadb-server state=present
- name: move config file
  shell: "[ -e /etc/my.cnf ] && mv /etc/my.cnf /etc/my.cnf.bak"
- name: provide a new config file
  copy: src=my.cnf dest=/etc/my.cnf
- name: reload mariadb
  shell: systemctl restart mariadb
- name: create database testdb
  shell: mysql -u root -e "create database testdb;grant all privileges on testdb.* to'test'@'192.168.100.%' identified by 'test123';flush privileges; "
  notify:
  - restart mariadb
...
#############################################
---
- hosts: test01:test02
  remote_user:root
  roles:
    - mariadb
...
#############################################
变量
vim /etc/ansible/test_vars.yml
---
- hosts: all
  vars:
  - name:"cloud"
    age: "3"
  tasks:
 -  name: "{{ name }}"
  shell: echo "myname {{ name }},myage {{ age }}"
  register: var_result
 -  debug: var=var_result
...
####################################################
vim /etc/ansible/tes_setupvars.yml
---
- hosts: all
  gather_facts: True      #使用ansible内置变量
  tasks:
  - name: setup var
    shell: echo "ip {{ ansible_all_ipv4_addresses[1]}} cpu {{ ansible_processor_count }}"
    register: var_result
  - debug: var=var_result
...





