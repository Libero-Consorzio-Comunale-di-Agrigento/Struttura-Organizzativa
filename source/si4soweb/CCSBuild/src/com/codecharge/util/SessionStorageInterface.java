//SessionStorageInterface interface @0-05772913
package com.codecharge.util;

import javax.servlet.http.*;

public interface SessionStorageInterface extends Storage {

    public String encodeRedirectURL( String redirectURL );
    public String encodeURL( String redirectURL );
    public void setRequest( HttpServletRequest request );
}
//End SessionStorageInterface interface

