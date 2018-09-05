One last huzzah for Makefiles and the Hashicorp VM stack.

A bridge to immutable infrastructure. Still a work in progress.

# Contents

ansible - playbooks to provision and configure puppet

# Build / Install Requirements

Prerequisites:
* Make - basic build environment for your system
* VirtualBox - hypervisor actually used to run the VMs
* Packer - infrastructure build framework used to build VMs
* Vagrant - used to instantiate VMs and test
* Docker - required to build and run containers
* Python and Python-virtualenv - required for ansible
* Ruby and Rubygems - required for inspec - 2.3+

Prerequisites are loosely validated in the Makefile via a set of validate shell scripts stored in `scripts/validate_*.sh`. These check for the existence of commands in your path and will notify you on error. They can be executed via the `validate` makefile target by running `make validate`.

## Installing VirtualBox, Vagrant, and Docker

All of these can be installed via a straightforward package install.

URLS:
* https://www.virtualbox.org/wiki/Downloads (5.2.18 r124319)
* https://www.packer.io/downloads.html (1.2.5)
* https://www.vagrantup.com/downloads.html (2.1.4)

## Installing Packer

Packer these days comes as an all-in-one binary - unzip the binary from the download path and place it anywhere in your executable path.

Installation to the main path can generally be done via the following:
```
unzip packer_1.2.5_darwin.zip
sudo mv packer /usr/local/bin/.
```
this should go without saying, but substitute packer_1.2.5_darwin.zip with whatever the current zip is.

# Components

## Makefile(s)

## Gemfile(s)

## Requirements.txt

## Packer Templates and Scripts

See the README.md within the virtual-machines directory

## Dockerfile(s)

See the README.md within the containers directory

## Vagrantfile

## Ansible

## Inspec
