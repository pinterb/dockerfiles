VERSION = 0.0.15
NAME = pinterb

CREATE_DATE := $(shell date +%FT%T%Z)
MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(shell dirname $(MKFILE_PATH))
DOCKER_BIN := $(shell which docker)

TERRAFORM_CURRENT_VERSION = 0.6.11
TERRAFORM_IMAGES = 0.5.3 \
	0.6.2 \
	0.6.3 \
	0.6.4 \
	0.6.6 \
	0.6.7 \
	0.6.8 \
	0.6.9 \
	0.6.11

PACKER_CURRENT_VERSION = 0.8.6
PACKER_IMAGES = 0.7.5 \
	0.8.6

ANSIBLE_CURRENT_VERSION = 2.0.0.2
ANSIBLE_IMAGES = 1.9.4 \
	2.0.0.2

ANSIBLE_LINT_CURRENT_VERSION = 2.3.1
ANSIBLE_LINT_IMAGES = 2.3.1 

JDK_IMAGES = 8u66


all: build test

.PHONY: check.env
check.env:
ifndef DOCKER_BIN
   $(error The docker command is not found. Verify that Docker is installed and accessible)
endif


### Base images

.PHONY: alpine
alpine:
	@echo " "
	@echo " "
	@echo "Building 'base/alpine' image..."
	@echo " "
	$(DOCKER_BIN) build -t $(NAME)/base:alpine $(CURRENT_DIR)/base/alpine

.PHONY: ubuntu
ubuntu:
	@echo " "
	@echo " "
	@echo "Building 'base/ubuntu' image..."
	@echo " "
	$(DOCKER_BIN) build -t $(NAME)/base:ubuntu $(CURRENT_DIR)/base/ubuntu

.PHONY: debian
debian:
	@echo " "
	@echo " "
	@echo "Building 'base/debian' image..."
	@echo " "
	$(DOCKER_BIN) build -t $(NAME)/base:debian $(CURRENT_DIR)/base/debian

.PHONY: centos
centos:
	@echo " "
	@echo " "
	@echo "Building 'base/centos' image..."
	@echo " "
	$(DOCKER_BIN) build -t $(NAME)/base:centos $(CURRENT_DIR)/base/centos

.PHONY: base
base: alpine ubuntu debian centos
	@echo " "
	@echo " "
	@echo "Base images have been built."
	@echo " "

.PHONY: base_test
base_test:
	@if ! $(DOCKER_BIN) run $(NAME)/base:ubuntu /bin/sh -c 'cat /etc/*-release' | grep -q -F Ubuntu; then false; fi
	@if ! $(DOCKER_BIN) run $(NAME)/base:debian /bin/sh -c 'cat /etc/*-release' | grep -q -F Debian; then false; fi
	@if ! $(DOCKER_BIN) run $(NAME)/base:centos /bin/sh -c 'cat /etc/*-release' | grep -q -F CentOS; then false; fi
	@if ! $(DOCKER_BIN) run $(NAME)/base:alpine /bin/sh -c 'cat /etc/*-release' | grep -q -F Alpine; then false; fi
	@echo " "
	@echo " "
	@echo "Base tests have completed."
	@echo " "


.PHONY: base_rm
base_rm:
	@if docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F alpine; then $(DOCKER_BIN) rmi $(NAME)/base:alpine; fi
	@if docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F ubuntu; then $(DOCKER_BIN) rmi $(NAME)/base:ubuntu; fi
	@if docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F centos; then $(DOCKER_BIN) rmi $(NAME)/base:centos; fi
	@if docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F debian; then $(DOCKER_BIN) rmi $(NAME)/base:debian; fi



### Misc images

.PHONY: ansible 
ansible:
	@for tf_ver in $(ANSIBLE_IMAGES); \
	do \
	echo " " ; \
	echo " " ; \
	echo " " ; \
	echo "Building '$$tf_ver $@' image..." ; \
	echo " " ; \
	$(DOCKER_BIN) build --rm -t $(NAME)/$@:$$tf_ver $(CURRENT_DIR)/$@/$$tf_ver ; \
	cp -pR $(CURRENT_DIR)/templates/$@/README.md $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/$@/g' $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i 's/###-->ZZZ_BASE_IMAGE<--###/$(NAME)\/base:alpine/g' $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i "s/###-->ZZZ_CURRENT_VERSION<--###/$(ANSIBLE_CURRENT_VERSION)/g" $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i "s/###-->ZZZ_VERSION<--###/$$tf_ver/g" $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i "s/###-->ZZZ_ANSIBLE_VERSION<--###/$$tf_ver/g" $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	done

