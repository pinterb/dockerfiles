NAME = pinterb/phusion
VERSION = 0.0.2

.PHONY: all build_all tag_latest release clean clean_untagged \
				build_base test_base \
				build_python test_python \
				build_ansible test_ansible \
				build_jvm test_jvm

all: build_all

build_all: build_base build_python build_ansible build_jvm

test_base:
		base/test/verify.sh --force ; /usr/bin/test "$$?" -eq 0

build_base: test_base
		rm -rf base_image
		cp -pR base base_image
		docker build --rm -t $(NAME)-base:$(VERSION) base_image

test_python:
		python/test/verify.sh --force ; /usr/bin/test "$$?" -eq 0

build_python: test_python
		rm -rf python_image
		cp -pR python python_image
		docker build --rm -t $(NAME)-python:$(VERSION) python_image

test_ansible:
		ansible/test/verify.sh --force ; /usr/bin/test "$$?" -eq 0

build_ansible: test_ansible
		rm -rf ansible_image
		cp -pR ansible ansible_image
		docker build --rm -t $(NAME)-ansible:$(VERSION) ansible_image

test_jvm:
		jvm/test/verify.sh --force ; /usr/bin/test "$$?" -eq 0

build_jvm: test_jvm
		rm -rf jvm_image
		cp -pR jvm jvm_image
		docker build --rm -t $(NAME)-jvm:$(VERSION) jvm_image

tag_latest:
		docker tag $(NAME)-base:$(VERSION) $(NAME)-base:latest
		docker tag $(NAME)-python:$(VERSION) $(NAME)-python:latest
		docker tag $(NAME)-ansible:$(VERSION) $(NAME)-ansible:latest
		docker tag $(NAME)-jvm:$(VERSION) $(NAME)-jvm:latest

release: tag_latest
		@if ! docker images $(NAME)-base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)-python | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-python version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)-ansible | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-ansible version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)-jvm | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-jvm version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		docker push $(NAME)-base
		docker push $(NAME)-python
		docker push $(NAME)-ansible
		docker push $(NAME)-jvm
		@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"

clean: clean_untagged
		rm -rf base_image
		rm -rf python_image
		rm -rf ansible_image
		rm -rf jvm_image

clean_untagged:
		for i in `docker ps --no-trunc -a -q`;do docker rm $$i;done
		docker images --no-trunc | grep none | awk '{print $$3}' | xargs -r docker rmi
