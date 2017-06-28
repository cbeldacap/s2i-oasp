# s2i-oasp
FROM centos:centos7
MAINTAINER Michael Kuehl <mkuehl@redhat.com>

# Gain access to EPEL (Extra Packages for Enterprise Linux)
RUN yum install -y epel-release

#
# Install basic tools on top of base image
#
RUN INSTALL_PKGS="git curl tar unzip bc which lsof" && \
    yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS

#
# Install the JDK
#
ENV JAVA_VERSION 1.8.0
RUN INSTALL_PKGS="java-$JAVA_VERSION-openjdk java-$JAVA_VERSION-openjdk-devel" && \
    yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS

#
# Install Maven
#
ENV MAVEN_VERSION 3.5.0
RUN (curl -0 http://www.eu.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | \
    tar -zx -C /usr/local) && \
    mv /usr/local/apache-maven-$MAVEN_VERSION /usr/local/maven && \
    ln -sf /usr/local/maven/bin/mvn /usr/local/bin/mvn

# Add a default mvn settings.xml file
ENV MAVEN_HOME /usr/local/maven
COPY ./contrib/settings.xml $MAVEN_HOME/conf
RUN chmod -R a+rwX $MAVEN_HOME/conf

#
# Install JavaScript/npm/node & build tools
#
RUN yum install -y npm
RUN npm install -g gulp
RUN npm install -g bower

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

ENV PATH=/opt/maven/bin/:$PATH
ENV BUILDER_VERSION 1.0

# Copy the builder files
LABEL io.openshift.s2i.scripts-url=image:///usr/local/sti
COPY ./sti/bin/ /usr/local/sti

RUN chown -R 1001:1001 /opt/openshift
RUN chmod -R 777 /usr/local/sti

# The default user in the centos image
USER 1001

# Set the default port for applications built using this image
EXPOSE 8080

# Set the default CMD for the image
# CMD ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/opt/openshift/app.jar"]
CMD ["usage"]
