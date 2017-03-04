VERSION = 0.0.16
NAME = pinterb

VCS_URL ?= $(shell git remote get-url origin)
VCS_REF ?= $(shell git rev-parse --short HEAD)

CREATE_DATE := $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")
MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(shell dirname $(MKFILE_PATH))
DOCKER_BIN := $(shell which docker)

TERRAFORM_CURRENT_VERSION = 0.7.9
TERRAFORM_IMAGES = 0.7.9

PACKER_CURRENT_VERSION = 0.8.6
PACKER_IMAGES = 0.8.6

ANSIBLE_CURRENT_VERSION = 2.1.0.0
ANSIBLE_IMAGES = 2.0.0.2 \
	2.1.0.0

ANSIBLE_LINT_CURRENT_VERSION = 2.3.1
ANSIBLE_LINT_IMAGES = 2.3.1

SYNCTHING_CURRENT_VERSION = 0.14.7
SYNCTHING_IMAGES = 0.14.7

JDK_IMAGES = 8u66

JO_CURRENT_VERSION = 1.0
JO_IMAGES = 1.0

KARGO_CURRENT_VERSION = 0.3.10
KARGO_IMAGES = 0.3.10 \
	0.4.3

CONSUL_CURRENT_VERSION = 0.6.4
CONSUL_IMAGES = 0.6.4

SWAGGER_CLI_CURRENT_VERSION = 1.0.0-beta.2
SWAGGER_CLI_IMAGES = 1.0.0-beta.2

SWAGGER_CODEGEN_CURRENT_VERSION = 2.2.0
SWAGGER_CODEGEN_IMAGES = 2.2.0

VAULT_CURRENT_VERSION = 0.6.4
VAULT_IMAGES = 0.6.5

JENKINS_JNLP_SLAVE_CURRENT_VERSION = 2.62
JENKINS_JNLP_SLAVE_IMAGES = 2.62

JENKINS_CURRENT_VERSION = 2.32.3
JENKINS_IMAGES = 2.32.3



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

.PHONY: ubuntu-slim
ubuntu-slim:
	@echo " "
	@echo " "
	@echo "Building 'base/ubuntu-slim' image..."
	@echo " "
	cd $(CURRENT_DIR)/base/ubuntu-slim && $(MAKE) container
	cd $(CURRENT_DIR)

.PHONY: base
base: alpine ubuntu debian centos ubuntu-slim
	@echo " "
	@echo " "
	@echo "Base images have been built."
	@echo " "

.PHONY: base_test
base_test:
	@if ! $(DOCKER_BIN) run $(NAME)/base:ubuntu /bin/sh -c 'cat /etc/*-release' | grep -q -F Ubuntu; then false; fi
	@if ! $(DOCKER_BIN) run $(NAME)/base:ubuntu-slim /bin/sh -c 'cat /etc/*-release' | grep -q -F Ubuntu; then false; fi
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
	@if docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F ubuntu-slim; then $(DOCKER_BIN) rmi $(NAME)/base:ubuntu-slim; fi
	@if docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F ubuntu; then $(DOCKER_BIN) rmi $(NAME)/base:ubuntu; fi
	@if docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F centos; then $(DOCKER_BIN) rmi $(NAME)/base:centos; fi
	@if docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F debian; then $(DOCKER_BIN) rmi $(NAME)/base:debian; fi



### Misc images

.PHONY: ansible
ansible: alpine
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
ansible-lint: alpine
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
terraform: alpine
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
		-e "PGID=$$(id -g)" -e "PUID=$$(id -u)" \
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



.PHONY: syncthing
syncthing: alpine
	@for tf_ver in $(SYNCTHING_IMAGES); \
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
	sed -i "s/###-->ZZZ_SYNCTHING_VERSION<--###/$$tf_ver/g" $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i "s/###-->ZZZ_CURRENT_VERSION<--###/$(SYNCTHING_CURRENT_VERSION)/g" $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	done
		
