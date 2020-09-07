FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && \
    apt-get -y upgrade && \
    # python-setuptools is required for linuxbrew python installation
    apt-get install -y build-essential python-setuptools curl gawk git m4 patch ruby tcl

# linuxbrew dependencies and final cleanup
RUN apt-get install -y locales && \
    apt-get clean && apt-get autoremove -y

# Set the locale for linuxbrew
RUN locale-gen en_US.UTF-8

# It's safe to use linuxbrew in a non-root environment
# create a user called ubunutu
RUN useradd -m -s /bin/bash ubuntu
# make it sudoer
RUN echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# switch to ubuntu user
USER ubuntu

# sets system language variables in a single layer (for linuxbrew again!)
ENV LANG="en_US.UTF-8" LANGUAGE="en_US:en" LC_ALL="en_US.UTF-8"

# this is only a wrapper for linuxbrew and does not download the whole thing
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

# sets brew's PATHs
ENV PATH="/home/ubuntu/.linuxbrew/bin:${PATH}" \
    MANPATH="/home/ubuntu/.linuxbrew/share/man:${MANPATH}" \
    INFOPATH="/home/ubuntu/.linuxbrew/share/info:${INFOPATH}"

# update linux brew repos
RUN brew update --verbose

# # check if brew is healthy and fine!
# RUN brew doctor

# finally install opencv3
RUN brew install opencv@3

# setup opencv envs and linuxbrew opencv3 package-config PATH
ENV PKG_CONFIG_PATH="/home/ubuntu/.linuxbrew/opt/opencv3/lib/pkgconfig:$PKG_CONFIG_PATH" \
    # dont use opencv3 (linux brew puts opencv3 in opencv package-config)
    PKG_CONFIG_OPENCV3="0" \
    # add opencv3 libraries path
    LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/ubuntu/.linuxbrew/opt/opencv3/lib"

USER root

WORKDIR /root/
