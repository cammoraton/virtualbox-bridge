##
define container_template
.PHONY: build_container_$(1)
build_container_$(1): lint_container_$(1)

.PHONY: push_container_$(1)
push_container_$(1):

build_all_containers += build_container_$(1)
push_all_containers += push_container_$(1)
endef

$(foreach CONTAINER,$(CONTAINERS), $(eval $(call container_template,$(CONTAINER))))

.PHONY: build_containers
build_containers: $(build_all_containers)

.PHONY: push_containers
push_containers: $(push_all_containers)