.PHONY: syncthing_test
syncthing_test:
	@for tf_ver in $(SYNCTHING_IMAGES); \
	do \
	echo "Testing '$$tf_ver syncthing' image..." ; \
	echo " " ; \
	if ! $(DOCKER_BIN) run -it \
		-v $(CURRENT_DIR)/syncthing/$$tf_ver/example/data:/data:rw \
		$(NAME)/syncthing:$$tf_ver version | \
		grep -q -F "syncthing v$$tf_ver" ; then echo "$(NAME)/syncthing:$$tf_ver - syncthing version command failed."; false; fi ; \
	done

.PHONY: syncthing_rm
syncthing_rm:
	@for tf_ver in $(SYNCTHING_IMAGES); \
	do \
	echo "Removing '$$tf_ver syncthing' image..." ; \
	echo " " ; \
	if $(DOCKER_BIN) images $(NAME)/syncthing | awk '{ print $$2 }' | grep -q -F $$tf_ver; then $(DOCKER_BIN) rmi -f $(NAME)/syncthing:$$tf_ver; fi ; \
	done



.PHONY: packer
packer: alpine
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
jinja2: alpine
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
		-e "PGID=0" -e "PUID=0" \
		$(NAME)/jinja2:$(VERSION) datacenter='msp' acl_ttl='30m' > $(CURRENT_DIR)/jinja2/some.json
	@if ! cat $(CURRENT_DIR)/jinja2/some.json | grep -q -F '"datacenter": "msp"'; then echo "jinja2/some.json was not rendered with the expected results."; false; fi



.PHONY: jq
jq: alpine
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
jdk: alpine
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
	echo "Testing '$$jdk_ver jdk' image..." ; \
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



.PHONY: jo
jo: alpine
	@for jo_ver in $(JO_IMAGES); \
	do \
	echo " " ; \
	echo " " ; \
	echo "Building '$$jo_ver $@' image..." ; \
	echo " " ; \
	$(DOCKER_BIN) build --rm -t $(NAME)/$@:$$jo_ver $(CURRENT_DIR)/$@/$$jo_ver ; \
	cp -pR $(CURRENT_DIR)/templates/$@/README.md $(CURRENT_DIR)/$@/$$jo_ver/README.md ; \
	sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/$@/g' $(CURRENT_DIR)/$@/$$jo_ver/README.md ; \
	sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' $(CURRENT_DIR)/$@/$$jo_ver/README.md ; \
	sed -i 's/###-->ZZZ_BASE_IMAGE<--###/$(NAME)\/base:alpine/g' $(CURRENT_DIR)/$@/$$jo_ver/README.md ; \
	sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' $(CURRENT_DIR)/$@/$$jo_ver/README.md ; \
	sed -i "s/###-->ZZZ_JO_VERSION<--###/$$jo_ver/g" $(CURRENT_DIR)/$@/$$jo_ver/README.md ; \
	sed -i "s/###-->ZZZ_CURRENT_VERSION<--###/$(JO_CURRENT_VERSION)/g" $(CURRENT_DIR)/$@/$$jo_ver/README.md ; \
	done

.PHONY: jo_test
jo_test:
	@for jo_ver in $(JO_IMAGES); \
	do \
	echo "Testing '$$jo_ver jo' image..." ; \
	echo " " ; \
	if ! $(DOCKER_BIN) run -it \
		$(NAME)/jo:$$jo_ver -v | \
		grep -q -F "jo $$jo_ver" ; then echo "$(NAME)/jo:$$jo_ver - jo version command failed."; false; fi ; \
	done

.PHONY: jo_rm
jo_rm:
	@for jo_ver in $(JO_IMAGES); \
	do \
	echo "Removing '$$jo_ver jo' image..." ; \
	echo " " ; \
	if $(DOCKER_BIN) images $(NAME)/jo | awk '{ print $$2 }' | grep -q -F $$jo_ver; then $(DOCKER_BIN) rmi -f $(NAME)/jo:$$jo_ver; fi ; \
	done



