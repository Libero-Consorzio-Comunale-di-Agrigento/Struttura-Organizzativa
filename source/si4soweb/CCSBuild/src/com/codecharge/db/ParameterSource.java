//ParameterSource class @0-17891339
package com.codecharge.db;

final public class ParameterSource {

    static public ParameterSource CONTROL = new ParameterSource("CONTROL", "ctrl");
    static public ParameterSource EXPRESSION   = new ParameterSource("EXPRESSION", "expr");
    static public ParameterSource URL    = new ParameterSource("URL", "url");
    static public ParameterSource FORM = new ParameterSource("FORM", "post");
    static public ParameterSource SESSION    = new ParameterSource("SESSION", "ses");
    static public ParameterSource APPLICATION    = new ParameterSource("APPLICATION", "app");
    static public ParameterSource COOKIE    = new ParameterSource("COOKIE", "cook");
    static public ParameterSource DATAFIELD    = new ParameterSource("DATAFIELD", "");
    static public ParameterSource CONST    = new ParameterSource("CONST", "");
    static public ParameterSource CACHED   = new ParameterSource("DataSourceColumn", "");

    static private int counter;

    private int type;
    private String name;
    private String prefix;

    private ParameterSource() {
        this.type = counter++;
    }

    private ParameterSource( String name, String prefix ) {
        this.type = counter++;
        this.name = name;
        this.prefix = prefix;
    }

    public String getPrefix() {
        return prefix;
    }

    public String toString() {
        if ( name == null )
            return String.valueOf( type );
        else
            return name;
    }

    public static ParameterSource getParameterSource( String type ) {
        if ( "CONTROL".equalsIgnoreCase(type) ) return ParameterSource.CONTROL;
        if ( "EXPRESSION".equalsIgnoreCase(type) ) return ParameterSource.EXPRESSION;
        if ( "URL".equalsIgnoreCase(type) ) return ParameterSource.URL;
        if ( "FORM".equalsIgnoreCase(type) ) return ParameterSource.FORM;
        if ( "SESSION".equalsIgnoreCase(type) ) return ParameterSource.SESSION;
        if ( "APPLICATION".equalsIgnoreCase(type) ) return ParameterSource.APPLICATION;
        if ( "COOKIE".equalsIgnoreCase(type) ) return ParameterSource.COOKIE;
        if ( "DATAFIELD".equalsIgnoreCase(type) ) return ParameterSource.DATAFIELD;
        if ( "CONST".equalsIgnoreCase(type) ) return ParameterSource.CONST;
        if ( "DataSourceColumn".equalsIgnoreCase(type) ) return ParameterSource.CACHED;
        return null;
    }
} //End of ParameterSource class

//End ParameterSource class

