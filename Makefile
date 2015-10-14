#dockerfiles NEW!!
VERSION = 0.0.14
NAME = pinterb

CREATE_DATE := $(shell date +%FT%T%Z)
MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(shell dirname $(MKFILE_PATH))
DOCKER_BIN := $(shell which docker)

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
	@echo " "
	@echo " "
	@echo "Building 'ansible' image..."
	@echo " "
	$(DOCKER_BIN) build -t $(NAME)/ansible $(CURRENT_DIR)/ansible



.PHONY: mush
mush:
	@echo " "
	@echo " "
	@echo "Building 'mush' image..."
	@echo " "
	$(DOCKER_BIN) build --rm -t $(NAME)/mush $(CURRENT_DIR)/mush
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
		$(NAME)/mush > $(CURRENT_DIR)/mush/terraform.tfvars
	@if ! cat $(CURRENT_DIR)/mush/terraform.tfvars | grep -q -F example.com; then echo "mush/terraform.tfvars was not rendered with the expected results."; false; fi



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
	@if ! $(DOCKER_BIN) run $(NAME)/jq | grep -q -F "jq is a tool for processing JSON inputs"; then echo "$(NAME)/jq doesn't appear to run as expected."; false; fi


.PHONY: jq_test
jq_test: 
	@echo "Testing 'jq' image..."
	@echo " "
	@if ! $(DOCKER_BIN) run $(NAME)/jq | grep -q -F "jq is a tool for processing JSON inputs"; then echo "$(NAME)/jq doesn't appear to run as expected."; false; fi



.PHONY: misc
misc: mush jq ansible
	@echo " "
	@echo " "
	@echo "Miscellaneous images have been built."
	@echo " "

.PHONY: misc_test
misc_test: jq_test mush_test
	@echo " "
	@echo " "
	@echo "Miscellaneous tests have completed."
	@echo " "

.PHONY: misc_rm
misc_rm:
	@if docker images $(NAME)/jq | awk '{ print $$2 }' | grep -q -F latest; then $(DOCKER_BIN) rmi $(NAME)/jq; fi
	@if docker images $(NAME)/mush | awk '{ print $$2 }' | grep -q -F latest; then $(DOCKER_BIN) rmi $(NAME)/mush; fi
	@if docker images $(NAME)/ansible | awk '{ print $$2 }' | grep -q -F latest; then $(DOCKER_BIN) rmi $(NAME)/ansible; fi



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
		@if ! docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F alpine; then echo "$(NAME)/base:alpine is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F ubuntu; then echo "$(NAME)/base:ubuntu is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F debian; then echo "$(NAME)/base:debian is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F centos; then echo "$(NAME)/base:centos is not yet built. Please run 'make build'"; false; fi
		docker push $(NAME)/base

.PHONY: tag_latest
tag_latest:
		docker tag -f $(NAME)/jq:$(VERSION) $(NAME)/jq:latest

.PHONY: release
release: release_base tag_latest
		@if ! docker images $(NAME)/jq | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/jq version $(VERSION) is not yet built. Please run 'make build'"; false; fi



# Tag current version as a release on GitHub
.PHONY: tag_gh
tag_gh:
		git tag -d rel-$(VERSION); git push origin :refs/tags/rel-$(VERSION); git tag rel-$(VERSION) && git push origin rel-$(VERSION)



# Clean-up the cruft 
.PHONY: clean
clean: clean_untagged misc_rm base_rm clean_untagged
		rm -rf $(CURRENT_DIR)/mush/terraform.tfvars

.PHONY: clean_untagged
clean_untagged:
		for i in `docker ps --no-trunc -a -q`;do docker rm $$i;done
		docker images --no-trunc | grep none | awk '{print $$3}' | xargs -r docker rmi