.PHONY: consul
consul:
	@for consul_ver in $(CONSUL_IMAGES); \
	do \
	echo " " ; \
	echo " " ; \
	echo "Building '$$consul_ver $@' image..." ; \
	echo " " ; \
	$(DOCKER_BIN) build --rm -t $(NAME)/$@:$$consul_ver $(CURRENT_DIR)/$@/$$consul_ver ; \
	cp -pR $(CURRENT_DIR)/templates/$@/README.md $(CURRENT_DIR)/$@/$$consul_ver/README.md ; \
	sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/$@/g' $(CURRENT_DIR)/$@/$$consul_ver/README.md ; \
	sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' $(CURRENT_DIR)/$@/$$consul_ver/README.md ; \
	sed -i 's/###-->ZZZ_BASE_IMAGE<--###/$(NAME)\/base:alpine/g' $(CURRENT_DIR)/$@/$$consul_ver/README.md ; \
	sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' $(CURRENT_DIR)/$@/$$consul_ver/README.md ; \
	sed -i "s/###-->ZZZ_CONSUL_VERSION<--###/$$consul_ver/g" $(CURRENT_DIR)/$@/$$consul_ver/README.md ; \
	sed -i "s/###-->ZZZ_CURRENT_VERSION<--###/$(CONSUL_CURRENT_VERSION)/g" $(CURRENT_DIR)/$@/$$consul_ver/README.md ; \
	done

.PHONY: consul_test
consul_test:
	@for consul_ver in $(CONSUL_IMAGES); \
	do \
	echo "Testing '$$consul_ver consul' image..." ; \
	echo " " ; \
	if ! $(DOCKER_BIN) run -it \
		$(NAME)/consul:$$consul_ver --version | \
		grep -q -F "Consul v$$consul_ver" ; then echo "$(NAME)/consul:$$consul_ver - consul version command failed."; false; fi ; \
	done

.PHONY: consul_rm
consul_rm:
	@for consul_ver in $(CONSUL_IMAGES); \
	do \
	echo "Removing '$$consul_ver consul' image..." ; \
	echo " " ; \
	if $(DOCKER_BIN) images $(NAME)/consul | awk '{ print $$2 }' | grep -q -F $$consul_ver; then $(DOCKER_BIN) rmi -f $(NAME)/consul:$$consul_ver; fi ; \
	done



.PHONY: swagger
swagger:
	@for swagger_ver in $(SWAGGER_CLI_IMAGES); \
	do \
	echo " " ; \
	echo " " ; \
	echo "Building '$$swagger_ver $@' image..." ; \
	echo " " ; \
	$(DOCKER_BIN) build --rm -t $(NAME)/$@:$$swagger_ver $(CURRENT_DIR)/$@/$$swagger_ver ; \
	cp -pR $(CURRENT_DIR)/templates/$@/README.md $(CURRENT_DIR)/$@/$$swagger_ver/README.md ; \
	sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/$@/g' $(CURRENT_DIR)/$@/$$swagger_ver/README.md ; \
	sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' $(CURRENT_DIR)/$@/$$swagger_ver/README.md ; \
	sed -i 's/###-->ZZZ_BASE_IMAGE<--###/$(NAME)\/base:alpine/g' $(CURRENT_DIR)/$@/$$swagger_ver/README.md ; \
	sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' $(CURRENT_DIR)/$@/$$swagger_ver/README.md ; \
	sed -i "s/###-->ZZZ_SWAGGER_VERSION<--###/$$swagger_ver/g" $(CURRENT_DIR)/$@/$$swagger_ver/README.md ; \
	sed -i "s/###-->ZZZ_CURRENT_VERSION<--###/$(SWAGGER_CLI_CURRENT_VERSION)/g" $(CURRENT_DIR)/$@/$$swagger_ver/README.md ; \
	done

.PHONY: swagger_test
swagger_test:
	@for swagger_ver in $(SWAGGER_CLI_IMAGES); \
	do \
	echo "Testing '$$swagger_ver swagger' image..." ; \
	echo " " ; \
	if ! $(DOCKER_BIN) run -it \
		$(NAME)/swagger:$$swagger_ver --version | \
		grep -q -F "$$swagger_ver" ; then echo "$(NAME)/swagger:$$swagger_ver - swagger-cli version command failed."; false; fi ; \
	done

.PHONY: swagger_rm
swagger_rm:
	@for swagger_ver in $(SWAGGER_CLI_IMAGES); \
	do \
	echo "Removing '$$swagger_ver swagger' image..." ; \
	echo " " ; \
	if $(DOCKER_BIN) images $(NAME)/swagger | awk '{ print $$2 }' | grep -q -F $$swagger_ver; then $(DOCKER_BIN) rmi -f $(NAME)/swagger:$$swagger_ver; fi ; \
	done



