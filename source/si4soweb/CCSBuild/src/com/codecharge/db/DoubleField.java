//DoubleField class @0-EEDAFF19
package com.codecharge.db;

import java.text.*;
import com.codecharge.util.*;

public class DoubleField extends Field implements Cloneable {
    private Double value;

    public DoubleField() {}
    
    public DoubleField( String name ) {
        super(name, null);
    }

    public DoubleField( String name, String field ) {
        super(name,field);
    }
    
    public DoubleField( String name, String field, Object value ) {
        super(name,field);
        setValue(value);
    }
    
    public DoubleField( String name, String field, double value ) {
        super(name,field);
        setValue(value);
    }
    
    public void applyDefaultValue() {
        value = null;
    }
    
    public Object getObjectValue() {
        return value;
    }

    public Double getValue() {
        return value;
    }

    public double doubleValue() {
        return value.doubleValue();
    }

    public void setObjectValue( Object value ) {
        this.value = new Double(((Number) value).doubleValue());
    }

    public void setValue( Double value ) {
        this.value = value;
    }

    public void setValue( double value ) {
        this.value = new Double(value);
    }

    public void setValue( Object value ) {
        if ( value == null || value instanceof Double ) {
            this.value = (Double) value;
        } else if ( value instanceof Number ) {
            this.value = new Double( value.toString() );
        } else if ( value instanceof String ) {
            if ( "".equals( value ) ) {
                value = null;
            } else {
                this.value = new Double( value.toString() );
            }    
        }
    }

    /** Set parameter value, converting Object value with given Format to Double type.
      @param value new parameter value in form of Object
      @param format format used to convert value to Double type
     */
    public void setValue( Object value, Format format ) throws ParseException {
        if ( value == null || value instanceof Double) {
            this.value = (Double) value;
        } else if ( value instanceof String ) {
            if ( StringUtils.isEmpty( (String) value ) ) {
                this.value = null;
            } else {
                if ( format == null ) {
                    this.value = new Double( (String) value );
                } else {
                    this.value = ((NumericFormat) format).parseDouble( (String) value );
                }
            }
        } else if ( value instanceof Number ) {
            this.value = new Double( ((Number) value).doubleValue() );
        } else {
            this.value = null;
        }
    }

    public Object clone() {
        return super.clone();
    }

}
//End DoubleField class

