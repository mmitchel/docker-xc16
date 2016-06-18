FROM debian:jessie

MAINTAINER Michael Mitchell <mmitchel@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Microchip tools require i386 compatability libs
RUN dpkg --add-architecture i386 \
    && apt-get update -y \
    && apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386

RUN buildDeps='curl' \
    && apt-get install -y --no-install-recommends $buildDeps \
    && curl -fSL -A "Mozilla/4.0" -o /tmp/xc16.run "http://www.microchip.com/mplabxc16linux" \
    && chmod a+x /tmp/xc16.run \
    && /tmp/xc16.run --mode unattended --unattendedmodeui none \
        --netservername localhost --LicenseType FreeMode \
    && apt-get purge -y --auto-remove $buildDeps \
    && apt-get clean \
    && rm /tmp/xc16.run

ENV PATH /opt/microchip/xc16/v1.26/bin:$PATH