.PHONY: swagger-codegen
swagger-codegen:
	@for swagger_ver in $(SWAGGER_CODEGEN_IMAGES); \
	do \
	echo " " ; \
	echo " " ; \
	echo "Building '$$swagger_ver $@' image..." ; \
	echo " " ; \
	$(DOCKER_BIN) build --rm -t $(NAME)/$@:$$swagger_ver $(CURRENT_DIR)/$@/$$swagger_ver ; \
	cp -pR $(CURRENT_DIR)/templates/$@/README.md $(CURRENT_DIR)/$@/$$swagger_ver/README.md ; \
	sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/$@/g' $(CURRENT_DIR)/$@/$$swagger_ver/README.md ; \
	sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' $(CURRENT_DIR)/$@/$$swagger_ver/README.md ; \
	sed -i 's/###-->ZZZ_BASE_IMAGE<--###/$(NAME)\/base:alpine/g' $(CURRENT_DIR)/$@/$$swagger_ver/README.md ; \
	sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' $(CURRENT_DIR)/$@/$$swagger_ver/README.md ; \
	sed -i "s/###-->ZZZ_SWAGGER_CODEGEN_VERSION<--###/$$swagger_ver/g" $(CURRENT_DIR)/$@/$$swagger_ver/README.md ; \
	sed -i "s/###-->ZZZ_CURRENT_VERSION<--###/$(SWAGGER_CODEGEN_CURRENT_VERSION)/g" $(CURRENT_DIR)/$@/$$swagger_ver/README.md ; \
	done

.PHONY: swagger-codegen_test
swagger-codegen_test:
	@for swagger_ver in $(SWAGGER_CODEGEN_IMAGES); \
	do \
	echo "Testing '$$swagger_ver swagger' image..." ; \
	echo " " ; \
	if ! $(DOCKER_BIN) run -it \
		$(NAME)/swagger-codegen:$$swagger_ver langs | \
		grep -q -F "go-server" ; then echo "$(NAME)/swagger-codegen:$$swagger_ver - swagger-codegen langs command failed."; false; fi ; \
	done

.PHONY: swagger-codegen_rm
swagger-codegen_rm:
	@for swagger_ver in $(SWAGGER_CODEGEN_IMAGES); \
	do \
	echo "Removing '$$swagger_ver swagger-codegen' image..." ; \
	echo " " ; \
	if $(DOCKER_BIN) images $(NAME)/swagger-codegen | awk '{ print $$2 }' | grep -q -F $$swagger_ver; then $(DOCKER_BIN) rmi -f $(NAME)/swagger-codegen:$$swagger_ver; fi ; \
	done



.PHONY: kargo
kargo: alpine
	@for tf_ver in $(KARGO_IMAGES); \
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
	sed -i "s/###-->ZZZ_CURRENT_VERSION<--###/$(KARGO_CURRENT_VERSION)/g" $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i "s/###-->ZZZ_VERSION<--###/$$tf_ver/g" $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	sed -i "s/###-->ZZZ_KARGO_VERSION<--###/$$tf_ver/g" $(CURRENT_DIR)/$@/$$tf_ver/README.md ; \
	done

.PHONY: kargo_test
kargo_test:
	@for tf_ver in $(KARGO_IMAGES); \
	do \
	echo "Testing '$$tf_ver kargo' image..." ; \
	echo " " ; \
	if ! $(DOCKER_BIN) run -it \
		-v $(CURRENT_DIR)/kargo:/kargo:rw \
		$(NAME)/kargo:$$tf_ver --version | \
		grep -q -F "kargo $$tf_ver" ; then echo "$(NAME)/kargo:$$tf_ver - kargo command failed."; false; fi; \
	done

.PHONY: kargo_rm
kargo_rm:
	@for tf_ver in $(KARGO_IMAGES); \
	do \
	echo "Removing '$$tf_ver kargo' image..." ; \
	echo " " ; \
	if $(DOCKER_BIN) images $(NAME)/kargo | awk '{ print $$2 }' | grep -q -F $$tf_ver; then $(DOCKER_BIN) rmi -f $(NAME)/kargo:$$tf_ver; fi ; \
	done