.PHONY: ansible_test
ansible_test: 
	@for tf_ver in $(ANSIBLE_IMAGES); \
	do \
	echo "Testing '$$tf_ver ansible' image..." ; \
	echo " " ; \
	if ! $(DOCKER_BIN) run -it \
		-v $(CURRENT_DIR)/ansible:/ansible:rw \
		--entrypoint="/opt/ansible/bin/ansible" \
		$(NAME)/ansible:$$tf_ver --version | \
		grep -q -F "ansible $$tf_ver" ; then echo "$(NAME)/ansible:$$tf_ver - ansible command failed."; false; fi; \
	if ! $(DOCKER_BIN) run -it \
		-v $(CURRENT_DIR)/ansible:/ansible:rw \
		--entrypoint="/opt/ansible/bin/ansible-playbook" \
		$(NAME)/ansible:$$tf_ver --version | \
		grep -q -F "ansible-playbook $$tf_ver" ; then echo "$(NAME)/ansible:$$tf_ver - ansible-playbook command failed."; false; fi; \
	done

.PHONY: ansible_rm
ansible_rm: 
	@for tf_ver in $(ANSIBLE_IMAGES); \
	do \
	echo "Removing '$$tf_ver ansible' image..." ; \
	echo " " ; \
	if $(DOCKER_BIN) images $(NAME)/ansible | awk '{ print $$2 }' | grep -q -F $$tf_ver; then $(DOCKER_BIN) rmi -f $(NAME)/ansible:$$tf_ver; fi ; \
	done

	

.PHONY: ansible-lint 
ansible-lint:
	@for tf_ver in $(ANSIBLE_LINT_IMAGES); \
	do \
	echo " " ; \
	echo " " ; \
	echo " " ; \
	echo "Building '$$tf_ver $@' image..." ; \
	echo " " ; \
	$(DOCKER_BIN) build --rm -t $(NAME)/$@:$$tf_ver $(CURRENT_DIR)/$@/$$tf_ver ; \
	cp -pR $(CURRENT_DIR)/templates/$@/README.md $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/$@/g' $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i 's/###-->ZZZ_BASE_IMAGE<--###/$(NAME)\/base:alpine/g' $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i "s/###-->ZZZ_CURRENT_VERSION<--###/$(ANSIBLE_LINT_CURRENT_VERSION)/g" $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i "s/###-->ZZZ_VERSION<--###/$$tf_ver/g" $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i "s/###-->ZZZ_ANSIBLE_LINT_VERSION<--###/$$tf_ver/g" $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	done

.PHONY: ansible-lint_test
ansible-lint_test: 
	@for tf_ver in $(ANSIBLE_LINT_IMAGES); \
	do \
	echo "Testing '$$tf_ver ansible' image..." ; \
	echo " " ; \
	if ! $(DOCKER_BIN) run -it \
		-v $(CURRENT_DIR)/ansible:/ansible:rw \
		$(NAME)/ansible-lint:$$tf_ver --version | \
		grep -q -F "ansible-lint $$tf_ver" ; then echo "$(NAME)/ansible-lint:$$tf_ver - ansible-lint command failed."; false; fi; \
	done

.PHONY: ansible-lint_rm
ansible-lint_rm: 
	@for tf_ver in $(ANSIBLE_LINT_IMAGES); \
	do \
	echo "Removing '$$tf_ver ansible' image..." ; \
	echo " " ; \
	if $(DOCKER_BIN) images $(NAME)/ansible-lint | awk '{ print $$2 }' | grep -q -F $$tf_ver; then $(DOCKER_BIN) rmi -f $(NAME)/ansible-lint:$$tf_ver; fi ; \
	done



.PHONY: terraform 
terraform:
	@for tf_ver in $(TERRAFORM_IMAGES); \
	do \
	echo " " ; \
	echo " " ; \
	echo "Building '$$tf_ver $@' image..." ; \
	echo " " ; \
	$(DOCKER_BIN) build --rm -t $(NAME)/$@:$$tf_ver $(CURRENT_DIR)/$@/$$tf_ver ; \
	cp -pR $(CURRENT_DIR)/templates/$@/README.md $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/$@/g' $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i 's/###-->ZZZ_BASE_IMAGE<--###/$(NAME)\/base:alpine/g' $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i "s/###-->ZZZ_TERRAFORM_VERSION<--###/$$tf_ver/g" $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i "s/###-->ZZZ_CURRENT_VERSION<--###/$(TERRAFORM_CURRENT_VERSION)/g" $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	done

