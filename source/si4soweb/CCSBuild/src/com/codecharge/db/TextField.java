//TextField class @0-AA4FC773
package com.codecharge.db;

import java.text.*;
import com.codecharge.util.*;

public class TextField extends Field implements Cloneable {
    String value;

    public TextField() {}
    
    public TextField( String name ) {
        super(name, null);
    }

    public TextField( String name, String field ) {
        super(name,field);
    }
    
    public TextField( String name, String field, Object value ) {
        super(name,field);
        setValue(value);
    }
    
    public void applyDefaultValue() {
        value = null;
    }
    
    public Object getObjectValue() {
        return value;
    }

    public void setObjectValue( Object value ) {
        this.value = (String) value;
    }

    public String getValue() {
        return value;
    }

    public void setValue( String value ) {
        this.value = value;
    }

    public void setValue( Object value ) {
        if ( value == null || value instanceof String ) {
            this.value = (String) value;
        } else {
            this.value = value.toString();
        }
    }

    /** Set parameter value, ignoring Format parameter.
      @param value new parameter value in form of Object
      @param ignore format used to convert value to Double type
      @see #setValue(Object)
     */
    public void setValue( Object value, Format ignore ) {
        if ( value == null ) {
            this.value = null;
        } else if ( value instanceof String ) {
            if ( StringUtils.isEmpty( (String) value ) ) {
                this.value = null;
            } else {
                this.value = (String) value;
            }
        } else {
            this.value = value.toString();
        }
    }
    
    public Object clone() {
        return super.clone();
    }

}
//End TextField class

