//SimpleSessionStorage class @0-0E69D3C3
package com.codecharge.util;

import javax.servlet.http.*;

public class SimpleSessionStorage implements SessionStorageInterface {
    
    private HttpServletResponse response = null;
    private HttpServletRequest request = null;
    
    public SimpleSessionStorage() {
    }
    
    public void setRequest( HttpServletRequest request ) {
        this.request = request;
    }
    
    public void setResponse( HttpServletResponse response ) {
        this.response = response;
    }
    
    public Object getAttribute( String name ) {
        return request.getSession().getAttribute( name );
    }
    
    public String getAttributeAsString( String name ) {
        Object val = request.getSession().getAttribute( name );
        if ( val == null ) {
            return "";
        }
        else {    
            return val.toString();
        }
    }
    
    public void setAttribute( String name, Object value ) {
        request.getSession().setAttribute( name, value );
    }
    
    public void removeAttribute( String name ) {
        request.getSession().removeAttribute( name );
    }

    public String encodeRedirectURL( String redirectURL ) {
        if ( StringUtils.isEmpty( redirectURL ) || response == null ) return redirectURL;
        return response.encodeRedirectURL( redirectURL );
    }

    public String encodeURL( String url ) {
        if ( StringUtils.isEmpty( url ) || response == null ) return url;
        return response.encodeURL( url );
    }

}

//End SimpleSessionStorage class

