#!/bin/bash -e

###########################################################
# CentOS docker install script
###########################################################
(>&2 echo "============================================")
(>&2 echo "Docker Installation Script for ${OS_FAMILY}")
(>&2 echo "  Execution context: ${0}")
(>&2 echo "  Docker version:    ${YUM_DOCKER_VERSION}")
(>&2 echo "============================================")

if [ -n "${YUM_DOCKER_VERSION}" ]; then
  readonly DOCKER_INSTALL_ARG=docker-ce-${YUM_DOCKER_VERSION}
else
  readonly DOCKER_INSTALL_ARG=docker-ce
fi

(>&2 echo "Installing docker...")
set -x
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y ${DOCKER_INSTALL_ARG}
set +x

(>&2 echo "Enabling docker...")
set -x
systemctl enable docker
set +x

(>&2 echo "============================================")
(>&2 echo "Docker Install Script for ${OS_FAMILY} Ended")
(>&2 echo "============================================")