.PHONY: terraform_test
terraform_test: 
	@for tf_ver in $(TERRAFORM_IMAGES); \
	do \
	echo "Testing '$$tf_ver terraform' image..." ; \
	echo " " ; \
	if ! $(DOCKER_BIN) run -it \
		-v $(CURRENT_DIR)/terraform/$$tf_ver:/data:rw \
		$(NAME)/terraform:$$tf_ver version | \
		grep -q -F "Terraform v$$tf_ver" ; then echo "$(NAME)/terraform:$$tf_ver - terraform version command failed."; false; fi ; \
	done

.PHONY: terraform_rm
terraform_rm: 
	@for tf_ver in $(TERRAFORM_IMAGES); \
	do \
	echo "Removing '$$tf_ver terraform' image..." ; \
	echo " " ; \
	if $(DOCKER_BIN) images $(NAME)/terraform | awk '{ print $$2 }' | grep -q -F $$tf_ver; then $(DOCKER_BIN) rmi -f $(NAME)/terraform:$$tf_ver; fi ; \
	done



.PHONY: packer 
packer:
	@for img_ver in $(PACKER_IMAGES); \
	do \
	echo " " ; \
	echo " " ; \
	echo "Building '$$img_ver $@' image..." ; \
	$(DOCKER_BIN) build --rm -t $(NAME)/$@:$$img_ver $(CURRENT_DIR)/$@/$$img_ver ; \
	cp -pR $(CURRENT_DIR)/templates/$@/README.md $(CURRENT_DIR)/$@/$$img_ver/README.md ; \
	sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/$@/g' $(CURRENT_DIR)/$@/$$img_ver/README.md ; \
	sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' $(CURRENT_DIR)/$@/$$img_ver/README.md ; \
	sed -i 's/###-->ZZZ_BASE_IMAGE<--###/$(NAME)\/base:alpine/g' $(CURRENT_DIR)/$@/$$img_ver/README.md ; \
	sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' $(CURRENT_DIR)/$@/$$img_ver/README.md ; \
	sed -i "s/###-->ZZZ_PACKER_VERSION<--###/$$img_ver/g" $(CURRENT_DIR)/$@/$$img_ver/README.md ; \
	sed -i "s/###-->ZZZ_CURRENT_VERSION<--###/$(PACKER_CURRENT_VERSION)/g" $(CURRENT_DIR)/$@/$$img_ver/README.md ; \
	done

.PHONY: packer_test
packer_test: 
	@for img_ver in $(PACKER_IMAGES); \
	do \
	echo "Testing '$$img_ver packer' image..." ; \
	echo " " ; \
	if ! $(DOCKER_BIN) run -it \
		-v $(CURRENT_DIR)/packer/$$img_ver:/data:rw \
		$(NAME)/packer:$$img_ver version | \
		grep -q -F "Packer v$$img_ver" ; then echo "$(NAME)/packer:$$img_ver - packer version command failed."; false; fi ; \
	done

.PHONY: packer_rm
packer_rm: 
	@for img_ver in $(PACKER_IMAGES); \
	do \
	echo "Removing '$$img_ver packer' image..." ; \
	echo " " ; \
	if $(DOCKER_BIN) images $(NAME)/packer | awk '{ print $$2 }' | grep -q -F $$img_ver; then $(DOCKER_BIN) rmi -f $(NAME)/packer:$$img_ver; fi ; \
	done



.PHONY: mush
mush:
	@echo " "
	@echo " "
	@echo "Building 'mush' image..."
	@echo " "
	$(DOCKER_BIN) build --rm -t $(NAME)/mush:$(VERSION) $(CURRENT_DIR)/mush
	cp -pR $(CURRENT_DIR)/templates/mush/README.md $(CURRENT_DIR)/mush/README.md
	sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/mush/g' $(CURRENT_DIR)/mush/README.md
	sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' $(CURRENT_DIR)/mush/README.md
	sed -i 's/###-->ZZZ_BASE_IMAGE<--###/pinterb\/base:alpine/g' $(CURRENT_DIR)/mush/README.md
	sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' $(CURRENT_DIR)/mush/README.md

