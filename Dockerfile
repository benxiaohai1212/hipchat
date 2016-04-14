# FROM debian:jessie
FROM ubuntu:xenial
MAINTAINER Andrey Arapov <andrey.arapov@nixaid.com>

# To avoid problems with Dialog and curses wizards
ENV DEBIAN_FRONTEND noninteractive

RUN echo 'deb http://downloads.hipchat.com/linux/apt stable main' > /etc/apt/sources.list.d/atlassian-hipchat.list \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0xAAD4AA21729B5780 \
    && apt-get update \
    && apt-get install -yq hipchat libcanberra0 libltdl7 libqt5core5a \
        libqt5dbus5 libqt5gui5 libqt5network5 libqt5opengl5 libqt5qml5 \
        libqt5quick5 libqt5widgets5 libqt5xml5 libxcomposite1 \
    && rm -rf -- /var/lib/apt/lists/*

ENV USER user
ENV UID 1000
ENV GROUPS video
ENV HOME /home/$USER
RUN useradd -u $UID -m -d $HOME -s /usr/sbin/nologin -g $GROUPS $USER

WORKDIR $HOME
USER user
VOLUME [ "/tmp" ]
ENTRYPOINT [ "/usr/bin/hipchat" ]