.PHONY: vault 
vault:
	@for vault_ver in $(VAULT_IMAGES); \
	do \
	echo " " ; \
	echo " " ; \
	echo "Building '$$vault_ver $@' image..." ; \
	echo " " ; \
	$(DOCKER_BIN) build --rm -t $(NAME)/$@:$$vault_ver $(CURRENT_DIR)/$@/$$vault_ver ; \
	cp -pR $(CURRENT_DIR)/templates/$@/README.md $(CURRENT_DIR)/$@/$$vault_ver/README.md ; \
	sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/$@/g' $(CURRENT_DIR)/$@/$$vault_ver/README.md ; \
	sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' $(CURRENT_DIR)/$@/$$vault_ver/README.md ; \
	sed -i 's/###-->ZZZ_BASE_IMAGE<--###/vault:0.6.4/g' $(CURRENT_DIR)/$@/$$vault_ver/README.md ; \
	sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' $(CURRENT_DIR)/$@/$$vault_ver/README.md ; \
	sed -i "s/###-->ZZZ_VAULT_VERSION<--###/$$vault_ver/g" $(CURRENT_DIR)/$@/$$vault_ver/README.md ; \
	sed -i "s/###-->ZZZ_CURRENT_VERSION<--###/$(VAULT_CURRENT_VERSION)/g" $(CURRENT_DIR)/$@/$$vault_ver/README.md ; \
	done

.PHONY: vault_test
vault_test:
	@for vault_ver in $(VAULT_IMAGES); \
	do \
	echo "Testing '$$vault_ver vault' image..." ; \
	echo " " ; \
	if ! $(DOCKER_BIN) run -it \
		$(NAME)/vault:$$vault_ver version | \
		grep -q -F "Vault v$$vault_ver" ; then echo "$(NAME)/vault:$$vault_ver - vault version command failed."; false; fi; \
	done

.PHONY: vault_rm
vault_rm:
	@for vault_ver in $(VAULT_IMAGES); \
	do \
	echo "Removing '$$vault_ver vault' image..." ; \
	echo " " ; \
	if $(DOCKER_BIN) images $(NAME)/vault | awk '{ print $$2 }' | grep -q -F $$vault_ver; then $(DOCKER_BIN) rmi -f $(NAME)/vault:$$vault_ver; fi ; \
	done



.PHONY: jenkins-jnlp-slave
jenkins-jnlp-slave:
	@for jenkins_jnlp_slave_ver in $(JENKINS_JNLP_SLAVE_IMAGES); \
	do \
	echo " " ; \
	echo " " ; \
	echo "Building '$$jenkins_jnlp_slave_ver $@' image..." ; \
	echo " " ; \
	$(DOCKER_BIN) build --rm \
	--build-arg VCS_URL=$(VCS_URL) \
	--build-arg VCS_REF=$(VCS_REF) \
	--build-arg BUILD_DATE=$(CREATE_DATE) \
	--build-arg VERSION=$$jenkins_jnlp_slave_ver \
	-t $(NAME)/$@:$$jenkins_jnlp_slave_ver $(CURRENT_DIR)/$@/$$jenkins_jnlp_slave_ver ; \
	cp -pR $(CURRENT_DIR)/templates/$@/README.md $(CURRENT_DIR)/$@/$$jenkins_jnlp_slave_ver/README.md ; \
	sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/$@/g' $(CURRENT_DIR)/$@/$$jenkins_jnlp_slave_ver/README.md ; \
	sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' $(CURRENT_DIR)/$@/$$jenkins_jnlp_slave_ver/README.md ; \
	sed -i 's/###-->ZZZ_BASE_IMAGE<--###/jenkinsci\/jnlp-slave/g' $(CURRENT_DIR)/$@/$$jenkins_jnlp_slave_ver/README.md ; \
	sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' $(CURRENT_DIR)/$@/$$jenkins_jnlp_slave_ver/README.md ; \
	sed -i "s/###-->ZZZ_JENKINS_JNLP_SLAVE_VERSION<--###/$$jenkins_jnlp_slave_ver/g" $(CURRENT_DIR)/$@/$$jenkins_jnlp_slave_ver/README.md ; \
	sed -i "s/###-->ZZZ_CURRENT_VERSION<--###/$(JENKINS_JNLP_SLAVE_CURRENT_VERSION)/g" $(CURRENT_DIR)/$@/$$jenkins_jnlp_slave_ver/README.md ; \
	done