.PHONY: mush_test
mush_test: 
	@echo "Testing 'mush' image..."
	@echo " "
	cat $(CURRENT_DIR)/mush/terraform.tfvars.tmpl | $(DOCKER_BIN) run -i \
		-v $(CURRENT_DIR)/mush/extras:/home/dev/.extra \
		-v $(CURRENT_DIR)/mush:/home/dev/.ssh \
		-e MUSH_EXTRA=/home/dev/.extra \
		-e AZURE_SETTINGS_FILE=/home/dev/.azure.settings \
		-e AZURE_CERT=/home/dev/.azure.cer \
		-e AZURE_REGION="West US"  \
		-e DOMAIN_NAME="example.com" \
		$(NAME)/mush:$(VERSION) > $(CURRENT_DIR)/mush/terraform.tfvars
	@if ! cat $(CURRENT_DIR)/mush/terraform.tfvars | grep -q -F example.com; then echo "mush/terraform.tfvars was not rendered with the expected results."; false; fi



.PHONY: jinja2 
jinja2:
	@echo " "
	@echo " "
	@echo "Building 'jinja2' image..."
	@echo " "
	$(DOCKER_BIN) build --rm -t $(NAME)/jinja2:$(VERSION) $(CURRENT_DIR)/jinja2
	cp -pR $(CURRENT_DIR)/templates/jinja2/README.md $(CURRENT_DIR)/jinja2/README.md
	sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/jinja2/g' $(CURRENT_DIR)/jinja2/README.md
	sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' $(CURRENT_DIR)/jinja2/README.md
	sed -i 's/###-->ZZZ_BASE_IMAGE<--###/pinterb\/base:alpine/g' $(CURRENT_DIR)/jinja2/README.md
	sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' $(CURRENT_DIR)/jinja2/README.md

.PHONY: jinja2_test
jinja2_test: 
	@echo "Testing 'jinja2' image..."
	@echo " "
	$(DOCKER_BIN) run -i \
		-v $(CURRENT_DIR)/jinja2:/data \
		-e TEMPLATE=some.json.j2 \
		$(NAME)/jinja2:$(VERSION) datacenter='msp' acl_ttl='30m' > $(CURRENT_DIR)/jinja2/some.json
	@if ! cat $(CURRENT_DIR)/jinja2/some.json | grep -q -F '"datacenter": "msp"'; then echo "jinja2/some.json was not rendered with the expected results."; false; fi



.PHONY: jq
jq:
	@echo " "
	@echo " "
	@echo "Building 'jq' image..."
	@echo " "
	$(DOCKER_BIN) build --rm -t $(NAME)/jq:$(VERSION) $(CURRENT_DIR)/jq
	cp -pR $(CURRENT_DIR)/templates/jq/README.md $(CURRENT_DIR)/jq/README.md
	sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/jq/g' $(CURRENT_DIR)/jq/README.md
	sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' $(CURRENT_DIR)/jq/README.md
	sed -i 's/###-->ZZZ_BASE_IMAGE<--###/pinterb\/base:alpine/g' $(CURRENT_DIR)/jq/README.md
	sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' $(CURRENT_DIR)/jq/README.md

.PHONY: jq_test
jq_test: 
	@echo "Testing 'jq' image..."
	@echo " "
	@if ! $(DOCKER_BIN) run $(NAME)/jq:$(VERSION) | grep -q -F "jq is a tool for processing JSON inputs"; then echo "$(NAME)/jq doesn't appear to run as expected."; false; fi



.PHONY: jdk 
jdk:
	@for jdk_ver in $(JDK_IMAGES); \
	do \
	echo " " ; \
	echo " " ; \
	echo "Building '$$jdk_ver $@' image..." ; \
	$(DOCKER_BIN) build --rm -t $(NAME)/$@:$$jdk_ver $(CURRENT_DIR)/java/$@/$$jdk_ver ; \
	cp -pR $(CURRENT_DIR)/templates/java/$@/README.md $(CURRENT_DIR)/java/$@/$$jdk_ver/README.md ; \
	sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/$@/g' $(CURRENT_DIR)/java/$@/$$jdk_ver/README.md ; \
	sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' $(CURRENT_DIR)/java/$@/$$jdk_ver/README.md ; \
	sed -i 's/###-->ZZZ_BASE_IMAGE<--###/$(NAME)\/base:alpine/g' $(CURRENT_DIR)/java/$@/$$jdk_ver/README.md ; \
	sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' $(CURRENT_DIR)/java/$@/$$jdk_ver/README.md ; \
	sed -i "s/###-->ZZZ_JDK_VERSION<--###/$$jdk_ver/g" $(CURRENT_DIR)/java/$@/$$jdk_ver/README.md ; \
	done

