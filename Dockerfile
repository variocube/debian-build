#
# Dockerfile for an image that containing build tools for Debian packages using nodejs.
#

FROM debian:bullseye-slim

RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get update
RUN apt-get install -y --no-install-recommends nodejs devscripts build-essential debhelper-compat npm
