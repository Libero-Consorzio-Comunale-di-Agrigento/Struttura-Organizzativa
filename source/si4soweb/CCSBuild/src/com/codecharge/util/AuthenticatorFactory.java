//AuthenticatorFactory class @0-0B47603D
package com.codecharge.util;

import javax.servlet.http.HttpServletRequest;

public class AuthenticatorFactory {

    public static Authenticator getAuthenticator( HttpServletRequest request ) {
        String authClassName = StringUtils.getSiteProperty("authenticator.factoryClassName", "com.codecharge.util.CCSAuthenticatorFactory");
        Authenticator auth = null;
        AuthenticatorAbstractFactory authFactory = null;
        CCLogger logger = CCLogger.getInstance();
        
	    try {
	        Class handler = Class.forName( authClassName );
	        authFactory = (AuthenticatorAbstractFactory) handler.newInstance();
	        auth = authFactory.getAuthenticator(request);
	    } catch ( java.lang.ClassNotFoundException cnfe ) {
	        logger.error( "AuthenticatorFactory: Class '" + authClassName + "' is not found" );
	    } catch ( java.lang.InstantiationException ie ) {
	        logger.error( "AuthenticatorFactory: Unable to create instance '" + authClassName );
	    } catch ( java.lang.IllegalAccessException iae ) {
	        logger.error( "AuthenticatorFactory: IllegalAccessException occurred while creating instance '" + authClassName  );
	    }
        
        return auth;
    }

}

//End AuthenticatorFactory class