.PHONY: jdk_test
jdk_test: 
	@for jdk_ver in $(JDK_IMAGES); \
	do \
	echo "Testing '$$jdk_ver terraform' image..." ; \
	echo " " ; \
	if ! $(DOCKER_BIN) run -it \
		-v $(CURRENT_DIR)/java/jdk/$$jdk_ver:/data:rw \
		$(NAME)/jdk:$$jdk_ver java -version | \
		grep -q -F "java version" ; then echo "$(NAME)/jdk:$$jdk_ver - java version command failed."; false; fi ; \
	done

.PHONY: jdk_rm
jdk_rm: 
	@for jdk_ver in $(JDK_IMAGES); \
	do \
	echo "Removing '$$jdk_ver jdk' image..." ; \
	echo " " ; \
	if $(DOCKER_BIN) images $(NAME)/jdk | awk '{ print $$2 }' | grep -q -F $$jdk_ver; then $(DOCKER_BIN) rmi -f $(NAME)/jdk:$$jdk_ver; fi ; \
	done



.PHONY: dot 
dot:
	@echo " "
	@echo " "
	@echo "Building 'dot' image..."
	@echo " "
	$(DOCKER_BIN) build --rm -t $(NAME)/dot:$(VERSION) $(CURRENT_DIR)/dot
	cp -pR $(CURRENT_DIR)/templates/dot/README.md $(CURRENT_DIR)/dot/README.md
	sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/dot/g' $(CURRENT_DIR)/dot/README.md
	sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' $(CURRENT_DIR)/dot/README.md
	sed -i 's/###-->ZZZ_BASE_IMAGE<--###/pinterb\/base:alpine/g' $(CURRENT_DIR)/dot/README.md
	sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' $(CURRENT_DIR)/dot/README.md

.PHONY: dot_test
dot_test: 
	@echo "Testing 'dot' image..."
	@echo " "
	cat $(CURRENT_DIR)/mush/terraform.tfvars.tmpl | $(DOCKER_BIN) run -i \
		-v $(CURRENT_DIR)/graphviz/extras:/home/dev/.extra \
		-v $(CURRENT_DIR)/graphviz:/home/dev/.ssh \
		-e MUSH_EXTRA=/home/dev/.extra \
		-e AZURE_SETTINGS_FILE=/home/dev/.azure.settings \
		-e AZURE_CERT=/home/dev/.azure.cer \
		-e AZURE_REGION="West US"  \
		-e DOMAIN_NAME="example.com" \
		$(NAME)/graphviz:$(VERSION) > $(CURRENT_DIR)/graphviz/terraform.tfvars
	@if ! cat $(CURRENT_DIR)/graphviz/terraform.tfvars | grep -q -F example.com; then echo "graphviz/terraform.tfvars was not rendered with the expected results."; false; fi



.PHONY: misc
misc: mush jq ansible terraform packer jdk jinja2 ansible-lint
	@echo " "
	@echo " "
	@echo "Miscellaneous images have been built."
	@echo " "

.PHONY: misc_test
misc_test: jq_test mush_test ansible_test terraform_test packer_test jdk_test jinja2_test
	@echo " "
	@echo " "
	@echo "Miscellaneous tests have completed."
	@echo " "

.PHONY: misc_rm
misc_rm: terraform_rm packer_rm jdk_rm ansible_rm ansible-lint_rm
	@if $(DOCKER_BIN) images $(NAME)/jq | awk '{ print $$2 }' | grep -q -F latest; then $(DOCKER_BIN) rmi $(NAME)/jq; fi
	@if $(DOCKER_BIN) images $(NAME)/jq | awk '{ print $$2 }' | grep -q -F $(VERSION); then $(DOCKER_BIN) rmi -f $(NAME)/jq:$(VERSION); fi
	@if $(DOCKER_BIN) images $(NAME)/mush | awk '{ print $$2 }' | grep -q -F latest; then $(DOCKER_BIN) rmi $(NAME)/mush; fi
	@if $(DOCKER_BIN) images $(NAME)/mush | awk '{ print $$2 }' | grep -q -F $(VERSION); then $(DOCKER_BIN) rmi -f $(NAME)/mush:$(VERSION); fi
	@if $(DOCKER_BIN) images $(NAME)/jinja2 | awk '{ print $$2 }' | grep -q -F latest; then $(DOCKER_BIN) rmi $(NAME)/jinja2; fi
	@if $(DOCKER_BIN) images $(NAME)/jinja2 | awk '{ print $$2 }' | grep -q -F $(VERSION); then $(DOCKER_BIN) rmi -f $(NAME)/jinja2:$(VERSION); fi



