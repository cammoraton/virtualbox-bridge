#!/bin/bash -e

###########################################################
# Ubuntu cleanup script
###########################################################
(>&2 echo "============================================")
(>&2 echo "Cleanup Script for ${OS_FAMILY}")
(>&2 echo "  Execution context: ${0}")
(>&2 echo "============================================")

(>&2 echo "Cleaning up yum...")
set -x
apt-get clean -y
rm -rf /var/lib/apt/lists/*
set +x

(>&2 echo "============================================")
(>&2 echo "Cleanup Script for ${OS_FAMILY} Ended")
(>&2 echo "============================================")