.PHONY: jenkins-jnlp-slave_test
jenkins-jnlp-slave_test:
	@for jenkins_jnlp_slave_ver in $(JENKINS_JNLP_SLAVE_IMAGES); \
	do \
	echo "Testing '$$jenkins_jnlp_slave_ver jenkins-jnlp-slave' image..." ; \
	echo " " ; \
	done

.PHONY: jenkins-jnlp-slave_rm
jenkins-jnlp-slave_rm:
	@for jenkins_jnlp_slave_ver in $(JENKINS_JNLP_SLAVE_IMAGES); \
	do \
	echo "Removing '$$jenkins_jnlp_slave_ver jenkins-jnlp-slave' image..." ; \
	echo " " ; \
	if $(DOCKER_BIN) images $(NAME)/jenkins-jnlp-slave | awk '{ print $$2 }' | grep -q -F $$jenkins_jnlp_slave_ver; then $(DOCKER_BIN) rmi -f $(NAME)/jenkins-jnlp-slave:$$jenkins_jnlp_slave_ver; fi ; \
	done



.PHONY: jenkins
jenkins:
	@for jenkins_ver in $(JENKINS_IMAGES); \
	do \
	echo " " ; \
	echo " " ; \
	echo "Building '$$jenkins_ver $@' image..." ; \
	echo " " ; \
	$(DOCKER_BIN) build --rm \
	--build-arg VCS_URL=$(VCS_URL) \
	--build-arg VCS_REF=$(VCS_REF) \
	--build-arg BUILD_DATE=$(CREATE_DATE) \
	--build-arg VERSION=$$jenkins_ver \
	-t $(NAME)/$@:$$jenkins_ver $(CURRENT_DIR)/$@/$$jenkins_ver ; \
	cp -pR $(CURRENT_DIR)/templates/$@/README.md $(CURRENT_DIR)/$@/$$jenkins_ver/README.md ; \
	sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/$@/g' $(CURRENT_DIR)/$@/$$jenkins_ver/README.md ; \
	sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' $(CURRENT_DIR)/$@/$$jenkins_ver/README.md ; \
	sed -i 's/###-->ZZZ_BASE_IMAGE<--###/jenkins/g' $(CURRENT_DIR)/$@/$$jenkins_ver/README.md ; \
	sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' $(CURRENT_DIR)/$@/$$jenkins_ver/README.md ; \
	sed -i "s/###-->ZZZ_JENKINS_VERSION<--###/$$jenkins_ver/g" $(CURRENT_DIR)/$@/$$jenkins_ver/README.md ; \
	sed -i "s/###-->ZZZ_CURRENT_VERSION<--###/$(JENKINS_CURRENT_VERSION)/g" $(CURRENT_DIR)/$@/$$jenkins_ver/README.md ; \
	done

.PHONY: jenkins_test
jenkins_test:
	@for jenkins_ver in $(JENKINS_IMAGES); \
	do \
	echo "Testing '$$jenkins_ver jenkins' image..." ; \
	echo " " ; \
	done

.PHONY: jenkins_rm
jenkins_rm:
	@for jenkins_ver in $(JENKINS_IMAGES); \
	do \
	echo "Removing '$$jenkins_ver jenkins' image..." ; \
	echo " " ; \
	if $(DOCKER_BIN) images $(NAME)/jenkins | awk '{ print $$2 }' | grep -q -F $$jenkins_ver; then $(DOCKER_BIN) rmi -f $(NAME)/jenkins:$$jenkins_ver; fi ; \
	done



.PHONY: misc
misc: mush jq ansible terraform packer jdk jinja2 syncthing jo consul swagger swagger-codegen vault jenkins-jnlp-slave jenkins
	@echo " "
	@echo " "
	@echo "Miscellaneous images have been built."
	@echo " "