.PHONY: build
build: base misc
	@echo " "
	@echo " "
	@echo "All done with builds."
	@echo " "



.PHONY: test 
test: base_test misc_test
	@echo " "
	@echo " "
	@echo "All done with tests."
	@echo " "



# Push updates to Docker's registry
.PHONY: release_base
release_base: 
	@if ! $(DOCKER_BIN) images $(NAME)/base | awk '{ print $$2 }' | grep -q -F alpine; then echo "$(NAME)/base:alpine is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/base | awk '{ print $$2 }' | grep -q -F ubuntu; then echo "$(NAME)/base:ubuntu is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/base | awk '{ print $$2 }' | grep -q -F debian; then echo "$(NAME)/base:debian is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/base | awk '{ print $$2 }' | grep -q -F centos; then echo "$(NAME)/base:centos is not yet built. Please run 'make build'"; false; fi
	$(DOCKER_BIN) push $(NAME)/base

.PHONY: tag_latest
tag_latest:
	$(DOCKER_BIN) tag -f $(NAME)/jq:$(VERSION) $(NAME)/jq:latest
	$(DOCKER_BIN) tag -f $(NAME)/mush:$(VERSION) $(NAME)/mush:latest
	$(DOCKER_BIN) tag -f $(NAME)/jinja2:$(VERSION) $(NAME)/jinja2:latest
	$(DOCKER_BIN) tag -f $(NAME)/ansible:$(ANSIBLE_CURRENT_VERSION) $(NAME)/ansible:latest
	$(DOCKER_BIN) tag -f $(NAME)/ansible-lint:$(ANSIBLE_LINT_CURRENT_VERSION) $(NAME)/ansible-lint:latest
	$(DOCKER_BIN) tag -f $(NAME)/terraform:$(TERRAFORM_CURRENT_VERSION) $(NAME)/terraform:latest
	$(DOCKER_BIN) tag -f $(NAME)/packer:$(PACKER_CURRENT_VERSION) $(NAME)/packer:latest
	$(DOCKER_BIN) tag -f $(NAME)/jdk:8u66 $(NAME)/jdk:latest

.PHONY: release
release: release_base tag_latest
	@if ! $(DOCKER_BIN) images $(NAME)/jq | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/jq version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/mush | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/mush version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/jinja2 | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/jinja2 version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/ansible | awk '{ print $$2 }' | grep -q -F $(ANSIBLE_CURRENT_VERSION); then echo "$(NAME)/ansible version $(ANSIBLE_CURRENT_VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/ansible-lint | awk '{ print $$2 }' | grep -q -F $(ANSIBLE_LINT_CURRENT_VERSION); then echo "$(NAME)/ansible-lint version $(ANSIBLE_LINT_CURRENT_VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/terraform | awk '{ print $$2 }' | grep -q -F 0.6.8 ; then echo "$(NAME)/terraform version $(TERRAFORM_CURRENT_VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/packer | awk '{ print $$2 }' | grep -q -F 0.8.6 ; then echo "$(NAME)/packer version $(PACKER_CURRENT_VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/jdk | awk '{ print $$2 }' | grep -q -F 8u66 ; then echo "$(NAME)/jdk version 8u66 is not yet built. Please run 'make build'"; false; fi
	$(DOCKER_BIN) push $(NAME)/jq
	$(DOCKER_BIN) push $(NAME)/jinja2
	$(DOCKER_BIN) push $(NAME)/ansible
	$(DOCKER_BIN) push $(NAME)/ansible-lint
	$(DOCKER_BIN) push $(NAME)/terraform
	$(DOCKER_BIN) push $(NAME)/packer
	$(DOCKER_BIN) push $(NAME)/jdk



# Tag current version as a release on GitHub
.PHONY: tag_gh
tag_gh:
		git tag -d rel-$(VERSION); git push origin :refs/tags/rel-$(VERSION); git tag rel-$(VERSION) && git push origin rel-$(VERSION)



# Clean-up the cruft 
.PHONY: clean
clean: clean_untagged misc_rm base_rm clean_untagged
		rm -rf $(CURRENT_DIR)/mush/terraform.tfvars
		rm -rf $(CURRENT_DIR)/jinja2/some.json

.PHONY: clean_untagged
clean_untagged:
		for i in `docker ps --no-trunc -a -q`;do docker rm $$i;done
		docker images --no-trunc | grep none | awk '{print $$3}' | xargs -r docker rmi
