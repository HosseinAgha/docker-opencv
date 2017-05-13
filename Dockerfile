FROM ubuntu:xenial

# RUN localedef -i en_US -f UTF-8 en_US.UTF-8

RUN apt-get -y update && apt-get -y upgrade && \
    apt-get -y install linuxbrew-wrapper && \
    apt-get install -y curl g++ gawk git m4 make patch ruby tcl && \
    apt-get install -y locales && \
    apt-get install -y build-essential python-setuptools

RUN apt-get clean
RUN apt-get autoremove

# Set the locale
RUN locale-gen en_US.UTF-8  

RUN useradd -m -s /bin/bash ubuntu
RUN echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER ubuntu

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

# install brew for real!
RUN brew update -v || brew update -v

ENV PATH /home/ubuntu/.linuxbrew/bin:${PATH}
ENV MANPATH /home/ubuntu/.linuxbrew/share/man:${MANPATH}
ENV INFOPATH /home/ubuntu/.linuxbrew/share/info:${INFOPATH}

RUN brew install homebrew/science/opencv3 --only-dependencies

RUN brew doctor || true

RUN brew install homebrew/science/opencv3

# setup opencv env
# opencv3 package-config
ENV PKG_CONFIG_PATH="/home/ubuntu/.linuxbrew/opt/opencv3/lib/pkgconfig:$PKG_CONFIG_PATH" \
    # dont use opencv3 (linux brew puts opencv3 in opencv package-config)
    PKG_CONFIG_OPENCV3="0" \
    # add opencv3 static libraries path
    LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/ubuntu/.linuxbrew/opt/opencv3/lib"

WORKDIR /home/ubuntu

USER root
