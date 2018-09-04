#!/bin/bash -e

###########################################################
# CentOS bootstrap script
###########################################################
(>&2 echo "============================================")
(>&2 echo "Bootstrap Script for ${OS_FAMILY}")
(>&2 echo "  Execution context: ${0}")
(>&2 echo "============================================")

(>&2 echo "Instaling virtualbox extensions...")
set -x
yum install kernel-devel gcc make perl bzip2 tar -y

mount -o loop VBoxGuestAdditions.iso /mnt
yes | sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm -f VBoxLinuxAdditions.iso

yum history undo last -y
set +x

(>&2 echo "============================================")
(>&2 echo "Bootstrap Script for ${OS_FAMILY} Ended")
(>&2 echo "============================================")
