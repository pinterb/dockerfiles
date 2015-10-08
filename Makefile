#dockerfiles NEW!!
VERSION = 0.0.14
NAME = pinterb

CREATE_DATE := $(shell date +%FT%T%Z)
MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(shell dirname $(MKFILE_PATH))
DOCKER_BIN := $(shell which docker)

all: build

check.env:
ifndef DOCKER_BIN
   $(error The docker command is not found. Verify that Docker is installed and accessible)
endif

alpine: 
	@echo " "
	@echo " "
	@echo "Building 'base/alpine' image..."
	@echo " "
	$(DOCKER_BIN) build -t $(NAME)/base:alpine $(CURRENT_DIR)/base/alpine

ubuntu: 
	@echo " "
	@echo " "
	@echo "Building 'base/ubuntu' image..."
	@echo " "
	$(DOCKER_BIN) build -t $(NAME)/base:ubuntu $(CURRENT_DIR)/base/ubuntu

debian: 
	@echo " "
	@echo " "
	@echo "Building 'base/debian' image..."
	@echo " "
	$(DOCKER_BIN) build -t $(NAME)/base:debian $(CURRENT_DIR)/base/debian

centos: 
	@echo " "
	@echo " "
	@echo "Building 'base/centos' image..."
	@echo " "
	$(DOCKER_BIN) build -t $(NAME)/base:centos $(CURRENT_DIR)/base/centos

base: alpine ubuntu debian centos

build: base


tag_latest:
		docker tag -f $(NAME)/ubuntu-base:$(VERSION) $(NAME)/ubuntu-base:latest
		docker tag -f $(NAME)/ubuntu-python:$(VERSION) $(NAME)/ubuntu-python:latest
		docker tag -f $(NAME)/ubuntu-python-dev:$(VERSION) $(NAME)/ubuntu-python-dev:latest
		docker tag -f $(NAME)/ubuntu-python-falcon:$(VERSION) $(NAME)/ubuntu-python-falcon:latest
		docker tag -f $(NAME)/ubuntu-golang:$(VERSION) $(NAME)/ubuntu-golang:latest
		docker tag -f $(NAME)/ubuntu-perl:$(VERSION) $(NAME)/ubuntu-perl:latest
		docker tag -f $(NAME)/ubuntu-perl-dev:$(VERSION) $(NAME)/ubuntu-perl-dev:latest
		docker tag -f $(NAME)/ubuntu-perl-mojo:$(VERSION) $(NAME)/ubuntu-perl-mojo:latest
		docker tag -f $(NAME)/json:$(VERSION) $(NAME)/json:latest
		docker tag -f $(NAME)/ansible:$(VERSION) $(NAME)/ansible:latest
		docker tag -f $(NAME)/swagger-ui:$(VERSION) $(NAME)/swagger-ui:latest
		docker tag -f $(NAME)/swagger-editor:$(VERSION) $(NAME)/swagger-editor:latest

release: tag_latest
		@if ! docker images $(NAME)/ubuntu-base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/ubuntu-base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/ubuntu-python | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/ubuntu-python version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/ubuntu-python-dev | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/ubuntu-python-dev version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/ubuntu-python-falcon | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/ubuntu-python-falcon version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/ubuntu-golang | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/ubuntu-golang version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/ubuntu-perl | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/ubuntu-perl version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/ubuntu-perl-dev | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/ubuntu-perl-dev version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/ubuntu-perl-mojo | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/ubuntu-perl-mojo version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/json | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/json $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/ansible | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/ansible $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/swagger-ui | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/swagger-ui $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/swagger-editor | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/swagger-editor $(VERSION) is not yet built. Please run 'make build'"; false; fi
# Right now, these images are "trusted builds" on hub.docker.com.  So you can not perform a docker push"
#		docker push $(NAME)/ubuntu-base
#		docker push $(NAME)/ubuntu-python
#		docker push $(NAME)/ubuntu-python-dev
#		docker push $(NAME)/ubuntu-python-falcon
#		docker push $(NAME)/ubuntu-golang
#		docker push $(NAME)/ubuntu-perl
#		docker push $(NAME)/ubuntu-perl-dev
#		docker push $(NAME)/ubuntu-perl-mojo
#		docker push $(NAME)/json
		@echo "*** Don't forget to create a tag. git tag -d rel-$(VERSION); git push origin :refs/tags/rel-$(VERSION); git tag rel-$(VERSION) && git push origin rel-$(VERSION)"

release_base: 
		@if ! docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F alpine; then echo "$(NAME)/base:alpine is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F ubuntu; then echo "$(NAME)/base:ubuntu is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F debian; then echo "$(NAME)/base:debian is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/base | awk '{ print $$2 }' | grep -q -F centos; then echo "$(NAME)/base:centos is not yet built. Please run 'make build'"; false; fi
		docker push $(NAME)/base


tag_gh:
		git tag -d rel-$(VERSION); git push origin :refs/tags/rel-$(VERSION); git tag rel-$(VERSION) && git push origin rel-$(VERSION)
		
clean: clean_untagged
		rm -rf ubuntu_base_image
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

clean_untagged:
		for i in `docker ps --no-trunc -a -q`;do docker rm $$i;done
		docker images --no-trunc | grep none | awk '{print $$3}' | xargs -r docker rmi
