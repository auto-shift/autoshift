FROM registry.redhat.io/openshift-gitops-1/argocd-rhel8:v1.4.4

ARG SOPS_VERSION="3.7.1"
ARG HELM_SECRETS_VERSION="3.8.3"
ARG SOPS_RPM="https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-${SOPS_VERSION}-1.x86_64.rpm"
ARG HELM_PLUGINS_DIR="/helm-plugins"
ARG HELM_URL="https://get.helm.sh/helm-v3.7.1-linux-amd64.tar.gz"
ARG FINDUTILS_RPM="https://cdn-ubi.redhat.com/content/public/ubi/dist/ubi8/8/x86_64/baseos/os/Packages/f/findutils-4.6.0-20.el8.x86_64.rpm"
USER root

RUN rpm -ivh --nofiledigest ${SOPS_RPM} && \
    rpm -ivh ${FINDUTILS_RPM}

RUN INSTALL_PKGS="findutils" && \
    microdnf update -y --nobest && \
    microdnf install -y --setopt=tsflags=nodocs ${INSTALL_PKGS} && \
    microdnf clean all && \
    rm -rf /var/cache /var/log/dnf* /var/log/yum.*

ADD ${HELM_URL} /tmp

RUN tar -zxvf /tmp/helm-v3.7.1-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/bin/helm

COPY helm-wrapper.sh /usr/local/bin/helm

RUN chmod +x /usr/local/bin/helm

ENV HELM_PLUGINS="${HELM_PLUGINS_DIR}"

RUN mkdir ${HELM_PLUGINS_DIR} && chmod a+rw ${HELM_PLUGINS_DIR}

RUN helm plugin install https://github.com/jkroepke/helm-secrets --version ${HELM_SECRETS_VERSION}

USER argocd
