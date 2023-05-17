#!/usr/bin/env bash
#
# Builds a multi-platform docker image that is suitable for building Debian packages and pushes it to Variocube's
# AWS ECR repository.
#
# There is no automated build setup for this, since this image will only change very rarely.
#
# This script requires the `buildx` docker plugin, see https://docs.docker.com/build/install-buildx/
#
# This script assumes that you are already logged in into the AWS ECR public through docker.
# Typically, this is done with a command like:
# aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/variocube

set -e
set -x

docker buildx create --name debian-build-builder || true   # Ignore error when builder exists
docker buildx use debian-build-builder

# stretch-based image with Node 14
docker buildx build \
  --build-arg RELEASE=stretch \
  --build-arg NODE=14 \
  --platform linux/arm,linux/amd64 \
  -t public.ecr.aws/variocube/debian-build:stretch \
  --push .

# bullseye-based image with Node 18
docker buildx build \
  --build-arg RELEASE=bullseye \
  --build-arg NODE=18 \
  --platform linux/arm,linux/amd64,linux/arm64 \
  -t public.ecr.aws/variocube/debian-build:bullseye \
  --push .

# latest image is currently bullseye
docker buildx build \
  --build-arg RELEASE=bullseye \
  --build-arg NODE=18 \
  --platform linux/arm,linux/amd64,linux/arm64 \
  -t public.ecr.aws/variocube/debian-build:latest \
  --push .

