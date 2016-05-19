FROM ubuntu:trusty
MAINTAINER Andrey Arapov <andrey.arapov@nixaid.com>

# To avoid problems with Dialog and curses wizards
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -yq apt-transport-https wget paxctl \
    && wget -O - https://atlassian.artifactoryonline.com/atlassian/api/gpg/key/public | apt-key add - \
    && echo "deb https://atlassian.artifactoryonline.com/atlassian/hipchat-apt-client $(lsb_release -c -s) main" > /etc/apt/sources.list.d/atlassian-hipchat4.list \
    && apt-get update \
    && apt-get install -yq hipchat4 libqt5gui5 \
    && apt-get -fyq install \
    && rm -rf -- /var/lib/apt/lists/*

# Make HipChat grsec friendly
#
# (runtime only, since xattrs are not preserved in Docker's final image)
# m: Disable MPROTECT // grsec: denied RWX mmap of <anonymous mapping>
# RUN setfattr -n user.pax.flags -v "m" /opt/HipChat4/lib/HipChat.bin /opt/HipChat4/lib/QtWebEngineProcess.bin
#
# (permanent change, by converting the binary headers PT_GNU_STACK into PT_PAX_FLAGS)
# m: Disable MPROTECT // grsec: denied RWX mmap of <anonymous mapping>
RUN paxctl -c -v -m /opt/HipChat4/lib/HipChat.bin /opt/HipChat4/lib/QtWebEngineProcess.bin


ENV USER user
ENV UID 1000
ENV GROUPS video
ENV HOME /home/$USER
RUN useradd -u $UID -m -d $HOME -s /usr/sbin/nologin -g $GROUPS $USER

WORKDIR $HOME
USER user
VOLUME [ "/tmp" ]
ENTRYPOINT [ "/usr/local/bin/hipchat4" ]
