# Marketplace Software Factory (MSF) IaC

This role clones MSF OpenShift roles and deploys the MSF IaC.

## Roles
[iac-ansible]
- Deploys cluster
- Creates nodes
- Configures operators

## Requirements and Prerequisites

### Configure AWS credentials 

```
aws configure
AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE
AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
Default region name [None]: us-east-1
Default output format [None]: json
```

### Install git and ansible packages

```
sudo yum install -y git ansible tmux
```

Add your git token to ~/.gitconfig

```
GITUSERNAME=<your git username>
GITTOKEN=<your git token>

cat <<EOF >> ~/.gitconfig
[url "https://${GITUSERNAME}:${GITTOKEN}@github.cms.gov"]
        insteadOf = https://github.cms.gov
EOF
```

## Role Variables
### Required Variables

| Variable Name | Description | Default |
| -------- | ----------- | ------- |
|pull_secret | OpenShift pull secret (cloud.redhat.com) | |
|vpc_name | The value of the tag 'Name' of the desired target VPC | |
|cluster_name | The desired cluster name (e.g. cluster, dev, infra) | |
|openshift_version | The desired OpenShift version to deploy | 4.7.8 |
|base_domain | Base domain of the OpenShift cluster | cms.local |
|region | Region of the OpenShift cluster | us-east-1 |

### Variables to Enable/Disable Features

