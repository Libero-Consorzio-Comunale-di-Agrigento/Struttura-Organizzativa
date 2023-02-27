//Storage interface @0-3899A246
package com.codecharge.util;

public interface Storage {
    public Object getAttribute( String name );
    public String getAttributeAsString( String name );
    public void setAttribute( String name, Object value );
    public void removeAttribute( String name );
}

//End Storage interface

