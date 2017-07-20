# s2i-oasp-java
FROM 172.30.1.1:5000/oasp/s2i-oasp-base:latest
MAINTAINER Michael Kuehl <mkuehl@redhat.com>

# Set the default port for applications built using this image
EXPOSE 8080

ENV JAVA_VERSION 1.8.0
ENV MAVEN_VERSION 3.5.0

# Packages to add
ENV INSTALL_PKGS "curl tar unzip java-$JAVA_VERSION-openjdk java-$JAVA_VERSION-openjdk-devel"

# Install extra packages
RUN yum install -y yum-utils gettext hostname && \
    yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all

# Install Maven
RUN (curl -0 http://www.eu.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | \
    tar -zx -C /usr/local) && \
    mv /usr/local/apache-maven-$MAVEN_VERSION /usr/local/maven && \
    ln -sf /usr/local/maven/bin/mvn /usr/local/bin/mvn

# Add a default mvn settings.xml file
ENV MAVEN_HOME /usr/local/maven
COPY s2i/java/contrib/settings.xml $MAVEN_HOME/conf
RUN chmod -R a+rwX $MAVEN_HOME/conf

# Prepare folders etc.
RUN mkdir -p /opt/openshift && \
    mkdir -p /opt/app-root/source && chmod -R a+rwX /opt/app-root/source && \
    mkdir -p /opt/s2i/destination && chmod -R a+rwX /opt/s2i/destination && \
    mkdir -p /opt/app-root/src && chmod -R a+rwX /opt/app-root/src

ENV PATH=/opt/maven/bin/:$PATH
ENV BUILDER_VERSION 1.0

# Copy the builder files
LABEL io.openshift.s2i.scripts-url=image:///usr/local/sti
COPY s2i/java/bin/ /usr/local/sti

RUN chown -R 1001:1001 /opt/openshift
RUN chmod -R 777 /usr/local/sti

# The default user in the centos image
USER 1001

# Set the default CMD for the image
CMD ["usage"]
