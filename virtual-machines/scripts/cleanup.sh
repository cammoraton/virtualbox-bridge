#!/bin/bash -e
###########################################################
# Common cleanup script
###########################################################
#  Validates required inputs, performs a few universal actions
#  and then chains into more specific bootstrap scripts
############################################################
# Dump environment vars out to stderr
(>&2 echo "============================================")
(>&2 echo "Main cleanup script")
(>&2 echo "  OS_FAMILY:      ${OS_FAMILY}")
(>&2 echo "  SCRIPT_DIR:     ${SCRIPT_DIR}")
(>&2 echo "  INSTALL_DOCKER: ${INSTALL_DOCKER}")
(>&2 echo "  DOCKER_VERSION: ${INSTALL_DOCKER}")
(>&2 echo "============================================")

##### PIVOT ON OS SPECIFIC THINGS #####
if [ -f ${SCRIPT_DIR}/${OS_FAMILY}/cleanup.sh ]; then
  ${SCRIPT_DIR}/${OS_FAMILY}/cleanup.sh
else
  (>&2 echo "WARNING: No cleanup.sh for ${OS_FAMILY}")
fi

(>&2 echo "Removing scripts directory...")
set -x
rm -rf ${SCRIPT_DIR}
set +x
##### BACK TO UNIVERSAL THINGS #####

(>&2 echo "Clearing any core files...")
set -x
rm -rf /core/*
set +x

(>&2 echo "Clearing logfiles...")
set -x
find /var/log -type f -delete
set +x

(>&2 echo "Clearing /tmp...")
set -x
rm -rf /tmp/*
set +x

(>&2 echo "Clearing dhcp...")
set -x
rm -rf /var/lib/dhcp/*
set +x

(>&2 echo "Clearing dhcp...")
set -x
rm -rf /var/lib/dhcp/*
set +x

(>&2 echo "Clearing docker directory...")
set -x
rm -rf /var/lib/docker/*
set +x

(>&2 echo "Zeroing and disabling swap...")
set +e
set -x
SWAPUUID=$(/sbin/blkid -o value -l -s UUID -t TYPE=swap)
case "$?" in
  2|0) ;;
  *) exit 1 ;;
esac
set -e
if [ "x${SWAPUUID}" != "x" ]; then
  # Whiteout the swap partition to reduce box size
  # swap is disabled until reboot
  SWAPPART=$(readlink -f /dev/disk/by-uuid/${SWAPUUID})
  /sbin/swapoff "${SWAPPART}"
  dd if=/dev/zero of="${SWAPPART}" bs=1M | echo "dd exit code $? is suppressed"
  /sbin/mkswap -U "${SWAPUUID}" "${SWAPPART}"
fi
set +x

(>&2 echo "Zeroing empty area of disk for better compression...")
set -x
dd if=/dev/zero of=/EMPTY BS=1M | echo "dd exit code $? suppressed"
rm -f /EMPTY
set +x

(>&2 echo "Blocking until sync...")
set -x
sync
set +x
