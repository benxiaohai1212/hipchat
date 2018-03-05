FROM ubuntu:xenial
MAINTAINER Andrey Arapov <andrey.arapov@nixaid.com>

# To avoid problems with Dialog and curses wizards
ENV DEBIAN_FRONTEND noninteractive

ADD https://atlassian.artifactoryonline.com/atlassian/api/gpg/key/public /tmp/public

RUN apt-get update && \
    apt-get -y --no-install-recommends install ca-certificates apt-transport-https && \
    cat /tmp/public | apt-key add - && \
    echo "deb https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client xenial main" > /etc/apt/sources.list.d/atlassian-hipchat4.list && \
    apt-get update && \
    apt-get -y --no-install-recommends install hipchat4 libqt5gui5 && \
    apt-get -fy --no-install-recommends install && \
    rm -rf -- /var/lib/apt/lists/*

RUN useradd -u 1000 -m -d /home/user -s /usr/sbin/nologin -g video user

WORKDIR /home/user
VOLUME [ "/tmp" ]
USER user
ENTRYPOINT [ "/usr/local/bin/hipchat4" ]
