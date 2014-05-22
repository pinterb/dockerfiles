NAME = pinterb/phusion
VERSION = 0.0.2

.PHONY: all build_all tag_latest release clean \
				build_base test_base

all: build_all

build_all: build_base build_python

test_base:
		base/test/verify.sh --force ; /usr/bin/test "$$?" -eq 0

build_base: test_base
		rm -rf base_image
		cp -pR base base_image
		docker build -t $(NAME)-base:$(VERSION) --rm base_image

test_python:
		python/test/verify.sh --force ; /usr/bin/test "$$?" -eq 0

build_python: test_python
		rm -rf python_image
		cp -pR python python_image
		docker build -t $(NAME)-python:$(VERSION) --rm python_image

tag_latest:
		docker tag $(NAME)-base:$(VERSION) $(NAME)-base:latest
		docker tag $(NAME)-python:$(VERSION) $(NAME)-python:latest

release: tag_latest
		@if ! docker images $(NAME)-base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		@if ! docker images $(NAME)-python | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-python version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		docker push $(NAME)-base
		docker push $(NAME)-python
		@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"

clean:
		rm -rf base_image
		rm -rf python_image
