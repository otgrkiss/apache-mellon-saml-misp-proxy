FROM ubuntu:latest
MAINTAINER Garrit Schroeder

RUN apt-get update
RUN apt-get -y upgrade

# Install apache, PHP, and supplimentary programs. curl and lynx-cur are for debugging the container.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 openssl pkg-config liblasso3 libapache2-mod-auth-mellon curl

RUN a2enmod ssl
RUN a2enmod rewrite
RUN a2enmod auth_mellon

RUN mkdir -p /etc/httpd/saml2 && cd /etc/httpd/saml2
ENV fqdn "localhost"
ENV idp_host "192.168.178.205:8080"
ENV realm "local-groupsec"
ENV mellon_endpoint_url "http://${fqdn}/mellon"
ENV mellon_entity_id "${mellon_endpoint_url}/metadata"
ENV file_prefix "http_${fqdn}_mellon_metadata"

RUN /usr/sbin/mellon_create_metadata $mellon_entity_id $mellon_endpoint_url

RUN mv ${file_prefix}.cert /etc/httpd/saml2/mellon.crt
RUN mv ${file_prefix}.key /etc/httpd/saml2/mellon.key
RUN mv ${file_prefix}.xml /etc/httpd/saml2/mellon_metadata.xml

RUN curl -k -o /etc/httpd/saml2/idp_metadata.xml "http://${idp_host}/auth/realms/${realm}/protocol/saml/descriptor"
RUN apachectl configtest


COPY ./config/mellon.conf /etc/apache2/sites-enabled/mellon.conf
RUN rm /etc/apache2/sites-enabled/0*.conf


# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80

# By default, simply start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND