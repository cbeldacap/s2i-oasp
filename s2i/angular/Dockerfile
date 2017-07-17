# s2i-oasp-angular
FROM centos:centos7
MAINTAINER Michael Kuehl <mkuehl@redhat.com>

# Set the default port for applications built using this image
EXPOSE 8080
EXPOSE 8443

ENV STI_SCRIPTS_PATH=/usr/local/sti
ENV NGINX_VERSION=1.10

ENV SUMMARY="Platform for running nginx $NGINX_VERSION or building nginx-based application" \
    DESCRIPTION="Nginx is a web server and a reverse proxy server for HTTP, SMTP, POP3 and IMAP \
protocols, with a strong focus on high concurrency, performance and low memory usage. The container \
image provides a containerized packaging of the nginx $NGINX_VERSION daemon. The image can be used \
as a base image for other applications based on nginx $NGINX_VERSION web server. \
Nginx server image can be extended using source-to-image tool."

LABEL summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="DESCRIPTION" \
      io.k8s.display-name="Nginx 1.10" \
      io.openshift.expose-services="8080:http" \
      io.openshift.expose-services="8443:https" \
      io.openshift.tags="builder,nginx,rh-nginx110" \
      com.redhat.component="rh-nginx110-docker" \
      name="centos/nginx-110-centos7" \
      version="1.10" \
      release="1"

ENV NGINX_CONFIGURATION_PATH=/opt/app-root/etc/nginx.d
ENV NGINX_DEFAULT_CONF_PATH=/opt/app-root/etc/nginx.default.d

# Gain access to EPEL (Extra Packages for Enterprise Linux)
RUN yum install -y epel-release

# Install extra packages
RUN yum install -y yum-utils gettext hostname && \
    yum install -y centos-release-scl-rh epel-release && \
    yum-config-manager --enable centos-sclo-rh-testing && \
    INSTALL_PKGS="nss_wrapper bind-utils rh-nginx110 rh-nginx110-nginx" && \
    INSTALL_DEV_PKGS="npm http-parser.x86_64 autoconf automake binutils bison flex gcc gcc-c++ gettext libtool make patch pkgconfig redhat-rpm-config rpm-build rpm-sign" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS $INSTALL_DEV_PKGS && \
    rpm -V $INSTALL_PKGS $INSTALL_DEV_PKGS && \
    yum clean all

# Copy the S2I scripts from the specific language image to $STI_SCRIPTS_PATH
LABEL io.openshift.s2i.scripts-url=image:///usr/local/sti
COPY s2i/angular/bin/ $STI_SCRIPTS_PATH

# In order to drop the root user, we have to make some directories world
# writeable as OpenShift default security model is to run the container under
# random UID.
RUN sed -i -f /opt/app-root/nginxconf.sed /etc/opt/rh/rh-nginx110/nginx/nginx.conf && \
    mkdir -p /opt/app-root/etc/nginx.d/ && \
    mkdir -p /opt/app-root/etc/nginx.default.d/ && \
    mkdir -p /opt/app-root/html && \
    mkdir -p /usr/lib/node_modules && \
    mkdir -p /.cache && \
    mkdir -p /.config && \
    chmod -R a+rwx /opt/app-root/etc && \
    chmod -R a+rwx /var/opt/rh/rh-nginx110 && \
    chmod -R a+rwX /usr/lib/node_modules && \
    chmod -R a+rwX /.cache && \
    chmod -R a+rwX /.config && \
    chmod -R a+rwX /opt/app-root/html && \
    chown -R 1001:0 /opt/app-root && \
    chown -R 1001:0 /var/opt/rh/rh-nginx110 && \
    chown -R 1001:0 /usr/lib/node_modules && \
    chown -R 1001:0 /.cache && \
    chown -R 1001:0 /.config && \
    chown -R 1001:0 /opt/app-root/html

# Copy extra files to the image.
COPY s2i/angular/root/ /

# Install Javascript stuff
RUN npm install -g yarn

# The default user in the centos image
USER 1001

VOLUME ["/opt/rh/rh-nginx110/root/usr/share/nginx/html"]
VOLUME ["/var/opt/rh/rh-nginx110/log/nginx/"]

ENV BASH_ENV=/opt/app-root/etc/scl_enable \
    ENV=/opt/app-root/etc/scl_enable \
    PROMPT_COMMAND=". /opt/app-root/etc/scl_enable"

CMD $STI_SCRIPTS_PATH/usage
