//CCSPrincipal class @0-B94A38BC
package com.codecharge.util;

import java.security.Principal;

public class CCSPrincipal implements Principal {

    private String name;

    public CCSPrincipal( String name ) {
        this.name = name;
    }

    public boolean equals( Object another ) {
        return another instanceof Principal && ((Principal) another).getName().equals(getName());
    }
    
    public String getName() {
        return name;
    }
    
    public String toString() {
        return getName();
    }
}

//End CCSPrincipal class

