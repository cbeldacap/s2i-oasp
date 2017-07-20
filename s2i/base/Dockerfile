# s2i-oasp-base
FROM centos:centos7
MAINTAINER Michael Kuehl <mkuehl@redhat.com>

ENV VERSION 1.0
ENV RELEASE 1

ENV SUMMARY="Base image for running OASP-based applications"
ENV DESCRIPTION="Base image for running OASP-based applications"

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="DESCRIPTION" \
      io.k8s.display-name="oasp-base" \
      io.openshift.tags="builder,oasp" \
      name="centos/nginx-110-centos7" \
      version="$VERSION" \
      release="$RELEASE"

# Gain access to EPEL (Extra Packages for Enterprise Linux)
RUN yum install -y epel-release

# Clean the cache (see https://access.redhat.com/articles/1320623)
RUN rm -fr /var/cache/yum/* && yum clean all 

# Packages to add
ENV INSTALL_PKGS "nss_wrapper bind-utils"
ENV INSTALL_DEV_PKGS "autoconf automake binutils bison flex gcc gcc-c++ gettext libtool make patch pkgconfig redhat-rpm-config rpm-build rpm-sign"

# Install packages
RUN yum install -y yum-utils gettext hostname && \
    yum install -y centos-release-scl-rh && \
    yum-config-manager --enable centos-sclo-rh-testing && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS $INSTALL_DEV_PKGS && \
    rpm -V $INSTALL_PKGS $INSTALL_DEV_PKGS && \
    yum clean all
