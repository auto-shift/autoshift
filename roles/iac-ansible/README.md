Marketplace Software Factory (MSF) Day 1 IaC
=========

This repository contains the Day 1 automation to create and destory clusters in an existing VPC. The VPC is located in the CMS Cloud Greenfield environment.

This role creates and destroys OpenShift 4 clusters in an existing AWS VPC.

Requirements
------------

Bastion host deployed

Role Variables
--------------

| Variable | Description | Default |
| -------- | ----------- | ------- |
|pull_secret | OpenShift pull secret (cloud.redhat.com) | |
|vpc_id | The value of the id of the desired target VPC | |
|cluster_name | The desired cluster name (e.g. cluster, dev, infra) | |
|openshift_version | The desired OpenShift version to deploy | latest |
|base_domain | Base domain of the OpenShift cluster | cms.local |

Example Playbook
----------------

This creates a cluster with variables defined in vars/main.yml. It also provides a vars prompt to allow the user to paste in their pull secret.
```
---
- name: Create Cluster
  hosts: localhost
  gather_facts: no
  vars_files:
    - vars/main.yml
  vars_prompt:
    - name: pull_secret
      prompt: OpenShift Pull Secret
      private: no
  roles:
    - openshift-iac-day-1
```


This destroys a cluster with variables defined in var/main.yml
```
---
- name: Destroy Cluster
  hosts: localhost
  gather_facts: no
  vars:
    destroy: True
  vars_files:
    - vars/main.yml
  roles:
    - openshift-iac-day-1
```        

Author Information
------------------

Dean Lystra - dlystra@redhat.com - https://github.cms.gov/LQF0
