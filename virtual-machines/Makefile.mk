###################################################
#                 Packer Template
###################################################
# This template lints and builds vagrant boxes via packer
#
# call via:
#   $(eval $(call packer_template,$(OS_DISTRIBUTION),$(VM_SIZE),$(VM_NAME)))
# The three positional arguments:
#   $(1) / $(OS_DISTRIBUTION) needs to map to a packer json file in this directory
#   $(2) / $(VM_SIZE) needs to map to a packer variable file in the vars/ directory
#   $(3) / $(VM_NAME) is an arbitrary string, but may be used by the Vagrantfile
###################################################`
define packer_template
.PHONY: lint_packer_$(1)_$(3)
lint_packer_$(1)_$(3):
	packer validate \
		     -var-file=$(VM_DIRECTORY)/vars/$(2).json \
				 -var 'vm_name=$(3)' \
	       -var 'http_directory=$(VM_DIRECTORY)/www' \
	       -var 'scripts_directory=$(VM_DIRECTORY)/scripts' \
				 -var 'install_docker=$(INSTALL_DOCKER)' \
				 -var 'docker_version=$(DOCKER_VERSION)' \
				 $(VM_DIRECTORY)/$(1).json

.PHONY: build_machine_$(1)_$(3)
build_machine_$(1)_$(3): lint_packer_$(1)_$(3)
	test -f $(3).box || (packer build \
				 -var-file=$(VM_DIRECTORY)/vars/$(2).json \
				 -var 'vm_name=$(3)' \
	       -var 'http_directory=$(VM_DIRECTORY)/www' \
	       -var 'scripts_directory=$(VM_DIRECTORY)/scripts' \
				 -var 'install_docker=$(INSTALL_DOCKER)' \
				 -var 'docker_version=$(DOCKER_VERSION)' \
				 $(VM_DIRECTORY)/$(1).json && \
  vagrant box add --force --name $(3) ./$(3).box)
endef
