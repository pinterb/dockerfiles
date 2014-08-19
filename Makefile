VERSION = 0.0.9
NAME = pinterb
CREATE_DATE := $(shell date +%FT%T%Z)
PERL_VERSION = 5.20.0 

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
build_all: build_base build_python build_golang build_perl
build_base: build_phusion_base build_ubuntu_base

build_python: build_python_base build_python_dev build_python_falcon
build_python_base: build_phusion_python_base build_ubuntu_python_base
build_python_dev: build_phusion_python_dev build_ubuntu_python_dev
build_python_falcon: build_ubuntu_python_falcon

build_golang: build_golang_base
build_golang_base: build_ubuntu_golang_base

build_perl: build_perl_base build_perl_dev build_perl_mojo
build_perl_base: build_ubuntu_perl_base
build_perl_dev: build_ubuntu_perl_dev
build_perl_mojo: build_ubuntu_perl_mojo


## Base Images
prep_phusion_base:
		rm -rf phusion_base_image
		cp -pR templates/phusion/base phusion_base_image
		sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/phusion-base/g' phusion_base_image/Dockerfile
		sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' phusion_base_image/Dockerfile
		sed -i 's/###-->ZZZ_BASE_IMAGE<--###/phusion\/passenger-customizable:0.9.11/g' phusion_base_image/Dockerfile
		sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' phusion_base_image/Dockerfile

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
		sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' ubuntu_base_image/Dockerfile

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
		sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' phusion_python_base_image/Dockerfile

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
		sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' ubuntu_python_base_image/Dockerfile

build_ubuntu_python_base: prep_ubuntu_python_base
		docker build --rm -t $(NAME)/ubuntu-python:$(VERSION) ubuntu_python_base_image
		cp ubuntu_python_base_image/Dockerfile images/ubuntu/python/

prep_phusion_python_dev:
		rm -rf phusion_python_dev_image
		cp -pR templates/phusion/python-dev phusion_python_dev_image
		sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/phusion-python-dev/g' phusion_python_dev_image/Dockerfile
		sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' phusion_python_dev_image/Dockerfile
		sed -i 's/###-->ZZZ_BASE_IMAGE<--###/$(NAME)\/phusion-python:$(VERSION)/g' phusion_python_dev_image/Dockerfile
		sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' phusion_python_dev_image/Dockerfile

test_phusion_python_dev: prep_phusion_python_dev
		phusion_python_dev_image/tests/verify.sh --force --image=$(NAME)/phusion-python-dev-sspectest ; /usr/bin/test "$$?" -eq 0

build_phusion_python_dev: test_phusion_python_dev
		docker build --rm -t $(NAME)/phusion-python-dev:$(VERSION) phusion_python_dev_image
		cp phusion_python_dev_image/Dockerfile images/phusion/python-dev/

prep_ubuntu_python_dev:
		rm -rf ubuntu_python_dev_image
		cp -pR templates/ubuntu/python-dev ubuntu_python_dev_image
		sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/ubuntu-python-dev/g' ubuntu_python_dev_image/Dockerfile
		sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' ubuntu_python_dev_image/Dockerfile
		sed -i 's/###-->ZZZ_BASE_IMAGE<--###/$(NAME)\/ubuntu-python:$(VERSION)/g' ubuntu_python_dev_image/Dockerfile
		sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' ubuntu_python_dev_image/Dockerfile

build_ubuntu_python_dev: prep_ubuntu_python_dev
		docker build --rm -t $(NAME)/ubuntu-python-dev:$(VERSION) ubuntu_python_dev_image
		cp ubuntu_python_dev_image/Dockerfile images/ubuntu/python-dev/



prep_ubuntu_python_falcon:
		rm -rf ubuntu_python_falcon_image
		cp -pR templates/ubuntu/python-falcon ubuntu_python_falcon_image
		sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/ubuntu-python-falcon/g' ubuntu_python_falcon_image/Dockerfile
		sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' ubuntu_python_falcon_image/Dockerfile
		sed -i 's/###-->ZZZ_BASE_IMAGE<--###/$(NAME)\/ubuntu-python:$(VERSION)/g' ubuntu_python_falcon_image/Dockerfile
		sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' ubuntu_python_falcon_image/Dockerfile

