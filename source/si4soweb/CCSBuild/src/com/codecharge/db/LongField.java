//LongField class @0-0ECB5E94
package com.codecharge.db;

import java.text.*;
import com.codecharge.util.*;

public class LongField extends Field implements Cloneable {
    private Long value;

    /** Create new LongField. */
    public LongField() {}
    
    /** Create new LongField with name. */
    public LongField( String name ) {
        super(name, null);
    }

    /** Create new LongField with name, field and value. */
    public LongField( String name, String field, Object value ) {
        super(name, field);
        setValue(value);
    }

    /** Create new LongField with name, field and value. */
    public LongField( String name, String field, double value ) {
        super(name, field);
        setValue(value);
    }

    /** Create new LongField with name and field. */
    public LongField( String name, String field ) {
        super(name,field);
    }
    
    /** Set field value to null. */
    public void applyDefaultValue() {
        value = null;
    }
    
    /** Get field value.*/
    public Object getObjectValue() {
        return value;
    }

    /** Get field value.*/
    public Long getValue() {
        return value;
    }

    /** Get field value as long.*/
    public long longValue() {
        return value.longValue();
    }

    /** Set field value from Object value.
      @see #setValue(Long)
      @see #setValue(long)
      @see #setValue(Object)
      @see #setValue(Object,Format)
     */
    public void setObjectValue( Object value ) {
        this.setValue(value);
    }

    /** Set field value from Long value.
      @see #setValue(long)
      @see #setValue(Object)
      @see #setValue(Object,Format)
     */
    public void setValue( Long value ) {
        this.value = value;
    }

    /** Set field value from long value.
      @see #setValue(Long)
      @see #setValue(Object)
      @see #setValue(Object,Format)
     */
    public void setValue( long value ) {
        this.value = new Long(value);
    }

    /** Set field value from double value.
      @see #setValue(Long)
      @see #setValue(Object)
      @see #setValue(Object,Format)
     */
    public void setValue( double value ) {
        this.value = new Long((long) value);
    }

    /** Set field value from Object value.
      @see #setValue(Long)
      @see #setValue(long)
      @see #setValue(Object)
      @see #setValue(Object,Format)
     */
    public void setValue( Object value ) {
        if ( value == null || value instanceof Long ) {
            this.value = (Long) value;
        } else if (value instanceof Number) {
            this.value = new Long( ((Number) value).longValue() );
        } else if ( value instanceof String ) {
            if ( "".equals( value ) ) {
                value = null;
            } else {
                this.value = new Long( (String) value );
            }    
        }
    }
    
    /** Set field value, converting Object value with given Format to Long type.
      @param value new parameter value in form of Object
      @param format format used to convert value to Long type
     */
    public void setValue( Object value, Format format ) throws ParseException {
        if ( value == null ) {
            this.value = null;
        } else if ( value instanceof String ) {
            if ( StringUtils.isEmpty( (String) value ) ) {
                this.value = null;
            } else {
                if ( format == null ) {
                    this.value = new Long( (String) value );
                } else {
                    this.value = ((NumericFormat) format).parseLong( (String) value );
                }
            }
        } else if (value instanceof Number) {
            this.value = new Long( ((Number) value).longValue() );
        } else {
            this.value = null;
        }
    }
    
    public Object clone() {
        return super.clone();
    }

}
//End LongField class

