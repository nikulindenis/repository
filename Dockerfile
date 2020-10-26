FROM ubuntu:bionic
MAINTAINER Denis Nikulin <nikulindeniska@gmail.com>


RUN apt update && \
    apt install -q -y autoconf automake libtool autotools-dev dpkg-dev fakeroot dpkg debconf debhelper lintian git wget apache2 && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/peervpn/peervpn.git /opt/peervpn

ADD scripts/lib.sh /opt/peervpn/
RUN cd /opt/peervpn/ && \
    ./lib.sh

RUN mkdir -p /opt/peervpn/DEBIAN && \
    touch /opt/peervpn/DEBIAN/control && \
    echo "Package: peervpn" > /opt/peervpn/DEBIAN/control && \
    echo "Version: 1.0-1" >> /opt/peervpn/DEBIAN/control && \
    echo "Section: utils" >> /opt/peervpn/DEBIAN/control && \
    echo "Priority: extra" >> /opt/peervpn/DEBIAN/control && \
    echo "Maintainer: Denis Nikulin <nikulindeniska@gmail.com>" >> /opt/peervpn/DEBIAN/control && \
    echo "Architecture: all" >> /opt/peervpn/DEBIAN/control && \
    echo "Depends: peervpn" >> /opt/peervpn/DEBIAN/control && \
    echo "Description: Peervpn package" >> /opt/peervpn/DEBIAN/control && \
    echo " Package with peervpn configs" >> /opt/peervpn/DEBIAN/control

RUN mkdir -p /opt/peervpn/usr/local/bin && \
    mv /opt/peervpn/peervpn /opt/peervpn/usr/local/bin

RUN cd /opt/peervpn && \
    fakeroot dpkg-deb --build /opt/peervpn/ && \
    mv /opt/peervpn.deb /opt/peervpn_1.0-1_all.deb

RUN cd /var/www/html && \
    mkdir debian && \
    cp /opt/peervpn_1.0-1_all.deb /var/www/html/debian/
    

RUN cd /var/www/html/debian && \
    dpkg-scanpackages . | gzip -c9  > Packages.gz

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]
