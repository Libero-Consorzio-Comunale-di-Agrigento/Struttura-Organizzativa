//PreserveParameterType class @0-41351FED
package com.codecharge.util;

final public class PreserveParameterType {

    final static public PreserveParameterType NONE = new PreserveParameterType("NONE");
    final static public PreserveParameterType GET = new PreserveParameterType("GET");
    final static public PreserveParameterType POST = new PreserveParameterType("POST");
    final static public PreserveParameterType ALL = new PreserveParameterType("ALL");
    
    static private int counter;

    private int type;
    private String name;

    private PreserveParameterType( String name ) {
        this.type = counter++;
        this.name = name;
    }

    public String toString() {
        return name;
    }

    public static PreserveParameterType getPreserveParameterType( String type ) {
        if ( "NONE".equalsIgnoreCase(type) ) return PreserveParameterType.NONE;
        if ( "GET".equalsIgnoreCase(type) ) return PreserveParameterType.GET;
        if ( "POST".equalsIgnoreCase(type) ) return PreserveParameterType.POST;
        if ( "ALL".equalsIgnoreCase(type) ) return PreserveParameterType.ALL;
        return null;
    }
}
//End PreserveParameterType class

