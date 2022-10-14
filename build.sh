#!/usr/bin/env bash
#
# Builds a multi-platform docker image that is suitable for building Debian packages and pushes it to Variocube's
# AWS ECR repository.
#
# There is no automated build setup for this, since this image will only change very rarely.
#

# You might need to adapt the login for your setup.
# For this to work a profile named "AdministratorAccess-Variocube" must be present in ~/.aws/config
# See https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html
# Also, you might need to login to this profile first:
#   aws sso login --profile AdministratorAccess-Variocube
aws ecr-public get-login-password --region us-east-1 --profile AdministratorAccess-Variocube | docker login --username AWS --password-stdin public.ecr.aws/variocube

# You might need to install Dockers buildx extension on your system.
docker buildx create --name debian-build-builder
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
  --platform linux/arm,linux/amd64 \
  -t public.ecr.aws/variocube/debian-build:bullseye \
  --push .

# latest image is currently bullseye
docker buildx build \
  --build-arg RELEASE=bullseye \
  --build-arg NODE=18 \
  --platform linux/arm,linux/amd64 \
  -t public.ecr.aws/variocube/debian-build:latest \
  --push .

