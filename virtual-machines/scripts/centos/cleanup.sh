#!/bin/bash -e

###########################################################
# CentOS cleanup script
###########################################################
(>&2 echo "============================================")
(>&2 echo "Cleanup Script for ${OS_FAMILY}")
(>&2 echo "  Execution context: ${0}")
(>&2 echo "============================================")

(>&2 echo "Removing firmware...")
set -x
yum remove -y *firmware
set +x

# truncat resolv.conf
(>&2 echo "Truncating resolv.conf...")
set -x
truncate -s 0 /etc/resolv.conf
set +x

(>&2 echo "Removing 'none' user...")
set -x
userdel -r none || /bin/true
set +x

(>&2 echo "Removing random-seed...")
set -x
rm -rf /var/lib/random-seed
set +x

(>&2 echo "Cleaning up yum...")
set -x
yum -y --enablerepo='*' clean all
rm -rf /var/cache/yum
rm -rf /var/lib/yum/history
yum history new || /bin/true
yum history new
set +x

(>&2 echo "Rebuilding rpmdb...")
set -x
rpmdb --rebuilddb
rm -f /var/lib/rpm/__db*
set +x

(>&2 echo "============================================")
(>&2 echo "Cleanup Script for ${OS_FAMILY} Ended")
(>&2 echo "============================================")
