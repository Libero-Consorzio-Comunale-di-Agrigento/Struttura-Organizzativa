//CheckBox component @0-AD2F8A14
package com.codecharge.components;

import java.text.ParseException;

/** CheckBox represents control with checked and unchecked states.
  * You can associate any values of any type with checked and unchecked states.
  * But make sure that checked and unchecked value types correspond with
  * control type.
  */
public class CheckBox extends VerifiableControl {

    private Object checkedValue;
    private Object uncheckedValue;

    /** Create new ChekcBox with name, associated DB field, with page. */
    public CheckBox(String name, String fieldSource, Page page) {
        super(name, fieldSource, page);
    }

    /** Create new CheckBox with name and page. */
    public CheckBox(String name, Page page) {
        super( name, page );
    }

    /** Get value associated with checked state. */
    public Object getCheckedValue() {
        return checkedValue;
    }

    /** Set value associated with checked state from String. */
    public void setCheckedValue( String checkedValue ) {
      try {
        this.checkedValue = formControlValue(checkedValue, "");
      } catch (ParseException pe) {
        this.checkedValue = checkedValue;
      }
    }

    /** Set value associated with checked state from Object. */
    public void setCheckedValue( Object checkedValue ) {
        this.checkedValue = checkedValue;
    }

    /** Set value associated with checked state from boolean value. */
    public void setCheckedValue( boolean checkedValue ) {
        this.checkedValue = new Boolean( checkedValue );
    }

    /** Set value associated with checked state from long value. */
    public void setCheckedValue( long checkedValue ) {
        this.checkedValue = new Long( checkedValue );
    }

    /** Set value associated with checked state from double value. */
    public void setCheckedValue( double checkedValue ) {
        this.checkedValue = new Double( checkedValue );
    }

    /** Get value associated with unchecked state. */
    public Object getUncheckedValue() {
        return uncheckedValue;
    }

    /** Associate value with unchecked state from String. */
    public void setUncheckedValue( String uncheckedValue ) {
      try {
        this.uncheckedValue = formControlValue(uncheckedValue, "");
      } catch (ParseException pe) {
        this.uncheckedValue = uncheckedValue;
      }
    }

    /** Associate value with unchecked state from Object. */
    public void setUncheckedValue( Object uncheckedValue ) {
        this.uncheckedValue = uncheckedValue;
        //if (value == null) value = this.uncheckedValue;
    }

    /** Associate value with unchecked state from boolean value. */
    public void setUncheckedValue( boolean uncheckedValue ) {
        this.uncheckedValue = new Boolean( uncheckedValue );
        //if (value == null) value = this.uncheckedValue;
    }

    /** Associate value with unchecked state from long value. */
    public void setUncheckedValue( long uncheckedValue ) {
        this.uncheckedValue = new Long( uncheckedValue );
        //if (value == null) value = this.uncheckedValue;
    }

    /** Associate value with unchecked state from double value. */
    public void setUncheckedValue( double uncheckedValue ) {
        this.uncheckedValue = new Double( uncheckedValue );
        //if (value == null) value = this.uncheckedValue;
    }

    private String formattedValue = "";
    private boolean preformatted = false;
    /** Set CheckBox value, disabling formatting, so that getFormattedValue will return this value. */
    public void setFormattedValue(String value) {
      this.formattedValue = value;
      preformatted = true;
    }

    /** Get CheckBox state to show in INPUT checked attribute.
     *  @return empty string if CheckBox in unchecked state, "CHECKED" otherwise. */
    public String getFormattedValue() {
      if (preformatted) {
        return formattedValue;
      } else {
        String result = "";
        Object v = getValue(); // if null use Default value
        if ( v != null && v.toString().equals( checkedValue.toString() )) {
          result = "CHECKED";
        } else if ( type == ControlType.FLOAT && ( (v instanceof Number) && ( checkedValue instanceof Number ) ) ) {
            double val = new Double( v.toString() ).doubleValue();
            double cval = new Double( checkedValue.toString() ).doubleValue();
            if ( val == cval ) {
                result = "CHECKED";
            }
        }
        formattedValue = result;
        return formattedValue;
      }
    }

    /** Set CheckBox value from string, as it comes from request. */
    public void setValueFromRequest(String value) throws ParseException {
      if ( value != null ) this.value = checkedValue;
    }

    /** Get CheckBox value ready for DB insert/update. */
    public Object getDbFormattedValue() {
        Object result = value;
        if (result == null) {
          result = uncheckedValue;
        }
        return result;
    }

    /** Get CheckBox value. If current value is null return defaultValue.
        If defaultValue either is null return uncheckedValue. */
    public Object getValue() {
      Object result = value;
      if (result == null) {
        result = defaultValue;
      }
      if (result == null) {
        result = uncheckedValue;
      }
      return result;
    }

}
//End CheckBox component

