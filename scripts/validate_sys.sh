#!/bin/bash -ex

readonly PACKER=$(command -v packer)
readonly VAGRANT=$(command -v vagrant)
readonly DOCKER=$(command -v docker)
readonly VBOXMANAGE=$(command -v vboxmanage)

ERRORS=0

# Validate binaries are installed and available to the
# current path.
if [ ! -n "${VAGRANT}" ]; then
  (>&2 echo "ERROR: vagrant command not installed or not in path")
  (>&2 echo "       please install vagrant and try again")
  (>&2 echo "")
  ERRORS=1
fi

if [ ! -n "${PACKER}" ]; then
  (>&2 echo "ERROR: packer command not installed or not in path")
  (>&2 echo "       please install packer and try again")
  (>&2 echo "")
  ERRORS=1
fi

if [ ! -n "${DOCKER}" ]; then
  (>&2 echo "ERROR: docker command not installed or not in path")
  (>&2 echo "       please install docker and try again")
  (>&2 echo "")
  ERRORS=1
fi

if [ ! -n "${VBOXMANAGE}" ]; then
  (>&2 echo "ERROR: vboxmanage command not installed or not in path")
  (>&2 echo "       please install VirtualBox and try again")
  (>&2 echo "")
  ERRORS=1
fi

if [ ${ERRORS} -eq 1 ]; then
  exit 1
fi
