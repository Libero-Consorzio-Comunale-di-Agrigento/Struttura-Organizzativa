//Field class @0-AE99CE85
package com.codecharge.db;

import java.text.*;

abstract public class Field implements ReadOnlyField, Cloneable {
    protected String name;
    protected String field;
    //protected String errorValue;
    protected Format format;
    protected String dbFormatPattern;
    protected FieldOperation operation;

    public Field(){}

    public Field( String name ) {
        this(name, null);
    }

    public Field( String name, String field ) {
        this.name = name;
        this.field = field;
    }
    
    public String getName() {
        return name;
    }

    public void setName( String name ) {
        this.name = name;
    }

    public String getField() {
        return field;
    }

    public void setField( String field ) {
        this.field = field;
    }

    public Format getDbFormat() {
        return format;
    }

    public void setDbFormat( Format format ) {
        this.format = format;
    }

    public String getDbFormatPattern() {
        return dbFormatPattern;
    }

    public void setDbFormatPattern( String formatPattern ) {
        this.dbFormatPattern = formatPattern;
    }

    public Format getFormat() {
        return format;
    }

    public void setFormat( Format format ) {
        this.format = format;
    }

    public void setFormat( Format format, String ignore ) {
        this.format = format;
    }

    public FieldOperation getOperation() {
        return operation;
    }

    public void setOperation( FieldOperation operation ) {
        this.operation = operation;
    }

    //public String getErrorValue() {
    //    return errorValue;
    //}

    public String toString() {
        return "Field name: "+name+" field: "+field+" dbFormatPattern: "+dbFormatPattern;
    }

    public Object clone() {
        Object obj = null;
        try {
            obj = super.clone();
        } catch (CloneNotSupportedException cnse_ignore) {}
        return obj;
    }

    abstract public Object getObjectValue();
    abstract public void setObjectValue(Object value);
    abstract public void applyDefaultValue();
}
//End Field class

