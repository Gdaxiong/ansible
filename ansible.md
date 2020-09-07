### 安装 ansible

```
yum -y install ansible
ansible --verion  #查看版本#
ssh-keygen -t rsa   #创建密钥对

ssh-copy-id root@192.168.100.12   #将密钥发给12主机
ssh-copy-id root@192.168.100.13   #将密钥发给13主机
在ets/ansible/hosshs添加配置文件
[test01]
192.168.100.12
[test02]
192.168.100.13
```

### 在/etc/ansible/test.yml 写一个自动化脚本

```
---
- hosts: test01
  remote_user: root
  tasks:
    - name: adduser
      user: name=user2 state=present
      register: print_result
      tags:
      - testaaa
    - debug: var=print_result
    - name: addgroup
      group: name=root system=yes
      tags:
      - testbbb

- hosts: test02
  remote_user: root
  tasks:
    - name: cp file
      copy: src=/etc/passwd dest=/home
      tags:
      - testcccc
...
```

### ansible

```
#--syntax-check  检测yml语法正确
ansible-playbook --syntax-check /etc/ansible/test.yml

#-C，（测试，不会改变主机的任何配置）
ansible-playbook -C /etc/ansible/test.yml

#-list-hosts   列出yml文件影响的主机列表
ansible-playbook -list-hosts /etc/ansible/test.yml

#--list-tags   列出yml文件影响的标签
ansible-playbook --list-tags /etc/ansible/test.yml

执行任务
ansible-playbook /etc/ansible/test.yml
```

## 触发器

**需要触发才能执行的任务，当之前定义在tasks中的任务执行完成后，诺希望在基础上触发其他的任务，这是就需要定义handlers。**

##### handles触发器一下优点。

##### 1.~ handles 是 Ansible 提供的条件机制之一，handlers和task很类似，但是他在被task通知的时候会触发

##### 2.~ handles 只会在所有任务执行完成后执行，而且即使被通知了多次，它也只会执行一此，handles 按照定义的顺序依次执行

##### handles 触发器的使用实列如下

```
#查看 test01组主机   -m使用shell模块   -a命令  '查看80端口是否开启'
ansible test01 -m shell -a 'netstat -lnpt | grep 80'

#再写一个yml修改192.168.100.12主机的httpd端口80修改8080
vim/etc/ansible/httpd.yml
---
- hosts: test01            #指定执行的组
  remote_user: root        #执行用户身份root
  tasks:                   #定义任务
    - name: change port    #任务名称
      command: sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf   
      notify:      #通知触发器
        - restart httpd server    #触发器名字restart httpd server
  handlers:                    #定义触发器名字
    - name: restart httpd server
      service: name=httpd state=restarted     #对httpd重启操作
...

ansible-playbook -C /etc/ansible/httpd.yml   #检测脚本
```

## 角色

**创建数据库角色，创建路径不要写错**

```
mkdir -pv /etc/ansible/roles/mariadb/{files,tasks,handlers}
vim /etc/ansible/mariadb.yml
---
- hosts: test01:test02
  remote_user:root
  roles:
    - mariadb
...
```













