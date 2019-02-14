#!/bin/bash
TAG_SUFFIX=$1
IMAGE_LATEST=$DOCKER_REGISTRY:$1-latest
IMAGE_PIPELINE=$DOCKER_REGISTRY:$1-$CI_COMMIT_REF_SLUG.$CI_PIPELINE_ID
IMAGE_COMMIT_HASH=$DOCKER_REGISTRY:$1-$CI_COMMIT_SHA

docker build -t $IMAGE_LATEST -t $IMAGE_PIPELINE -t $IMAGE_COMMIT_HASH .
docker pull diginex/ca
docker run --rm -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION -e KOPS_CLUSTER_NAME=$KOPS_CLUSTER_NAME -e KOPS_STATE_STORE=$KOPS_STATE_STORE -e SUPPRESS_INFO=true diginex/ca aws ecr get-login --no-include-email | sh
docker push $IMAGE_LATEST
docker push $IMAGE_PIPELINE
docker push $IMAGE_COMMIT_HASH
