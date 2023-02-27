//DateField class @0-1C7C96E9
package com.codecharge.db;

import java.util.*;
import java.text.*;
import com.codecharge.util.*;

public class DateField extends Field implements Cloneable {
    private Date value;

    public DateField() {}
    
    public DateField( String name ) {
        super(name, null);
    }

    public DateField( String name, String field ) {
        super(name,field);
    }
    
    public void applyDefaultValue() {
        value = null;
    }
    
    public Object getObjectValue() {
        return value;
    }

    public void setObjectValue( Object value ) {
        setValue(value);
    }

    public Date getValue() {
        return value;
    }

    public void setValue( Date value ) {
        this.value = value;
    }

    public void setValue( Object value ) {
        if ( value == null || value instanceof Date ) {
            this.value = (Date) value;
        } else if ( value instanceof Number ) {
            this.value = new Date( ((Number) value).longValue() );
        } else {
            System.out.println("Unsupported Date type: " + value.getClass().getName() ); 
        }
    }

    /** Set parameter value, converting Object value with given Format to Date type.
      @param value new parameter value in form of Object
      @param format format used to convert value to the Date type
     */
    public void setValue( Object value, Format format ) throws ParseException {
        if ( value == null ) {
            this.value = null;
        } else if ( value instanceof String ) {
            if ( StringUtils.isEmpty( (String) value ) ) {
                this.value = null;
            } else {
                if ( format == null ) {
                    this.value = (new SimpleDateFormat()).parse( (String) value );
                } else {
                    this.value = (Date) format.parseObject( (String) value );
                }
            }
        } else if ( value instanceof Date ) {
            this.value = (Date) value;
        } else if ( value instanceof Number ) {
            this.value = new Date( ((Number) value).longValue() );
        } else {
            this.value = null;
        }
    }

    public Object clone() {
        return super.clone();
    }

}
//End DateField class

