NAME = pinterb/phusion
VERSION = 0.0.2

.PHONY: all build_all tag_latest release clean \
				build_base

all: build_all

build_all: build_base

build_base:
		rm -rf base_image
		cp -pR base base_image
		docker build -t $(NAME)-base:$(VERSION) --rm base_image

tag_latest:
		docker tag $(NAME)-base:$(VERSION) $(NAME)-base:latest

release: tag_latest
		@if ! docker images $(NAME)-base | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME)-base version $(VERSION) is not yet built. Please run 'make build'"; false; fi
		docker push $(NAME)-base
		@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"

clean:
		rm -rf base_image
