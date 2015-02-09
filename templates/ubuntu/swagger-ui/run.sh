#!/bin/sh

# vim: filetype=sh:tabstop=2:shiftwidth=2:expandtab

readonly PROGNAME=$(basename $0)
readonly PROJECTDIR="$( cd "$(dirname "$0")" ; pwd -P )"
readonly PROJECT=$(basename $PROJECTDIR)

readonly NGINX_CMD=$(which nginx)
readonly SWAGGER_DATA_DIR="/swagger-data"
readonly SWAGGER_SPEC_FILE="swagger.json"

readonly WHOAMI=$(whoami)

prereq()
{

  if [ -z "$NGINX_CMD" ]; then
  	echo "The nginx runtime does not appear to be installed. Please install and re-run this script."
  	exit 1
  fi
}

run()
{
  sed -i 's/###-->ZZZ_IMAGE<--###/$(NAME)\/ubuntu-base/g' ubuntu_base_image/Dockerfile
  if [ -d "/home/docker" ]; then
    cd $PROJECTDIR; cd .. 
    $DOCKER_CMD run -v ${PWD}:/var/shared/projects:rw -it $IMAGE_NAME /bin/bash
  else
    $DOCKER_CMD run -v ${PWD}:/var/shared/projects:rw -it $IMAGE_NAME /bin/bash
  fi
}

clean()
{
  echo ""
  echo "Removing any intermediate, crusty Docker images"
  for i in `$DOCKER_CMD ps --no-trunc -a -q`; do $DOCKER_CMD rm $i;done
  $DOCKER_CMD images --no-trunc | grep none | awk '{print $3}' | xargs -r $DOCKER_CMD rmi
}

main()
{
  prereq
  run 
  clean
}

main
