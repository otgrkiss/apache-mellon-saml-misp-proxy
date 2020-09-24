#!/bin/bash

# variable preperation for sp metadata, cert and key
mellon_endpoint_url="${sp_scheme}://${sp_host}:${sp_port}/mellon"
mellon_entity_id="${mellon_endpoint_url}/metadata"
file_prefix="${sp_scheme}_${sp_host}_${sp_port}_mellon_metadata"

# create metadata, cert and key for client
cd /etc/httpd/saml2
/usr/sbin/mellon_create_metadata $mellon_entity_id $mellon_endpoint_url
mv ${file_prefix}.cert /etc/httpd/saml2/mellon.crt
mv ${file_prefix}.key /etc/httpd/saml2/mellon.key
mv ${file_prefix}.xml /etc/httpd/saml2/mellon_metadata.xml
mkdir -p /var/www/html/saml
cp /etc/httpd/saml2/mellon_metadata.xml /var/www/html/saml/metadata.xml
chown www-data:www-data /var/www/saml_metadata/metadata/saml.xml

# download metadata from idp
curl -k -o /etc/httpd/saml2/idp_metadata.xml "${idp_metadata_url}"

sed "s|proxy_destination_scheme_host|${proxy_destination_scheme_host}|g" /etc/httpd/saml2/mellon_template.conf > /etc/apache2/sites-enabled/mellon.conf
sed -i "s|misp_secure_header|${misp_secure_header}|g" /etc/apache2/sites-enabled/mellon.conf

# test apache config
apachectl configtest

/usr/sbin/apache2ctl -D FOREGROUND