build_ubuntu_python_falcon: prep_ubuntu_python_falcon
		docker build --rm -t $(NAME)/ubuntu-python-falcon:$(VERSION) ubuntu_python_falcon_image
		cp ubuntu_python_falcon_image/Dockerfile images/ubuntu/python-falcon/






## Golang Images
prep_ubuntu_golang_base:
		rm -rf ubuntu_golang_base_image
		cp -pR templates/ubuntu/golang ubuntu_golang_base_image
		sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/ubuntu-golang/g' ubuntu_golang_base_image/Dockerfile
		sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' ubuntu_golang_base_image/Dockerfile
		sed -i 's/###-->ZZZ_BASE_IMAGE<--###/$(NAME)\/ubuntu-base:$(VERSION)/g' ubuntu_golang_base_image/Dockerfile
		sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' ubuntu_golang_base_image/Dockerfile

build_ubuntu_golang_base: prep_ubuntu_golang_base
		docker build --rm -t $(NAME)/ubuntu-golang:$(VERSION) ubuntu_golang_base_image
		cp ubuntu_golang_base_image/Dockerfile images/ubuntu/golang/


## Perl Images
prep_ubuntu_perl_base:
		rm -rf ubuntu_perl_base_image
		cp -pR templates/ubuntu/perl ubuntu_perl_base_image
		sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/ubuntu-perl/g' ubuntu_perl_base_image/Dockerfile
		sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' ubuntu_perl_base_image/Dockerfile
		sed -i 's/###-->ZZZ_BASE_IMAGE<--###/$(NAME)\/ubuntu-base:$(VERSION)/g' ubuntu_perl_base_image/Dockerfile
		sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' ubuntu_perl_base_image/Dockerfile
		sed -i 's/###-->ZZZ_PERL_VERSION<--###/$(PERL_VERSION)/g' ubuntu_perl_base_image/Dockerfile

build_ubuntu_perl_base: prep_ubuntu_perl_base
		docker build --rm -t $(NAME)/ubuntu-perl:$(VERSION) ubuntu_perl_base_image
		cp ubuntu_perl_base_image/Dockerfile images/ubuntu/perl/

prep_ubuntu_perl_dev:
		rm -rf ubuntu_perl_dev_image
		cp -pR templates/ubuntu/perl-dev ubuntu_perl_dev_image
		sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/ubuntu-perl-dev/g' ubuntu_perl_dev_image/Dockerfile
		sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' ubuntu_perl_dev_image/Dockerfile
		sed -i 's/###-->ZZZ_BASE_IMAGE<--###/$(NAME)\/ubuntu-perl:$(VERSION)/g' ubuntu_perl_dev_image/Dockerfile
		sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' ubuntu_perl_dev_image/Dockerfile

build_ubuntu_perl_dev: prep_ubuntu_perl_dev
		docker build --rm -t $(NAME)/ubuntu-perl-dev:$(VERSION) ubuntu_perl_dev_image
		cp ubuntu_perl_dev_image/Dockerfile images/ubuntu/perl-dev/

prep_ubuntu_perl_mojo:
		rm -rf ubuntu_perl_mojo_image
		cp -pR templates/ubuntu/perl-mojo ubuntu_perl_mojo_image
		sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/ubuntu-perl-mojo/g' ubuntu_perl_mojo_image/Dockerfile
		sed -i 's/###-->ZZZ_VERSION<--###/$(VERSION)/g' ubuntu_perl_mojo_image/Dockerfile
		sed -i 's/###-->ZZZ_BASE_IMAGE<--###/$(NAME)\/ubuntu-perl:$(VERSION)/g' ubuntu_perl_mojo_image/Dockerfile
		sed -i 's/###-->ZZZ_DATE<--###/$(CREATE_DATE)/g' ubuntu_perl_mojo_image/Dockerfile

