#dockerfiles NEW!!
VERSION = 0.0.14
NAME = pinterb

CREATE_DATE := $(shell date +%FT%T%Z)
MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(shell dirname $(MKFILE_PATH))
DOCKER_BIN := $(shell which docker)

all: build

.PHONY: check.env
check.env:
ifndef DOCKER_BIN
   $(error The docker command is not found. Verify that Docker is installed and accessible)
endif

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

.PHONY: mush
mush:
	@echo " "
	@echo " "
	@echo "Building 'mush' image..."
	@echo " "
	$(DOCKER_BIN) build --rm -t $(NAME)/mush $(CURRENT_DIR)/mush

.PHONY: jq
jq:
	@echo " "
	@echo " "
	@echo "Building 'jq' image..."
	@echo " "
	$(DOCKER_BIN) build --rm -t $(NAME)/jq $(CURRENT_DIR)/jq

.PHONY: misc
misc: mush jq
	@echo " "
	@echo " "
	@echo "Miscellaneous images have been built."
	@echo " "

.PHONY: build
build: base misc
	@echo " "
	@echo " "
	@echo "All done with builds."
	@echo " "

.PHONY: release_base
release_base: 
		@if ! docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F alpine; then echo "$(NAME)/base:alpine is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F ubuntu; then echo "$(NAME)/base:ubuntu is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F debian; then echo "$(NAME)/base:debian is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F centos; then echo "$(NAME)/base:centos is not yet built. Please run 'make build'"; false; fi
		docker push $(NAME)/base

.PHONY: tag_gh
tag_gh:
		git tag -d rel-$(VERSION); git push origin :refs/tags/rel-$(VERSION); git tag rel-$(VERSION) && git push origin rel-$(VERSION)
		
.PHONY: clean
clean: clean_untagged
		rm -rf ubuntu_python_base_image
		rm -rf ubuntu_python_dev_image
		rm -rf ubuntu_python_falcon_image
		rm -rf ubuntu_golang_base_image
		rm -rf ubuntu_perl_base_image
		rm -rf ubuntu_perl_dev_image
		rm -rf ubuntu_perl_mojo_image
		rm -rf ubuntu_json_base_image 
		rm -rf ubuntu_ansible_base_image 
		rm -rf ubuntu_swaggerui_base_image
		rm -rf ubuntu_swaggereditor_base_image

.PHONY: clean_untagged
clean_untagged:
		for i in `docker ps --no-trunc -a -q`;do docker rm $$i;done
		docker images --no-trunc | grep none | awk '{print $$3}' | xargs -r docker rmi
