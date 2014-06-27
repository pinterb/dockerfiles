VERSION = 0.0.1
NAME = pinterb

.PHONY: all build_all tag_latest release clean clean_untagged \
				prep_phusion_base test_phusion_base build_phusion_base \
				prep_ubuntu_base test_ubuntu_base build_ubuntu_base \
				prep_phusion_golang test_phusion_golang build_phusion_golang \
				prep_ubuntu_golang test_ubuntu_golang build_ubuntu_golang \
				build_python test_python \
				build_ansible test_ansible \
				build_jvm test_jvm \
				build_graven test_graven \
				build_golang test_golang

all: build_all
build_all: build_base
build_base: build_phusion_base build_ubuntu_base

build_python: build_python_base
build_python_base: build_phusion_python_base build_ubuntu_python_base


## Base Images
prep_phusion_base:
		rm -rf phusion_base_image
		cp -pR templates/phusion/base phusion_base_image
		sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/phusion-base/g' phusion_base_image/Dockerfile
		sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' phusion_base_image/Dockerfile
		sed -i 's/###-->ZZZ_BASE_IMAGE<--###/phusion\/passenger-customizable:0.9.11/g' phusion_base_image/Dockerfile

test_phusion_base: prep_phusion_base
		phusion_base_image/tests/verify.sh --force --image=$(NAME)/phusion-base-sspectest ; /usr/bin/test "$$?" -eq 0

build_phusion_base: test_phusion_base
		docker build --rm -t $(NAME)/phusion-base:$(VERSION) phusion_base_image
		cp phusion_base_image/Dockerfile images/phusion/base/

prep_ubuntu_base:
		rm -rf ubuntu_base_image
		cp -pR templates/ubuntu/base ubuntu_base_image
		sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/ubuntu-base/g' ubuntu_base_image/Dockerfile
		sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' ubuntu_base_image/Dockerfile
		sed -i 's/###-->ZZZ_BASE_IMAGE<--###/ubuntu:14.04/g' ubuntu_base_image/Dockerfile

build_ubuntu_base: prep_ubuntu_base
		docker build --rm -t $(NAME)/ubuntu-base:$(VERSION) ubuntu_base_image
		cp ubuntu_base_image/Dockerfile images/ubuntu/base/


## Python Images
prep_phusion_python_base:
		rm -rf phusion_python_base_image
		cp -pR templates/phusion/python phusion_python_base_image
		sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/phusion-python/g' phusion_python_base_image/Dockerfile
		sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' phusion_python_base_image/Dockerfile
		sed -i 's/###-->ZZZ_BASE_IMAGE<--###/$(NAME)\/phusion-base:$(VERSION)/g' phusion_python_base_image/Dockerfile

test_phusion_python_base: prep_phusion_python_base
		phusion_python_base_image/tests/verify.sh --force --image=$(NAME)/phusion-python-sspectest ; /usr/bin/test "$$?" -eq 0

build_phusion_python_base: test_phusion_python_base
		docker build --rm -t $(NAME)/phusion-python:$(VERSION) phusion_python_base_image
		cp phusion_python_base_image/Dockerfile images/phusion/python/

prep_ubuntu_python_base:
		rm -rf ubuntu_python_base_image
		cp -pR templates/ubuntu/python ubuntu_python_base_image
		sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/ubuntu-python/g' ubuntu_python_base_image/Dockerfile
		sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' ubuntu_python_base_image/Dockerfile
		sed -i 's/###-->ZZZ_BASE_IMAGE<--###/$(NAME)\/ubuntu-base:$(VERSION)/g' ubuntu_python_base_image/Dockerfile

build_ubuntu_python_base: prep_ubuntu_python_base
		docker build --rm -t $(NAME)/ubuntu-python:$(VERSION) ubuntu_python_base_image
		cp ubuntu_python_base_image/Dockerfile images/ubuntu/python/





tag_latest:
		docker tag $(NAME)/phusion-base:$(VERSION) $(NAME)/phusion-base:latest
		docker tag $(NAME)/ubuntu-base:$(VERSION) $(NAME)/ubuntu-base:latest
		docker tag $(NAME)/phusion-python:$(VERSION) $(NAME)/phusion-python:latest
		docker tag $(NAME)/ubuntu-python:$(VERSION) $(NAME)/ubuntu-python:latest

release: tag_latest
		@if ! docker images $(NAME)/phusion-base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/phusion-base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/ubuntu-base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/ubuntu-base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/phusion-python | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/phusion-python version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/ubuntu-python | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/ubuntu-python version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		docker push $(NAME)/phusion-base
		docker push $(NAME)/ubuntu-base
		docker push $(NAME)/phusion-python
		docker push $(NAME)/ubuntu-python
		@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"

clean: clean_untagged
		rm -rf phusion_base_image
		rm -rf ubuntu_base_image
		rm -rf phusion_python_base_image
		rm -rf ubuntu_python_base_image

clean_untagged:
		for i in `docker ps --no-trunc -a -q`;do docker rm $$i;done
		docker images --no-trunc | grep none | awk '{print $$3}' | xargs -r docker rmi