build_ubuntu_perl_mojo: prep_ubuntu_perl_mojo
		docker build --rm -t $(NAME)/ubuntu-perl-mojo:$(VERSION) ubuntu_perl_mojo_image
		cp ubuntu_perl_mojo_image/Dockerfile images/ubuntu/perl-mojo/






tag_latest:
		docker tag $(NAME)/phusion-base:$(VERSION) $(NAME)/phusion-base:latest
		docker tag $(NAME)/ubuntu-base:$(VERSION) $(NAME)/ubuntu-base:latest
		docker tag $(NAME)/phusion-python:$(VERSION) $(NAME)/phusion-python:latest
		docker tag $(NAME)/ubuntu-python:$(VERSION) $(NAME)/ubuntu-python:latest
		docker tag $(NAME)/phusion-python-dev:$(VERSION) $(NAME)/phusion-python-dev:latest
		docker tag $(NAME)/ubuntu-python-dev:$(VERSION) $(NAME)/ubuntu-python-dev:latest
		docker tag $(NAME)/ubuntu-python-falcon:$(VERSION) $(NAME)/ubuntu-python-falcon:latest
		docker tag $(NAME)/ubuntu-golang:$(VERSION) $(NAME)/ubuntu-golang:latest
		docker tag $(NAME)/ubuntu-perl:$(VERSION) $(NAME)/ubuntu-perl:latest
		docker tag $(NAME)/ubuntu-perl-dev:$(VERSION) $(NAME)/ubuntu-perl-dev:latest
		docker tag $(NAME)/ubuntu-perl-mojo:$(VERSION) $(NAME)/ubuntu-perl-mojo:latest

release: tag_latest
		@if ! docker images $(NAME)/phusion-base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/phusion-base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/ubuntu-base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/ubuntu-base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/phusion-python | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/phusion-python version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/ubuntu-python | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/ubuntu-python version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/phusion-python-dev | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/phusion-python-dev version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/ubuntu-python-dev | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/ubuntu-python-dev version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/ubuntu-python-falcon | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/ubuntu-python-falcon version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/ubuntu-golang | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/ubuntu-golang version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/ubuntu-perl | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/ubuntu-perl version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/ubuntu-perl-dev | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/ubuntu-perl-dev version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)/ubuntu-perl-mojo | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)/ubuntu-perl-mojo version $(VERSION) is not yet built. Please run 'make build'"; false; fi
# Right now, these images are "trusted builds" on hub.docker.com.  So you can not perform a docker push"
#		docker push $(NAME)/phusion-base
#		docker push $(NAME)/ubuntu-base
#		docker push $(NAME)/phusion-python
#		docker push $(NAME)/ubuntu-python
#		docker push $(NAME)/phusion-python-dev
#		docker push $(NAME)/ubuntu-python-dev
#		docker push $(NAME)/ubuntu-python-falcon
#		docker push $(NAME)/ubuntu-golang
#		docker push $(NAME)/ubuntu-perl
#		docker push $(NAME)/ubuntu-perl-dev
#		docker push $(NAME)/ubuntu-perl-mojo
		@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"

clean: clean_untagged
		rm -rf phusion_base_image
		rm -rf ubuntu_base_image
		rm -rf phusion_python_base_image
		rm -rf ubuntu_python_base_image
		rm -rf phusion_python_dev_image
		rm -rf ubuntu_python_dev_image
		rm -rf ubuntu_python_falcon_image
		rm -rf ubuntu_golang_base_image
		rm -rf ubuntu_perl_base_image
		rm -rf ubuntu_perl_dev_image
		rm -rf ubuntu_perl_mojo_image

clean_untagged:
		for i in `docker ps --no-trunc -a -q`;do docker rm $$i;done
		docker images --no-trunc | grep none | awk '{print $$3}' | xargs -r docker rmi
