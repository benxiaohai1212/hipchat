FROM ubuntu:xenial
MAINTAINER Andrey Arapov <andrey.arapov@nixaid.com>

# To avoid problems with Dialog and curses wizards
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get -y --no-install-recommends install ca-certificates apt-transport-https wget attr && \
    wget -O - https://atlassian.artifactoryonline.com/atlassian/api/gpg/key/public | apt-key add - && \
    echo "deb https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client xenial main" > /etc/apt/sources.list.d/atlassian-hipchat4.list && \
    apt-get update && \
    apt-get -y --no-install-recommends install hipchat4 libqt5gui5 && \
    apt-get -fy --no-install-recommends install && \
    rm -rf -- /var/lib/apt/lists/*

# Make HipChat grsec friendly
#
# To build the Docker image, I currently had to disable the following grsec protections:
# # grep -E "chroot_deny_chmod|chroot_deny_mknod|chroot_caps" /etc/sysctl.d/grsec.conf
# kernel.grsecurity.chroot_deny_chmod = 0
# kernel.grsecurity.chroot_deny_mknod = 0
# kernel.grsecurity.chroot_caps = 0 (relates to a systemd package)

RUN useradd -u 1000 -m -d /home/user -s /usr/sbin/nologin -g video user

COPY launch /launch

WORKDIR /home/user
VOLUME [ "/tmp" ]
ENTRYPOINT [ "sh", "/launch" ]
