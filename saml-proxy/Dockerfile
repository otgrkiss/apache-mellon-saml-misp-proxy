FROM ubuntu:latest
MAINTAINER Garrit Schroeder

RUN apt-get update && apt-get -y upgrade

# Install apache, PHP, and supplimentary programs. curl and lynx-cur are for debugging the container.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 openssl pkg-config liblasso3 libapache2-mod-auth-mellon curl

#enable dependencies
RUN a2enmod ssl
RUN a2enmod headers
RUN a2enmod rewrite
RUN a2enmod auth_mellon
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod proxy_balancer
RUN a2enmod lbmethod_byrequests

# create folder for config, metadata and keys / added later by setup_mellon.sh
RUN mkdir -p /etc/httpd/saml2
# add mellon template config
COPY config/mellon_ssl_template.conf /etc/httpd/saml2/mellon_ssl_template.conf
COPY config/setup_mellon.sh /etc/httpd/saml2/setup_mellon.sh
RUN chmod +x /etc/httpd/saml2/setup_mellon.sh

# remove default pages
RUN rm /etc/apache2/sites-enabled/0*.conf

# for ssl certificate and key
RUN mkdir -p /usr/local/ssl
RUN mkdir -p  /usr/local/ssl/crt

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80 443

# By default, simply start apache.
CMD /etc/httpd/saml2/setup_mellon.sh