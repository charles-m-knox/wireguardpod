# https://git.sr.ht/~arx10/procustodibus-agent/tree/main/item/docker/wireguard.dockerfile
FROM docker.io/library/alpine:3.20

RUN apk update
RUN apk add --no-cache \
    openrc \
    iptables \
    nftables \
    wireguard-tools \
    curl nano

RUN mkdir -p /etc/init.d
COPY wg-quick /etc/init.d/wg-quick
RUN chmod +x /etc/init.d/wg-quick

RUN \
    sed -i 's/^\(tty\d\:\:\)/#\1/' /etc/inittab && \
    sed -i \
        -e 's/^#\?rc_env_allow=.*/rc_env_allow="\*"/' \
        -e 's/^#\?rc_sys=.*/rc_sys="docker"/' \
        /etc/rc.conf && \
    sed -i \
        -e 's/VSERVER/DOCKER/' \
        -e 's/checkpath -d "$RC_SVCDIR"/mkdir "$RC_SVCDIR"/' \
        /lib/rc/sh/init.sh && \
    rm \
        /etc/init.d/hwdrivers \
        /etc/init.d/machine-id && \
    sed -i 's/cmd sysctl -q \(.*\?\)=\(.*\)/[[ "$(sysctl -n \1)" != "\2" ]] \&\& \0/' /usr/bin/wg-quick && \
    rc-update add wg-quick default

VOLUME ["/sys/fs/cgroup"]
CMD ["/sbin/init"]