.PHONY: misc_test
misc_test: jq_test mush_test ansible_test terraform_test packer_test jdk_test jinja2_test syncthing_test jo_test consul_test swagger_test swagger-codegen_test vault_test jenkins-jnlp-slave_test jenkins_test
	@echo " "
	@echo " "
	@echo "Miscellaneous tests have completed."
	@echo " "

.PHONY: misc_rm
misc_rm: terraform_rm packer_rm jdk_rm ansible_rm syncthing_rm jo_rm consul_rm swagger_rm swagger-codegen_rm vault_rm jenkins-jnlp-slave_rm jenkins_rm
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
	@if ! $(DOCKER_BIN) images $(NAME)/base | awk '{ print $$2 }' | grep -q -F ubuntu-slim; then echo "$(NAME)/base:ubuntu-slim is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/base | awk '{ print $$2 }' | grep -q -F ubuntu; then echo "$(NAME)/base:ubuntu is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/base | awk '{ print $$2 }' | grep -q -F debian; then echo "$(NAME)/base:debian is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/base | awk '{ print $$2 }' | grep -q -F centos; then echo "$(NAME)/base:centos is not yet built. Please run 'make build'"; false; fi
	$(DOCKER_BIN) push $(NAME)/base

.PHONY: tag_latest
tag_latest:
	$(DOCKER_BIN) tag $(NAME)/jq:$(VERSION) $(NAME)/jq:latest
	$(DOCKER_BIN) tag $(NAME)/mush:$(VERSION) $(NAME)/mush:latest
	$(DOCKER_BIN) tag $(NAME)/jinja2:$(VERSION) $(NAME)/jinja2:latest
	$(DOCKER_BIN) tag $(NAME)/ansible:$(ANSIBLE_CURRENT_VERSION) $(NAME)/ansible:latest
	$(DOCKER_BIN) tag $(NAME)/terraform:$(TERRAFORM_CURRENT_VERSION) $(NAME)/terraform:latest
	$(DOCKER_BIN) tag $(NAME)/syncthing:$(SYNCTHING_CURRENT_VERSION) $(NAME)/syncthing:latest
	$(DOCKER_BIN) tag $(NAME)/packer:$(PACKER_CURRENT_VERSION) $(NAME)/packer:latest
	$(DOCKER_BIN) tag $(NAME)/jdk:8u66 $(NAME)/jdk:latest
	$(DOCKER_BIN) tag $(NAME)/jo:$(JO_CURRENT_VERSION) $(NAME)/jo:latest
	$(DOCKER_BIN) tag $(NAME)/consul:$(CONSUL_CURRENT_VERSION) $(NAME)/consul:latest
	$(DOCKER_BIN) tag $(NAME)/swagger:$(SWAGGER_CLI_CURRENT_VERSION) $(NAME)/swagger:latest
	$(DOCKER_BIN) tag $(NAME)/swagger-codegen:$(SWAGGER_CODEGEN_CURRENT_VERSION) $(NAME)/swagger-codegen:latest
	$(DOCKER_BIN) tag $(NAME)/vault:$(VAULT_CURRENT_VERSION) $(NAME)/vault:latest
	$(DOCKER_BIN) tag $(NAME)/jenkins-jnlp-slave:$(JENKINS_JNLP_SLAVE_CURRENT_VERSION) $(NAME)/jenkins-jnlp-slave:latest
	$(DOCKER_BIN) tag $(NAME)/jenkins:$(JENKINS_CURRENT_VERSION) $(NAME)/jenkins:latest

