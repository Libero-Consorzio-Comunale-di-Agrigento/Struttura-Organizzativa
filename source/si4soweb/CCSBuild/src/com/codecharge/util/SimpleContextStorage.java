//SimpleContextStorage class @0-DFC1C86F
package com.codecharge.util;

import javax.servlet.*;

public class SimpleContextStorage implements Storage {

    private ServletContext context = null;
    
    public SimpleContextStorage() {
    }

    public void setServletContext( ServletContext context ) {
        this.context = context;
    }
    
    public Object getAttribute( String name ) {
        return context.getAttribute( name );
    }
    
    public String getAttributeAsString( String name ) {
        Object val = context.getAttribute( name );
        if ( val == null ) {
            return "";
        }
        else {    
            return val.toString();
        }
    }
    
    public void setAttribute( String name, Object value ) {
        context.setAttribute( name, value );
    }
    
    public void removeAttribute( String name ) {
        context.removeAttribute( name );
    }
}// End of ContextStorage

//End SimpleContextStorage class

