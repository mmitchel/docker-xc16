FROM debian:jessie

MAINTAINER Michael Mitchell <mmitchel@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Microchip Tools Require i386 Compatability as Dependency
RUN dpkg --add-architecture i386 \
    && apt-get update -yq \
    && apt-get upgrade -yq \
    && apt-get install -yq --no-install-recommends curl libc6:i386 \
    libx11-6:i386 libxext6:i386 libstdc++6:i386 libexpat1:i386 \
    libxext6 libxrender1 libxtst6 libgtk2.0-0 libxslt1.1

## Download and Install XC8 Compiler, Current Version
#RUN curl -fSL -A "Mozilla/4.0" -o /tmp/xc8.run "http://www.microchip.com/mplabxc8linux" \
#    && chmod a+x /tmp/xc8.run \
#    && /tmp/xc8.run --mode unattended --unattendedmodeui none \
#        --netservername localhost --LicenseType FreeMode --prefix /opt/microchip/xc8 \
#    && rm /tmp/xc8.run
#ENV PATH /opt/microchip/xc8/bin:$PATH

# Download and Install XC16 Compiler, Current Version
RUN curl -fSL -A "Mozilla/4.0" -o /tmp/xc16.run "http://www.microchip.com/mplabxc16linux" \
    && chmod a+x /tmp/xc16.run \
    && /tmp/xc16.run --mode unattended --unattendedmodeui none \
        --netservername localhost --LicenseType FreeMode --prefix /opt/microchip/xc16 \
    && rm /tmp/xc16.run
ENV PATH /opt/microchip/xc16/bin:$PATH

## Download and Install XC32 Compiler, Current Version
#RUN curl -fSL -A "Mozilla/4.0" -o /tmp/xc32.run "http://www.microchip.com/mplabxc32linux" \
#    && chmod a+x /tmp/xc32.run \
#    && /tmp/xc32.run --mode unattended --unattendedmodeui none \
#        --netservername localhost --LicenseType FreeMode --prefix /opt/microchip/xc32 \
#    && rm /tmp/xc32.run
#ENV PATH /opt/microchip/xc32/bin:$PATH

## Download and Install MPLABX IDE, Current Version
#RUN curl -fSL -A "Mozilla/4.0" -o /tmp/mplabx-installer.tar "http://www.microchip.com/mplabx-ide-linux-installer" \
#    && tar xf /tmp/mplabx-installer.tar && rm /tmp/mplabx-installer.tar \
#    && USER=root ./*-installer.sh --nox11 \
#        -- --unattendedmodeui none --mode unattended --installdir /opt/microchip/mplabx \
#    && rm ./*-installer.sh
#ENV PATH /opt/microchip/mplabx/mplab_ide/bin:$PATH

# Exported Volumes
RUN useradd developer \
    && mkdir -p /home/developer/MPLABXProjects \
    && touch /home/developer/MPLABXProjects/.directory \
    && chown developer:developer /home/developer/MPLABXProjects
VOLUME /home/developer/MPLABXProjects

#VOLUME ["/tmp/.X11-unix"]
#CMD ["/usr/bin/mplab_ide"]
