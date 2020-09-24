FROM ubuntu:latest
MAINTAINER Garrit Schroeder

RUN apt-get update && apt-get -y upgrade

# Install apache, PHP, and supplimentary programs. curl and lynx-cur are for debugging the container.
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 openssl pkg-config liblasso3 libapache2-mod-auth-mellon curl

RUN a2enmod ssl
RUN a2enmod headers
RUN a2enmod rewrite
RUN a2enmod auth_mellon
RUN a2enmod proxy
RUN a2enmod proxy_http
RUN a2enmod proxy_balancer
RUN a2enmod lbmethod_byrequests

#variables to set during build :((
ENV scheme "http"
ENV sp_host "localhost"
ENV sp_port "8081"
ENV idp_metadata_url "http://192.168.178.205:8080/auth/realms/local-groupsec/protocol/saml/descriptor"
#warning leading slash is important
ENV proxy_destination_scheme_host "http://192.168.178.205:8083/"

# variable preperation for sp metadata, cert and key
ENV mellon_endpoint_url "${scheme}://${sp_host}:${sp_port}/mellon"
ENV mellon_entity_id "${mellon_endpoint_url}/metadata"
ENV file_prefix "${scheme}_${sp_host}_${sp_port}_mellon_metadata"

# create metadata, cert and key for client
RUN mkdir -p /etc/httpd/saml2 && cd /etc/httpd/saml2
RUN /usr/sbin/mellon_create_metadata $mellon_entity_id $mellon_endpoint_url
RUN mv ${file_prefix}.cert /etc/httpd/saml2/mellon.crt
RUN mv ${file_prefix}.key /etc/httpd/saml2/mellon.key
RUN mv ${file_prefix}.xml /etc/httpd/saml2/mellon_metadata.xml
RUN cp /etc/httpd/saml2/mellon_metadata.xml /var/www/html/metadata.xml
RUN chown www-data:www-data /var/www/html/metadata.xml

# download metadata from idp
RUN curl -k -o /etc/httpd/saml2/idp_metadata.xml "${idp_metadata_url}"

# add mellon proxy config
COPY ./config/mellon.conf /etc/apache2/sites-enabled/mellon.conf
# modify proxy config to match host
RUN sed -i "s|proxy_destination_scheme_host|${proxy_destination_scheme_host}|g" /etc/apache2/sites-enabled/mellon.conf

# remove default pages
RUN rm /etc/apache2/sites-enabled/0*.conf

# test apache config
RUN apachectl configtest

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80 443

# By default, simply start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND