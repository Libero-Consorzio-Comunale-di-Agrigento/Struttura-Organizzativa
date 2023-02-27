//HttpAuthenticator class @0-C3986EF9
package com.codecharge.util;

import java.security.Principal;
import javax.servlet.http.HttpServletRequest;

public class HttpAuthenticator extends Authenticator {

    boolean invalidateAuth = false;

    private HttpAuthenticator() {
    }

    public static Authenticator getInstance( HttpServletRequest request ) {
        Authenticator auth = (Authenticator) SessionStorage.getInstance( request ).getAttribute( "ccs.Authenticator" );
        if ( auth == null ) {
            auth = new HttpAuthenticator();
        }
        auth.setRequest( request );
        SessionStorage.getInstance( request ).setAttribute( "ccs.Authenticator", auth );
        return auth;
    }

    public Principal getUserPrincipal() {
        this.principal = request.getUserPrincipal();
        this.invalidateAuth = false;
        return this.principal;
    }
    
    public boolean authenticate( String userLogin, String userPassword ) {
        boolean authenticate = false;
        if ( getUserPrincipal() != null ) {
            authenticate = true;
            this.invalidateAuth = false;
        }
        return authenticate;
    }

    public boolean isUserInRole( String groupName ) {
        boolean inRole = false;
        if ( ! this.invalidateAuth ) {
            inRole = request.isUserInRole( groupName );
        }
        return inRole;
    }
    
    public String getRemoteUser() {
        if ( this.invalidateAuth ) {
            return null;
        } else {
            return request.getRemoteUser();
        }
    }
    
    public String getUserId() {
        if ( this.principal == null ) {
            return null;
        } else {
            return getRemoteUser();
        }
    }
    
    public String getUserName() {
        return getRemoteUser();
    }

    public String getGroupId() {
        return null;
    }

    public void invalidate() {
        this.principal = null;
        this.invalidateAuth = true;
    }

}

//End HttpAuthenticator class

