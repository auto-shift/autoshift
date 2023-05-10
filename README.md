# AutoShift
AutoShift is OpenShift 4 automation project to simplify installing and configuring OpenShift clusters. It uses a combination of Anisble and OpenShift GitOps to provide consistent deployments and configurations in a declarative manner.

## Roles

* iac-ansible
    - Used to deploy and configure OpenShift
* destroy-cluster
    - Teardown for deployed clusters
* harden-ocp
    - OpenShift hardening automation

## Prerequisites

* AWS or AWS GovCloud account
* Persistent AWS user with CLI access
    - The access key and secret are persistent (No temporary tokens)
    - Admin policy or TODO policy attached

## Variables

| Key | Description | Default |
| ----------- | ----------- | ----------- |
| argocd_image_version | Version of ArgoCD container image | v1.4.4 |
| branch_tag | Text |

## Usage


