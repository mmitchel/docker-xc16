FROM debian:jessie

MAINTAINER Michael Mitchell <mmitchel@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Microchip Tools Require i386 Compatability as Dependency

RUN dpkg --add-architecture i386 \
    && apt-get update -yq \
    && apt-get upgrade -yq \
    && apt-get install -yq --no-install-recommends build-essential bzip2 cpio curl python unzip wget \
    libc6:i386 libx11-6:i386 libxext6:i386 libstdc++6:i386 libexpat1:i386 \
    libxext6 libxrender1 libxtst6 libgtk2.0-0 libxslt1.1 libncurses5-dev

# Download and Install XC8 Compiler, Current Version
#
#RUN curl -fSL -A "Mozilla/4.0" -o /tmp/xc8.run "http://www.microchip.com/mplabxc8linux" \
#    && chmod a+x /tmp/xc8.run \
#    && /tmp/xc8.run --mode unattended --unattendedmodeui none \
#        --netservername localhost --LicenseType FreeMode --prefix /opt/microchip/xc8 \
#    && rm /tmp/xc8.run
#
#ENV PATH $PATH:/opt/microchip/xc8/bin

# Download and Install XC16 Compiler, Current Version

RUN curl -fSL -A "Mozilla/4.0" -o /tmp/xc16.run "http://www.microchip.com/mplabxc16linux" \
    && chmod a+x /tmp/xc16.run \
    && /tmp/xc16.run --mode unattended --unattendedmodeui none \
        --netservername localhost --LicenseType FreeMode --prefix /opt/microchip/xc16 \
    && rm /tmp/xc16.run

ENV PATH $PATH:/opt/microchip/xc16/bin

# Download and Install XC32 Compiler, Current Version
#
#RUN curl -fSL -A "Mozilla/4.0" -o /tmp/xc32.run "http://www.microchip.com/mplabxc32linux" \
#    && chmod a+x /tmp/xc32.run \
#    && /tmp/xc32.run --mode unattended --unattendedmodeui none \
#        --netservername localhost --LicenseType FreeMode --prefix /opt/microchip/xc32 \
#    && rm /tmp/xc32.run
#
#ENV PATH $PATH:/opt/microchip/xc32/bin

# Download and Install MPLABX IDE, Current Version

RUN curl -fSL -A "Mozilla/4.0" -o /tmp/mplabx-installer.tar "http://www.microchip.com/mplabx-ide-linux-installer" \
    && tar xf /tmp/mplabx-installer.tar && rm /tmp/mplabx-installer.tar \
    && USER=root ./*-installer.sh --nox11 \
        -- --unattendedmodeui none --mode unattended --installdir /opt/microchip/mplabx \
    && rm ./*-installer.sh

ENV PATH $PATH:/opt/microchip/mplabx/mplab_ide/bin

VOLUME /tmp/.X11-unix

# Container Developer User Ident

RUN useradd user \
    && mkdir -p /home/user/MPLABXProjects \
    && touch /home/user/MPLABXProjects/.directory \
    && chown user:user /home/user/MPLABXProjects

VOLUME /home/user/MPLABXProjects

# Container Tool Version Reports to Build Log

RUN [ -x /opt/microchip/xc8/bin/xc8 ] && xc8 --ver
RUN [ -x /opt/microchip/xc16/bin/xc16-gcc ] && xc16-gcc --version
RUN [ -x /opt/microchip/xc32/bin/xc32-gcc ] && xc32-gcc --version

#CMD ["/opt/microchip/mplabx/mplab_ide/bin/mplab_ide"]
