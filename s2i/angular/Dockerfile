# s2i-oasp-angular
FROM centos:centos7
MAINTAINER Michael Kuehl <mkuehl@redhat.com>

# Gain access to EPEL (Extra Packages for Enterprise Linux)
RUN yum install -y epel-release

#
# Install basic tools on top of base image
#
RUN INSTALL_PKGS="git curl tar unzip bc which lsof make" && \
    yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS


#
# Install JavaScript/npm/node & build tools
#
RUN yum install -y npm
RUN npm install -g yarn

# Location of the node modules
RUN mkdir -p /usr/lib/node_modules && chmod -R 777 /usr/lib/node_modules

# Done with installations, clean-up now
RUN yum clean all -y

#
# Prepare folders etc.
#
RUN mkdir -p /opt/openshift && \
    mkdir -p /opt/app-root/source && chmod -R a+rwX /opt/app-root/source && \
    mkdir -p /opt/s2i/destination && chmod -R a+rwX /opt/s2i/destination && \
    mkdir -p /opt/app-root/src && chmod -R a+rwX /opt/app-root/src

ENV BUILDER_VERSION 1.0

# Copy the builder files
LABEL io.openshift.s2i.scripts-url=image:///usr/local/sti
COPY s2i/angular/bin/ /usr/local/sti

RUN chown -R 1001:1001 /opt/openshift
RUN chmod -R 777 /usr/local/sti

# The default user in the centos image
USER 1001

# Set the default port for applications built using this image
EXPOSE 80

# Set the default CMD for the image
CMD ["usage"]
