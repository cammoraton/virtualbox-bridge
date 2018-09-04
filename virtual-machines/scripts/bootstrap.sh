#!/bin/bash -e
###########################################################
# Common bootstrap script
###########################################################
#  Validates required inputs, performs a few universal actions
#  and then chains into more specific bootstrap scripts
############################################################

# Dump environment vars out to stderr
(>&2 echo "============================================")
(>&2 echo "Main Bootstrap Script")
(>&2 echo "  OS_FAMILY:          ${OS_FAMILY}")
(>&2 echo "  SCRIPT_DIR:         ${SCRIPT_DIR}")
(>&2 echo "  INSTALL_DOCKER:     ${INSTALL_DOCKER}")
(>&2 echo "  YUM_DOCKER_VERSION: ${YUM_DOCKER_VERSION}")
(>&2 echo "  APT_DOCKER_VERSION: ${APT_DOCKER_VERSION}")
(>&2 echo "============================================")

# Set error count to 0
ERRORS=0

# Check for variables we need
if [ ! -n "${OS_FAMILY}" ]; then
  (>&2 echo "ERROR: OS_FAMILY evaluates to zero-length string")
  ERRORS=1
fi
if [ ! -n "${SCRIPT_DIR}" ]; then
  (>&2 echo "ERROR: SCRIPT_DIR evaluates to zero-length string")
  ERRORS=1
fi

if [ ${ERRORS} -eq 1 ]; then
  (>&2 echo "")
  (>&2 echo "Ensure the missing environment variables: ")
  (>&2 echo "  - are set inside an environment_vars stanza within the")
  (>&2 echo "    json file (see: https://www.packer.io/docs/provisioners/shell.html#environment_vars)")
  (>&2 echo "  - evaluate appropriately to user variables ")
  (>&2 echo "  - either have a default set in \"variables\"")
  (>&2 echo "    or are being passed into packer via a --vars or --vars-file")
  exit 1
fi

(>&2 echo "Inserting insecure vagrant key...")
# Set -ex so we echo what we do and exit if it fails
set -x
date > /etc/vagrant_box_build_time

mkdir -p /vagrant
mkdir /home/vagrant/.ssh
curl -L -o /home/vagrant/.ssh/authorized_keys https://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub
chown -R vagrant /home/vagrant/.ssh
chmod -R go-rwsx /home/vagrant/.ssh
set +x

(>&2 echo "Making sure scripts are executable...")
set -x
find ${SCRIPT_DIR} -type f -exec chmod a+rx {} \;
set +x

if [ -f ${SCRIPT_DIR}/${OS_FAMILY}/bootstrap.sh ]; then
  ${SCRIPT_DIR}/${OS_FAMILY}/bootstrap.sh
else
  (>&2 echo "WARNING: No bootstrap.sh for ${OS_FAMILY}")
fi

if [ -n "${INSTALL_DOCKER}" ]; then
  if [ -f ${SCRIPT_DIR}/${OS_FAMILY}/docker.sh ]; then
    ${SCRIPT_DIR}/${OS_FAMILY}/docker.sh
  else
    (>&2 echo "ERROR: No docker.sh for ${OS_FAMILY}")
    exit 1
  fi
fi
