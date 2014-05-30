#!/bin/bash

# vim: filetype=sh:tabstop=2:shiftwidth=2:expandtab

readonly IMAGE_BASE_NAME="ansible"
readonly IMAGE_REPO_NAME="pinterb/phusion"

readonly PROGNAME=$(basename $0)
readonly PROGDIR="$( cd "$(dirname "$0")" ; pwd -P )"

# Get to where we need to be.
cd $PROGDIR

# Globals overridden as command line arguments
DOCKER_IMAGE="$IMAGE_REPO_NAME-$IMAGE_BASE_NAME-sspectest"
KEEP_TEST_IMAGE=1
FORCE_REBUILD=1


usage()
{
  echo -e "\033[33mHere's how to verify this container:"
  echo ""
  echo -e "\033[33m./verify.sh"
  echo -e "\t\033[33m-h --help"
  echo -e "\t\033[33m--image=$DOCKER_IMAGE (i.e. docker image name or id)"
  echo -e "\t\033[33m--keep (i.e. retain image after test execution)"
  echo -e "\t\033[33m--force (i.e. force building of image)"
  echo -e "\033[0m"
}


parse_args()
{
  while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    VALUE=`echo $1 | awk -F= '{print $2}'`
    case $PARAM in
      -h | --help)
        usage
        exit
        ;;
      --image)
        DOCKER_IMAGE=$VALUE
        ;;
      --keep)
        KEEP_TEST_IMAGE=0
        ;;
      --force)
        FORCE_REBUILD=0
        ;;
      *)
        echo -e "\033[31mERROR: unknown parameter \"$PARAM\""
        echo -e "\e[0m"
        usage
        exit 1
        ;;
    esac
    shift
  done
}


build()
{
	# Check if Docker image already exists
	image_exists_flg=`docker images $DOCKER_IMAGE | awk '{ print $1 }' | grep -q -F $DOCKER_IMAGE`

	# Is an Docker image build is required?
	if [ "$?" = "0" ]; then
		echo ""
		echo ""
		echo "Docker test image '$DOCKER_IMAGE' already exists"
		if [ "$FORCE_REBUILD" = "0" ]; then
			echo ""
			echo ""
			echo "...Force rebuild option was selected"
			docker rmi $DOCKER_IMAGE
			echo ""
			echo ""
			echo "......Building $DOCKER_IMAGE..."
			echo ""
			docker build --rm -t $DOCKER_IMAGE ..
		else
			echo "...Will test against existing image"
		fi
	else
		# Build Docker image
		echo ""
		echo ""
		echo "Building $DOCKER_IMAGE..."
		echo ""
		docker build --rm -t $DOCKER_IMAGE ..
	fi
}


cleanup()
{
	# Destroy Vagrant instance
	echo ""
	echo ""
	echo "Destroying Vagrant instance..."
	echo ""
	vagrant destroy --force

	# Delete Docker image (if requested)
	if [[ "$KEEP_TEST_IMAGE" = 1 ]]; then
		echo ""
		echo "Removing $DOCKER_IMAGE..."
		echo ""
		docker rmi $DOCKER_IMAGE
	fi
}


main()
{
	# Build docker image
	build

	echo ""
	echo ""
	echo "Verify '$DOCKER_IMAGE' image using Vagrant w/Serverspec..."
	echo ""
  export VAGRANT_SERVERSPEC_DOCKER_TEST_IMAGE=$DOCKER_IMAGE
	vagrant_results=$(vagrant up --provider docker)
	feh=`echo $vagrant_results | grep -F "examples, 0 failures"`
	verify_result=$?
	echo $vagrant_results

	# cleanup
	cleanup

	# Display results
	if [ "$verify_result" = "1" ]; then
		echo ""
		echo ""
		echo -e "\033[31m'$DOCKER_IMAGE' verification failed."
    echo -e "\033[0m"
		exit 1
	fi

	echo ""
	echo ""
	echo "All tests passed."
	echo -e "\033[32m'$DOCKER_IMAGE' verification succeeded!"
  echo -e "\033[0m"
	exit 0
}


parse_args "$@"
main
