#!/bin/bash

###########################################################
# Ubuntu bootstrap script
###########################################################
(>&2 echo "============================================")
(>&2 echo "Bootstrap Script for ${OS_FAMILY}")
(>&2 echo "  Execution context: ${0}")
(>&2 echo "============================================")

(>&2 echo "Setting up passwordless sudo for vagrant user...")
set -x
echo 'Defaults:vagrant !requiretty' > /etc/sudoers.d/vagrant; \
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/vagrant; \
chmod 440 /etc/sudoers.d/vagrant;
set +x

(>&2 echo "Instaling virtualbox extensions...")
set -x
mount -o loop VBoxGuestAdditions.iso /mnt
yes|sh /mnt/VBoxLinuxAdditions.run
umount /mnt
rm -f VBoxLinuxAdditions.iso
set +x

(>&2 echo "============================================")
(>&2 echo "Bootstrap Script for ${OS_FAMILY} Ended")
(>&2 echo "============================================")
