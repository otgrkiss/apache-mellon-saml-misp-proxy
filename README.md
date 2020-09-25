# apache-mellon-saml-misp-proxy

Warning: No security settings and modifications were applied at this point.

Apache 2.4 with Mellon Mod installed secures the proxy location with SAML.
After successful authentication the email address of the user is set as a request header to enable custom authentication for the misp project.

- Apache 2.4
- Apache mellon mod
  - SAML based authentication (tested with keycloak 11.0.2)  
  
SP Metadata URL: /saml/metadata.xml   


Saml Login on misp

Cool way: <br> 
Edit file MISP/app/Config/config.php <br>
Change line: from 'ApacheShibbAuth' => NULL to 'ApacheShibbAuth' => true

This displays a login button "Login with SAML" on the default login page of misp

Apache Proxy is saml authenticating users based on the following locations:
  - ###### /sso/users/login
  - /Shibboleth.sso/Login (Supporting the standard SAML Login button in misp)





