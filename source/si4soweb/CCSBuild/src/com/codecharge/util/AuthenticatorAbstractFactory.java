//AuthenticatorAbstractFactory class @0-ADFAC299
package com.codecharge.util;

import javax.servlet.http.HttpServletRequest;

abstract public class AuthenticatorAbstractFactory {

    public static Authenticator getAuthenticator( HttpServletRequest request ) {
    	return CCSTableAuthenticator.getInstance(request);
    }

}

//End AuthenticatorAbstractFactory class

