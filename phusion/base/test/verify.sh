#!/bin/bash

IMAGE_REPO_NAME="pinterb/phusion"
IMAGE_BASE_NAME="base"

DOCKER_IMAGE="$IMAGE_REPO_NAME-$IMAGE_BASE_NAME-sspectest"
KEEP_TEST_IMAGE=1
FORCE_REBUILD=1

## Clunky retrieval of absolute path
SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd $SCRIPT_PATH

function usage()
{
	echo "if this was a real script you would see something useful here"
	echo ""
	echo "./verify.sh"
	echo "    -h --help"
	echo "    --image=$DOCKER_IMAGE (i.e. docker image name or id)"
	echo "    --keep (i.e. retain image after test execution)"
	echo "    --force (i.e. force building of image)"
	echo ""
}

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
			echo "ERROR: unknown parameter \"$PARAM\""
			usage
			exit 1
			;;
	esac
	shift
done


### Check if Docker image already exists
IMAGE_EXISTS_FLG=`docker images $DOCKER_IMAGE | awk '{ print $1 }' | grep -q -F $DOCKER_IMAGE`

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
	### Build Docker image
	echo ""
	echo ""
	echo "Building $DOCKER_IMAGE..."
	echo ""
	docker build --rm -t $DOCKER_IMAGE ..
fi


### Verify Docker image
echo ""
echo ""
echo "Verify image using Vagrant w/Serverspec..."
echo ""
export VAGRANT_SERVERSPEC_DOCKER_TEST_IMAGE=$DOCKER_IMAGE
TEST_RESULTS=$(vagrant up --provider docker)
echo $TEST_RESULTS

TEST_FLAG=`echo $TEST_RESULTS | grep -F "examples, 0 failures"`
TEST_RTN_CODE=$?


### Destroy Vagrant instance
echo ""
echo ""
echo "Destroying Vagrant instance..."
echo ""
vagrant destroy --force


### Delete Docker image (if requested)
if [[ "$KEEP_TEST_IMAGE" = 1 ]]; then
	echo ""
	echo "Removing $DOCKER_IMAGE..."
	echo ""
	docker rmi $DOCKER_IMAGE
fi


### Display results
if [ "$TEST_RTN_CODE" = "1" ]; then
	echo ""
	echo ""
	echo "'$DOCKER_IMAGE' verification failed."
	echo ""
	exit 1
fi

echo ""
echo ""
echo "All tests passed."
echo "'$DOCKER_IMAGE' verification succeeded!"
echo ""
exit 0
