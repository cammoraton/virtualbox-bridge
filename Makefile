###################################################
#                    Variables
###################################################
# Set up base variables:
#  get the root directory of this makefile
MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
ROOT_DIR := $(dir $(MKFILE_PATH))

# Set the container and VM directories in case we decide
# to change them - becomes a quick change
CONTAINER_DIRECTORY := $(ROOT_DIR)containers
VM_DIRECTORY := $(ROOT_DIR)virtual-machines

# Parse root_dir/containers for files that aren't README.md
CONTAINERS := $(filter-out README.md Makefile.mk, $(sort $(notdir $(patsubst %/,%,$(notdir $(wildcard $(CONTAINER_DIRECTORY)/*))))))
# Parse vm directory for json packer files
VIRTUAL_MACHINES := $(sort $(notdir $(patsubst %/,%,$(notdir $(wildcard $(VM_DIRECTORY)/*.json)))))

# Container variables - these get used in $(CONTAINER_DIRECTORY)/Makefile.mk
#   in order to set up registry pushes
CONTAINER_REGISTRY :=
CONTAINER_PREFIX :=

# Machine variables - how to generate the base VM
# Which distribution to use: centos or ubuntu
#   ultimately governs which json to use in the virtual_machines directory
OS_DISTRIBUTION := ubuntu
#OS_DISTRIBUTION := centos

# Whether to install docker into the above machine
INSTALL_DOCKER := true
# What version of docker to install (gets passed to yum or apt)
YUM_DOCKER_VERSION := 18.06.1.ce-3.el7.x86_64
APT_DOCKER_VERSION := 18.06.1~ce~3-0~ubuntu

# Machine name to use for vagrant box
# make sure this maps to the vagrantfile
VAGRANT_MACHINE_NAME := puppetserver

# Uncomment to try containerized mode
# USE_CONTAINERS := true

ANSIBLE_PLAYBOOK := all.yml

###################################################
#                 Default Target
###################################################
# what gets run when you run "make" without arguments
###################################################
.PHONY: default
default: test

###################################################
#                    Includes
###################################################
# Split the makefile up a bit
#   These include templates and *all* targets for
#   a given subsystem / target
###################################################
include $(VM_DIRECTORY)/Makefile.mk
include $(CONTAINER_DIRECTORY)/Makefile.mk

# Instantiate the packer_template defined in $(VM_DIRECTORY)/Makefile.mk
# using the os_distribution
$(eval $(call packer_template,$(OS_DISTRIBUTION),server,$(VAGRANT_MACHINE_NAME)))

# Creates the vagrant box as a legit make target
$(VAGRANT_MACHINE_NAME).box: validate_sys build_machine_$(OS_DISTRIBUTION)_$(VAGRANT_MACHINE_NAME)

###################################################
#                    Validations
###################################################
# Validate the operating system we're running in
# to catch and surface trivial problems that we
# know will cause problems with the build.
###################################################
# Ruby validations: ruby, gem are all installed
.PHONY: validate_ruby
validate_ruby:
	./scripts/validate_ruby.sh

# Python validations: python3, pip, virtualenv are all installed
.PHONY: validate_python
validate_python:
	./scripts/validate_python.sh

# System validations: docker, packer, vagrant are all installed
.PHONY: validate_sys
validate_sys:
	./scripts/validate_sys.sh

# All validations
.PHONY: validate
validate: validate_sys validate_python validate_ruby

###################################################
#           Vendoring and Virtualenvs
###################################################
# We don't want to rely on the operating system
# for specific versions of things we're actually testing
# like inspec or ansible. So we set up bundles and
# virtualenvs
###################################################
# Ruby Bundle
#   Installs bundler and then installs the Gemfile
./vendor/bundle: validate_ruby
	gem install -i vendor/ bundler
	GEM_PATH=./vendor ./vendor/bin/bundle install --path vendor/bundle

# Python Virtualenv
#   Installs a python3 vitualenv, pip tools and then chains to the virtualenv
./env/bin/activate: validate_python
	virtualenv -p python3 env
	./env/bin/pip install pip-tools

# Python Virtualenv
#   Uses pip-compile to 'freeze' requirements and dependencies into a
#   requirements.txt file.
requirements.txt: ./env/bin/activate
	./env/bin/pip-compile --no-index requirements.in

# Python Virtualenv
#   Installs the compiled requirements
.PHONY: virtualenv
virtualenv: requirements.txt
	./env/bin/pip install -r requirements.txt

# Vendor inspec
./inspec/inspec.lock: ./vendor/bundle
	GEM_PATH=./vendor ./vendor/bin/bundler exec inspec vendor inspec

# Metatarget for all the above dependencies
.PHONY: deps
deps: virtualenv ./inspec/inspec.lock

###################################################
#                    Tests
###################################################
# Test inspec - this is pretty much just static
#   analysis.
.PHONY: test_inspec
test_inspec: inspec/inspec.lock
	#GEM_PATH=./vendor ./vendor/bin/bundler exec rubycritic inspec -f console -s 80
	#GEM_PATH=./vendor ./vendor/bin/bundler exec rubocop inspec
	GEM_PATH=./vendor ./vendor/bin/bundler exec inspec check inspec

.PHONY: test_ansible
test_ansible: virtualenv
	#./env/bin/ansible --check

# Test everything
.PHONY: test
test: test_ansible test_inspec $(VAGRANT_MACHINE_NAME).box
	vagrant up
	./env/bin/ansible-playbook \
	  --user=vagrant \
	  -e "host_key_checking=False" \
	  -e "ansible_ssh_common_args='-o StrictHostKeyChecking=no'" \
	  -e "ansible_ssh_port=`vagrant ssh-config | grep Port | awk '{print $$2}'`" \
	  -e "ansible_become_password=vagrant" \
	  --private-key=`vagrant ssh-config | grep IdentityFile | awk '{print $$2}'` \
	  -i localhost:`vagrant ssh-config | grep Port | awk '{print $$2}'`, \
	  --become \
	  ./ansible/$(ANSIBLE_PLAYBOOK)
	GEM_PATH=./vendor ./vendor/bin/bundler exec inspec exec \
	  --port=`vagrant ssh-config | grep Port | awk '{print $$2}'` \
	  --user=vagrant \
	  --password=vagrant \
	  --backend=ssh \
	  --host=localhost \
	  --sudo \
	  ./inspec
	vagrant destroy -f

###################################################
#                  Clean Up
###################################################
# Reset the vagrant box between tests
.PHONY: reset
reset:
	vagrant destroy -f

# Reset the vagrant box between tests
.PHONY: rebuild
rebuild:
	rm -rf *.box

# Clean all the things!
.PHONY: clean
clean:
	vagrant destroy -f || /bin/true
	vagrant box remove $(VAGRANT_MACHINE_NAME) || /bin/true
	rm -f *.box
	rm -rf ./vendor
	rm -rf .bundle
	rm -rf ./env
	rm -f Gemfile.lock
	rm -f inspec/inspec.lock
	rm -rf inspec/vendor
	rm -rf packer_cache/
	rm -rf virtual-machines/packer_cache/
	rm -rf output-virtualbox-iso/
	rm -rf virtual-machines/output-virtualbox-iso/
	rm -rf tmp/
