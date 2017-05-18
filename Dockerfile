# s2i-oasp
FROM openshift/base-centos7
MAINTAINER Michael Kuehl <mkuehl@redhat.com>
# HOME in base image is /opt/app-root/src

# Gain access to EPEL (Extra Packages for Enterprise Linux)
RUN yum install -y epel-release

# Install build tools on top of base image

ENV JAVA_VERSION 1.8.0
RUN INSTALL_PKGS="npm git tar unzip bc which lsof java-$JAVA_VERSION-openjdk java-$JAVA_VERSION-openjdk-devel" && \
    yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y && \
    mkdir -p /opt/openshift && \
    mkdir -p /opt/app-root/source && chmod -R a+rwX /opt/app-root/source && \
    mkdir -p /opt/s2i/destination && chmod -R a+rwX /opt/s2i/destination && \
    mkdir -p /opt/app-root/src && chmod -R a+rwX /opt/app-root/src

ENV MAVEN_VERSION 3.5.0
RUN (curl -0 http://www.eu.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | \
    tar -zx -C /usr/local) && \
    mv /usr/local/apache-maven-$MAVEN_VERSION /usr/local/maven && \
    ln -sf /usr/local/maven/bin/mvn /usr/local/bin/mvn && \
    mkdir -p $HOME/.m2 && chmod -R a+rwX $HOME/.m2

# Install the node.js etc stuff
RUN npm install -g gulp
RUN npm install -g bower

ENV PATH=/opt/maven/bin/:$PATH
ENV BUILDER_VERSION 1.0

# Copy the builder files
LABEL io.openshift.s2i.scripts-url=image:///usr/local/sti
COPY ./sti/bin/ /usr/local/sti
COPY ./contrib/settings.xml $HOME/.m2/

RUN chown -R 1001:1001 /opt/openshift
RUN chmod -R 777 /usr/local/sti

RUN ls -la /usr/local
RUN ls -la /usr/local/sti

# This default user is created in the openshift/base-centos7 image
USER 1001

# Set the default port for applications built using this image
EXPOSE 8080

# Set the default CMD for the image
# CMD ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/opt/openshift/app.jar"]
CMD ["usage"]