.PHONY: release
release: release_base tag_latest
	@if ! $(DOCKER_BIN) images $(NAME)/jq | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/jq version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/mush | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/mush version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/jinja2 | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/jinja2 version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/ansible | awk '{ print $$2 }' | grep -q -F $(ANSIBLE_CURRENT_VERSION); then echo "$(NAME)/ansible version $(ANSIBLE_CURRENT_VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/terraform | awk '{ print $$2 }' | grep -q -F $(TERRAFORM_CURRENT_VERSION) ; then echo "$(NAME)/terraform version $(TERRAFORM_CURRENT_VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/packer | awk '{ print $$2 }' | grep -q -F $(PACKER_CURRENT_VERSION) ; then echo "$(NAME)/packer version $(PACKER_CURRENT_VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/jdk | awk '{ print $$2 }' | grep -q -F 8u66 ; then echo "$(NAME)/jdk version 8u66 is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/jo | awk '{ print $$2 }' | grep -q -F $(JO_CURRENT_VERSION) ; then echo "$(NAME)/jo version $(JO_CURRENT_VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/syncthing | awk '{ print $$2 }' | grep -q -F $(SYNCTHING_CURRENT_VERSION) ; then echo "$(NAME)/syncthing version $(SYNCTHING_CURRENT_VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/consul | awk '{ print $$2 }' | grep -q -F $(CONSUL_CURRENT_VERSION); then echo "$(NAME)/consul version $(CONSUL_CURRENT_VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/swagger | awk '{ print $$2 }' | grep -q -F $(SWAGGER_CLI_CURRENT_VERSION); then echo "$(NAME)/swagger version $(SWAGGER_CURRENT_VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/swagger-codegen | awk '{ print $$2 }' | grep -q -F $(SWAGGER_CODEGEN_CURRENT_VERSION); then echo "$(NAME)/swagger-codegen version $(SWAGGER_CODEGEN_CURRENT_VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/vault | awk '{ print $$2 }' | grep -q -F $(VAULT_CURRENT_VERSION); then echo "$(NAME)/vault version $(VAULT_CURRENT_VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/jenkins-jnlp-slave | awk '{ print $$2 }' | grep -q -F $(JENKINS_JNLP_SLAVE_CURRENT_VERSION); then echo "$(NAME)/jenkins-jnlp-slave version $(JENKINS_JNLP_SLAVE_VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! $(DOCKER_BIN) images $(NAME)/jenkins | awk '{ print $$2 }' | grep -q -F $(JENKINS_CURRENT_VERSION); then echo "$(NAME)/jenkins version $(JENKINS_VERSION) is not yet built. Please run 'make build'"; false; fi
	$(DOCKER_BIN) push $(NAME)/jq
	$(DOCKER_BIN) push $(NAME)/jinja2
	$(DOCKER_BIN) push $(NAME)/ansible
	$(DOCKER_BIN) push $(NAME)/terraform
	$(DOCKER_BIN) push $(NAME)/syncthing
	$(DOCKER_BIN) push $(NAME)/packer
	$(DOCKER_BIN) push $(NAME)/jdk
	$(DOCKER_BIN) push $(NAME)/jo
	$(DOCKER_BIN) push $(NAME)/consul
	$(DOCKER_BIN) push $(NAME)/swagger
	$(DOCKER_BIN) push $(NAME)/swagger-codegen
	$(DOCKER_BIN) push $(NAME)/vault
	$(DOCKER_BIN) push $(NAME)/jenkins-jnlp-slave
	$(DOCKER_BIN) push $(NAME)/jenkins



# Tag current version as a release on GitHub
.PHONY: tag_gh
tag_gh:
	git tag -d rel-$(VERSION); git push origin :refs/tags/rel-$(VERSION); git tag rel-$(VERSION) && git push origin rel-$(VERSION)



# Clean-up the cruft
.PHONY: clean
clean: clean_untagged clean_slim misc_rm base_rm clean_untagged
	rm -rf $(CURRENT_DIR)/mush/terraform.tfvars
	rm -rf $(CURRENT_DIR)/jinja2/some.json

.PHONY: clean_slim
clean_slim:
	@if $(DOCKER_BIN) images $(NAME)/base | awk '{ print $$2 }' | grep -q -F ubuntu-slim; then \
	cd $(CURRENT_DIR)/base/ubuntu-slim && $(MAKE) clean; \
	cd $(CURRENT_DIR); \
	fi;

#	docker images -q --filter "dangling=true" | xargs -l docker rmi
#	docker images --no-trunc | grep none | awk '{print $$3}' | xargs -r docker rmi
.PHONY: clean_untagged
clean_untagged: clean_stopped
	docker images --no-trunc | grep none | awk '{print $$3}' | xargs -r docker rmi

.PHONY: clean_stopped
clean_stopped:
	for i in `docker ps --no-trunc -a -q`;do docker rm $$i;done
