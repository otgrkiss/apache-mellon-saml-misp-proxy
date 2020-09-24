# apache-mellon-saml-misp-proxy

Warning: No security settings and modifications were applied at this point.

Apache 2.4 with Mellon Mod installed secures the proxy location with SAML.
After successful authentication the email address of the user is set as a request header to enable custom authentication for the misp project.

- Apache 2.4
- Apache mellon mod
  - SAML based authentication (tested with keycloak 11.0.2)  
  
SP Metadata URL: /saml/metadata.xml   