| Variable Name | Description | Default |
| -------- | ----------- | ------- |
|create_cluster | Enable/disable create cluster | true |
|create_infra | Enable/disable create infra nodes | true |
|machine_health_check | Enable/disable machine health check | true |
|cluster_autoscaling | Enable/disable cluster autoscaling | true |
|cluster_logging | Enable/disable cluster logging | true |
|log_forwarding | Enable/disable log forwarding (AWS CloudWatch) | true |
|encrypt_etcd | Enable/disable encrypt etcd | true |
|file_integrity_operator | Enable/disable File Integrity Operator | true |
|destroy_cluster | Destory cluster boolean value (don't change) | false |

**The following default variables are defined in their respective roles, but can be overridden for additional customization. (Advanced use only)**

### iac-ansible Default Variables

#### install-config Default Variables
| Variable Name | Description | Default |
| -------- | ----------- | ------- |
|credentials_mode | Cloud Credential Operator mode | Passthrough |
|worker.ec2_type | Worker instance type | m5.4xlarge|
|worker.rootvolume.iops| Worker volume iops | 2000 |
|worker.rootvolume.size | Worker volume size | 120 |
|worker.rootvolume.type | Worker volume type | io1 |
|worker.replicas | Worker quantity | 3 |
|master.ec2_type | Master instance type | m5.2xlarge|
|master.rootvolume.iops| Master volume iops | 2000 |
|master.rootvolume.size | Master volume size | 120 |
|master.rootvolume.type | Master volume type | io1 |
|master.replicas | Master quantity | 3 |

#### OpenShift Monitoring Default Variables
| Variable Name | Description | Default |
| -------- | ----------- | ------- |
|monitoring_storage_class | Storage class for monitoring | gp2 |
|prometheus_retention | Days to retain monitoring data | 15d |
|prometheus_storage | PV size for Prometheus Metrics | 40Gi |
|alertmanager_storage | PV size for Alert Manager | 40Gi |

### msf-iac-day-2 Default Variables

#### Cluster Autoscaling Default Variables
| Variable Name | Description | Default |
| -------- | ----------- | ------- |
|pod_priority_threshold | Cluster autoscaling pod priority threshold | -10 |
|resource_limits.max_nodes_total | Cluster autoscaling max cluster nodes | 12 |
|resource_limits.cores.min | Minimum total cluster cores (vCPUs) | 72 |
|resource_limits.cores.max | Maximum total cluster cores (vCPUs) | 96 |
|resource_limits.memory.min | Minimum total cluster memory | 288 |
|resource_limits.memory.max | Maximum total cluster memory | 384 |
|scaledown.enabled | Enable cluster autoscaling to scale down | true |
|scaledown.delay_after_add | Scale down delay after creating a worker | 10m |
|scaledown.delay_after_delete | Scale down delay after deleting a worker | 5m |
|scaledown.delay_after_failure | Scale down delay after a scale down failure | 30s |
|scaledown.delay_after_failure | Time before an unnecessary node is eligible for deletion | 60s |
|min_replicas | Minimum machine autoscaler replicas | 1 |
|max_replicas | Maximum machine autoscaler replicas | 2 |

#### Cluster Logging Default Variables
| Variable Name | Description | Default |
| -------- | ----------- | ------- |
|logging_namespace | Cluster logging namespace | openshift-logging |
|application_logs_max_age | Days to retain application logs | 1d |
|infra_logs_max_age | Days to retain infrastructure logs | 7d |
|audit_logs_max_age | Days to retain audit logs | 7d |
|elasticsearch_node_count | Quantity of elasticsearch instances | 3 |
|elasticsearch_storage_class | Storage class for elasticsearch PVs | gp2 |
|elasticsearch_storage_size| Size of each elasticsearch volume | 200G |
|kibana_replicas | Quantity of kibana replicas | 1 |
|curator_schedule | Curator log pruning schedule |"30 3 * * *" |
|cluster_logging_subscription_channel | Cluster logging subscription channel | 5.0 |
|cluster_logging_install_plan_approval | Cluster logging install plan approval method | Automatic |

#### Log Forwarding Default Variables
| Variable Name | Description | Default |
| -------- | ----------- | ------- |
|cloudwatch_aws_access_key | CloudWatch service user AWS access key |  |
|cloudwatch_aws_secret_access_key | CloudWatch service user AWS secret key |  |
|cloudwatch_log_group | CloudWatch log group | openshift-test-group |
|cloudwatch_log_stream | CloudWatch log stream | openshift-test-stream |
|cloudwatch_region | CloudWatch region | us-east-1 |
|forwarder_hostname | OpenShift log forwarder service name | openshift-logforwarding-cloudwatch.openshift-logging.svc |
|key_size | Log forwarder self-signed certificate key size | 4096 |
|key_type | Log forwarder self-signed certificate key type | RSA |
|country_name | Log forwarder self-signed certificate country | US |
|organization_name | Log forwarder self-signed certificate organization name | MOMOT |
|fluentd_cert_expiration_days | Log forwarder self-signed certificate validity period | +825d |

### msf-security-iac Default Variables

| Variable Name | Description | Default |
| -------- | ----------- | ------- |
| N/A |  |  |

## Dependencies

- AWS cli installed and aws configure completed
- tmux installed
- git installed
- ansible installed
- git token present in ~/.gitconfig

## Installation Instructions

### Clone the git respository
```
git clone https://github.cms.gov/Red-Hat-CSS/openshift-iac-automation.git
```

### Change directory into the cloned repository
```
cd openshift-iac-automation
```
### Run tmux
```
tmux
```

### In order to configure log forwarding to cloudwatch, define the cloudwatch credentials
```
export CLOUDWATCH_AWS_ACCESS_KEY=AKIAEXAMPLEKEY
export CLOUDWATCH_AWS_SECRET_ACCESS_KEY=PmOEXAMPLESECRET
```

### To create a cluster and install OpenShift run the create_cluster.yml script.
```
./create_cluster_mgmt.yml or ./create_cluster_acm.yml
```
A prompt will ask you for the cluster name. 

Valid env names:
- infra
- dev
- sbx
- test
- impl
- prod
- mgmt

### To harden and remediate a cluster run the harden_ocp.yml script.
```
./harden_ocp.yml
```
A prompt will ask you for the cluster name. 

Valid env names:
- infra
- dev
- sbx
- test
- impl
- prod
- mgmt

### To rebaseline a cluster run the rebaseline_cluster.yml script.
```
./rebaseline_cluster.yml
```
A prompt will ask you for the cluster name. 

Valid env names:
- infra
- dev
- sbx
- test
- impl
- prod
- mgmt

### Copy and paste your OpenShift pull secret into the prompt.
Acquire your OpenShift pull secret. https://cloud.redhat.com/openshift/install/aws/installer-provisioned

```
OpenShift Pull Secret:
```

### To destroy the cluster, run the destroy_cluster.yml script
```
./destroy_cluster.yml
```
A prompt will ask you for the cluster name and to confirm destroying the cluster.
License
-------

BSD
