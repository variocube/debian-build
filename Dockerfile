#
# Dockerfile for an image that containing build tools for Debian packages using nodejs.
#
ARG RELEASE
FROM debian:${RELEASE}-slim
ARG RELEASE
ARG NODE

# Add backports to stretch to give it high priority
RUN if [ "$RELEASE" = "stretch" ]; then \
      echo "deb http://ftp.debian.org/debian stretch-backports main" >> /etc/apt/sources.list; \
      echo "Package: *\nPin: release a=stretch-backports\nPin-Priority: 500" >> /etc/apt/preferences; \
    fi

# Install node and build tools
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates
RUN curl -fsSL https://deb.nodesource.com/setup_$NODE.x | bash -
RUN apt-get update \
    && apt-get install -y --no-install-recommends nodejs devscripts build-essential debhelper

# Install python2.7 on stretch
RUN if [ "$RELEASE" = "stretch" ]; then \
      apt-get install -y --no-install-recommends python2.7; \
    fi

RUN apt-get clean && rm -rf /var/lib/apt/lists/*
