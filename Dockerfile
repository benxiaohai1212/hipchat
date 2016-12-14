FROM ubuntu:xenial
MAINTAINER Andrey Arapov <andrey.arapov@nixaid.com>

# To avoid problems with Dialog and curses wizards
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
    apt-get -y --no-install-recommends install ca-certificates apt-transport-https wget attr lsb-release && \
    wget -O - https://atlassian.artifactoryonline.com/atlassian/api/gpg/key/public | apt-key add - && \
    echo "deb https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client $(lsb_release -c -s) main" > /etc/apt/sources.list.d/atlassian-hipchat4.list && \
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

ENV USER user
ENV UID 1000
ENV GROUPS video
ENV HOME /home/$USER
RUN useradd -u $UID -m -d $HOME -s /usr/sbin/nologin -g $GROUPS $USER

COPY launch /launch

WORKDIR $HOME
VOLUME [ "/tmp" ]
ENTRYPOINT [ "sh", "/launch" ]
