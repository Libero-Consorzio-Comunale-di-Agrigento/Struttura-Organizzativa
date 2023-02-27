//ControlType interface @0-3ECDF900
package com.codecharge.components;

final public class ControlType {

    static public ControlType INTEGER = new ControlType("INTEGER");
    static public ControlType FLOAT   = new ControlType("FLOAT");
    static public ControlType DATE    = new ControlType("DATE");
    static public ControlType BOOLEAN = new ControlType("BOOLEAN");
    static public ControlType TEXT    = new ControlType("TEXT");
    static public ControlType MEMO    = new ControlType("MEMO");

    static private int counter;

    private int type;
    private String name;

    private ControlType() {
        this.type = counter++;
    }

    private ControlType( String name ) {
        this.type = counter++;
        this.name = name;
    }

    public String toString() {
        if ( name == null )
            return String.valueOf( type );
        else
            return name;
    }

    public static ControlType getControlType( String type ) {
        if ( "INTEGER".equalsIgnoreCase(type) ) return ControlType.INTEGER;
        if ( "FLOAT".equalsIgnoreCase(type) ) return ControlType.FLOAT;
        if ( "DATE".equalsIgnoreCase(type) ) return ControlType.DATE;
        if ( "BOOLEAN".equalsIgnoreCase(type) ) return ControlType.BOOLEAN;
        if ( "TEXT".equalsIgnoreCase(type) ) return ControlType.TEXT;
        if ( "MEMO".equalsIgnoreCase(type) ) return ControlType.MEMO;
        return null;
    }
}
//End ControlType interface

