//CCSAuthenticatorFactory class @0-A311FC15
package com.codecharge.util;

import javax.servlet.http.HttpServletRequest;

public class CCSAuthenticatorFactory extends AuthenticatorAbstractFactory {

    public static Authenticator getAuthenticator( HttpServletRequest request ) {
        String securityType = ContextStorage.getInstance().getAttributeAsString( "authenticator.securityType" );
        Authenticator auth = null;
        if ( "container".equalsIgnoreCase( securityType ) ) {
            auth = HttpAuthenticator.getInstance( request );
        } else if ( "ccs".equalsIgnoreCase( securityType ) ) {
            auth = CCSTableAuthenticator.getInstance( request );
        }
        return auth;
    }

}

//End CCSAuthenticatorFactory class

