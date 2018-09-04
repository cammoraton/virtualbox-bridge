#!/bin/bash -e

###########################################################
# Ubuntu docker install script
###########################################################
(>&2 echo "============================================")
(>&2 echo "Docker Installation Script for ${OS_FAMILY}")
(>&2 echo "  Execution context: ${0}")
(>&2 echo "  Docker version:    ${APT_DOCKER_VERSION}")
(>&2 echo "============================================")

if [ -n "${APT_DOCKER_VERSION}" ]; then
  readonly DOCKER_INSTALL_ARG=docker-ce=${APT_DOCKER_VERSION}
else
  readonly DOCKER_INSTALL_ARG=docker-ce
fi

(>&2 echo "Installing docker...")
set -x
apt-get update
apt-get install -y \
   apt-transport-https \
   ca-certificates \
   curl \
   software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update
apt-get install -y ${DOCKER_INSTALL_ARG}
set +x

(>&2 echo "Enabling docker...")
set -x
systemctl enable docker
set +x

(>&2 echo "============================================")
(>&2 echo "Docker Install Script for ${OS_FAMILY} Ended")
(>&2 echo "============================================")
