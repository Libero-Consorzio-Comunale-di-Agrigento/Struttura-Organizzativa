//Control component @0-674F7DCA
package com.codecharge.components;

import java.util.*;
import java.text.Format;
import java.text.DateFormat;
import java.text.ParseException;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.validation.*;

/**
 * Control class represents serverside control.
 * Its main feature is binding with DataBase fields, which allows to show data from DataBase on Web page
 * and to store user input to DataBase if the control is a child of Data aware container
 * such as Grid, Record, EditableGrid, Directory or Path. Other features include:
 * <ul>
 *  <li>Value population from request. Parameters from request automatically get into control values.
 *  <li>Control default values. They take into accout when control value is null.
 *  <li>Output formatting with format property. Predefined and custom patterns for numbers, dates, booleans.
 *  <li>Type mapping to DB types with db format property. When control type is different from DB field type.
 * </ul>
 */
public class Control extends Model implements ReadOnlyControl, com.codecharge.db.Parameter, Cloneable {

    /** Control value. */
    protected Object value;
    /** Control default value. */
    protected Object defaultValue;
    /** DB field this control binds to. */
    protected String fieldSource;
    /** Control caption used in validation error messege. */
    protected String caption;
    /** @deprecated */
    protected Format dbFormat; // deprecated
    /** @deprecated */
    protected Format format;   // deprecated
    /** Control type as it is indicated in CCS. */
    protected ControlType type;
    /** Should we encode control value to html. */
    protected boolean htmlEncode;
    /** Format pattern used to send and receive data from user (client side). */
    protected String formatPattern;
    /** Format pattern used to send and receive data from DB. */
    protected String dbFormatPattern;
    /** Page model for this control. */
    protected Page page;
    /** Errors collection. */
    protected ControlError errors;

    /** Create new Control object with name, fieldSource and page.
      @param name Control name
      @param fieldSource DB field this control binds to
      @param page Page model
     */
    public Control( String name, String fieldSource, Page page ) {
      super( name );
      this.fieldSource = fieldSource;
      htmlEncode = false;
      this.page = page;
    }

    /** Create new Control object with name and parent page.
      @param name Control name
      @param page Page model
     */
    public Control( String name, Page page ) {
      super( name );
      this.page = page;
    }

    /** Get control value as Object. */
    public Object getObjectValue() {
        return value;
    }

    /** Set control value from Object. */
    public void setObjectValue( Object value ) {
        this.value = formControlValue( value );
    }

    /** Set parameter value to default value. */
    public void applyDefaultValue() {
        this.value = this.defaultValue;
    }

    /** Get the page that contains this control. */
    public Page getPage() { return page; }
    /** Set page that contains this control. */
    public void setPage( Page page ) { this.page = page; }

    /** Get DataBase field name that is used to populate this control with data. */
    public String getFieldSource() { return fieldSource; }
    /** Set DataBase field name that is used to populate this control with data. */
    public void setFieldSource( String fsource ) { fieldSource = fsource; }

    /** Whether to encode control value before it is showen (so that html tags it may contain will be shown as is). */
    public boolean isHtmlEncode() { return htmlEncode; }
    /** Set whether to encode control value before it is showen (so that html tags it may contain will be shown as is). */
    public void setHtmlEncode( boolean htmlEncode ) { this.htmlEncode = htmlEncode; }

    /** Get control caption used in validation messages. */
    public String getCaption() {
      return ( StringUtils.isEmpty(caption) ? name : caption );
    }
    /** Set control caption used in validate messages. */
    public void setCaption( String caption ) { this.caption = caption; }

    /** Get type of the control value. */
    public ControlType getType() {
      return type;
    }
    /** Set type of the control value. */
    public void setType( ControlType type ) { this.type = type; }

    /** @deprecated Replaced by {@link #setDbFormatPattern}. */
    public void setDbFormat( Format dbFormat ) {
      this.dbFormat = dbFormat;
    }
    /** @deprecated Replaced by {@link #setDbFormatPattern}. */
    public void setDbFormat( Format dbFormat, String formatPattern ) {
      this.dbFormat = dbFormat;
    }

    /** @deprecated Replaced by {@link #getDbFormatPattern}. */
    public Format getDbFormat() {
      return dbFormat;
    }

    /** @deprecated Replaced by {@link #getFormatPattern}. */
    public Format getFormat() {
      return format;
    }

    /** Get format pattern used to convert control value from String to control type. */
    public String getFormatPattern() {
        String fPattern = formatPattern;
        return fPattern;
    }

    /** Set format pattern used to convert control value from String to control type. */
    public void setFormatPattern( String formatPattern ) {
        this.formatPattern = formatPattern;
    }

    /** Get format pattern used to convert control value to DataBase format. */
    public String getDbFormatPattern() {
        String fPattern = formatPattern;
        return fPattern;
    }

    /** Set format pattern used to convert control value to DataBase format. */
    public void setDbFormatPattern( String dbFormatPattern ) {
        this.dbFormatPattern = dbFormatPattern;
    }

    /** @deprecated Replaced by {@link #setFormatPattern}. */
    public void setFormat( Format format ) {
      this.format = format;
    }

    /** @deprecated Replaced by {@link #setFormatPattern}. */
    public void setFormat( Format format, String formatPattern ) {
      this.format = format;
      this.formatPattern = formatPattern;
    }

    /** Auxiliary function to convert control value from Object to type corresponding with CCS control type. */
    private Object formControlValue( Object value ) {
        Object result = null;
        if ( value == null ) {
            result = value;
        } else if ( type == ControlType.INTEGER && (value instanceof Number) ) {
            result = new Long( ((Number) value).longValue() );
        } else if ( type == ControlType.FLOAT && (value instanceof Number) ) {
            result = new Double( ((Number) value).doubleValue() );
        } else {
            result = value;
        }
        return result;
    }

    /** Auxiliary function to convert control value from String to type corresponding
      with CCS control type using given format. */
    public Object formControlValue(String value, String fmtPattern) throws ParseException {
        Object result = null;
        if ( value == null || value.length() == 0 ) return result;
        try {
            if ( ! StringUtils.isEmpty(fmtPattern)) {
                if ( type == ControlType.INTEGER ) {
                    NumericFormat fmt = page.getCCSLocale().getNumericFormat(fmtPattern);
                    result = fmt.parseLong(value);
                } else if ( type == ControlType.FLOAT ) {
                    NumericFormat fmt = page.getCCSLocale().getNumericFormat(fmtPattern);
                    result = fmt.parseDouble(value);
                } else if ( type == ControlType.DATE ) {
                    DateFormat fmt = page.getCCSLocale().getDateFormat(fmtPattern);
                    result = fmt.parseObject(value);
                    String checkValue = fmt.format(result);
                    if (! checkValue.equals(value)) {
                    	throw new ParseException(value, 0);
                    }
                } else if ( type == ControlType.BOOLEAN ) {
                    BooleanFormat fmt = page.getCCSLocale().getBooleanFormat(fmtPattern);
                    result = fmt.parseObject(value);
                } else {
                    result = value;
                }
            } else if ( type == ControlType.DATE ) {
                DateFormat fmt = page.getCCSLocale().getDateFormat();
                result = fmt.parseObject( value );
				String checkValue = fmt.format(result);
				if (! checkValue.equals(value)) {
					throw new ParseException(value, 0);
				}
            } else if ( type == ControlType.INTEGER ) {
                NumericFormat fmt = page.getCCSLocale().getLongFormat();
                result = fmt.parseLong( value );
            } else if ( type == ControlType.FLOAT ) {
                NumericFormat fmt = page.getCCSLocale().getDoubleFormat();
                result = fmt.parseDouble(value);
            } else if ( type == ControlType.BOOLEAN ) {
                BooleanFormat fmt = page.getCCSLocale().getBooleanFormat();
                result = fmt.parseObject(value);
            } else {
                result = value;
            }
        } catch (ParseException pe) {
            result = value;
            throw new ParseException("Unable to parse '"+value+"'",0);
        } catch (NumberFormatException pe) {
            result = value;
            throw new ParseException("Unable to parse '"+value+"'",0);
        }
        return result;
    }

    /** Auxiliary function to convert control value from long to type corresponding with CCS control type. */
    public Object formControlValue( long value ) {
        Object result = null;
        if ( type == ControlType.INTEGER ) {
            result = new Long( value );
        } else if ( type == ControlType.FLOAT ) {
            result = new Double( value );
        } else if ( type == ControlType.DATE ) {
            result = new Date( value );
        } else {
            result = String.valueOf( value );
        }
        return result;
    }

    /** Auxiliary function to convert control value from double to type corresponding with CCS control type. */
    public Object formControlValue( double value ) {
        Object result = null;
        if ( type == ControlType.INTEGER ) {
            result = new Long( (long) value );
        } else if ( type == ControlType.FLOAT ) {
            result = new Double( value );
        } else if ( type == ControlType.DATE ) {
            result = new Date( (long) value );
        } else {
            result = String.valueOf( value );
        }
        return result;
    }

    /** Auxiliary function to convert control value from boolean to CCS Boolean type. */
    public Object formControlValue( boolean value ) {
        Object result = null;
        result = new Boolean( value );
        return result;
    }

    /** This method sets the value for the control.
       @param value Value to assign to the control */
    public void setValue( Object value ) {
        this.value = formControlValue(value);
        this.preformatted = false;
    }

    /** Sets the value for the control. */
    public void setValue( String value ) {
        if ( value != null && type != ControlType.TEXT && type != ControlType.MEMO ) {
            try {
                this.value = formControlValue(value, formatPattern);
            } catch ( ParseException pe ) {
                CCLogger.getInstance().debug("Control: "+name+" Unable to parse value: "+value, pe);
            }
        } else {
            this.value = value;
            this.preformatted = false;
        }
    }

    /** Sets the value for the control. */
    public void setValue( long value ) {
        this.value = formControlValue( value );
        this.preformatted = false;
    }

    /** Sets the value for the control. */
    public void setValue( double value ) {
        this.value = formControlValue(value);
        this.preformatted = false;
    }

    /** Sets the value for the control. */
    public void setValue( boolean value ) {
        this.value = formControlValue(value);
        this.preformatted = false;
    }

    /** Set control default value from Object. */
    public void setDefaultValue( Object value ) {
        this.defaultValue = formControlValue(value);
        this.preformatted = false;
    }

    /** Set control default value from String. */
    public void setDefaultValue( String value ) {
        if ( value != null && type != ControlType.TEXT && type != ControlType.MEMO ) {
            try {
                this.defaultValue = formControlValue(value, formatPattern);
            } catch ( ParseException pe ) {
                CCLogger.getInstance().debug("Control: "+name+" Unable to parse value: "+value, pe);
            }
        } else {
            this.defaultValue = value;
            this.preformatted = false;
        }
    }

    /** Set control default value from long value. */
    public void setDefaultValue( long value ) {
        this.defaultValue = formControlValue(value);
        this.preformatted = false;
    }

    /** Set control default value from double value. */
    public void setDefaultValue( double value ) {
        this.defaultValue = formControlValue(value);
        this.preformatted = false;
    }

    /** Set control default value from boolean value. */
    public void setDefaultValue( boolean value ) {
        this.defaultValue = formControlValue(value);
        this.preformatted = false;
    }

    /** Get control default value. */
    public Object getDefaultValue() {
        return this.defaultValue;
    }

    /** Set control value from Object received from DataBase with help of db format. */
    public void setValueFromDb(Object value, Format defaultFormat) {
      if (!StringUtils.isEmpty(dbFormatPattern)) {
        try {
          Format fmt = page.getCCSLocale().getFormat(type, dbFormatPattern);
          if (value == null) {
            this.value = fmt.parseObject(null);
          } else {
            this.value = fmt.parseObject(value.toString());
          }
        } catch (ParseException pe) {
          setValue(value);
        }
      } else if (defaultFormat != null) {
        try {
          if (value == null) {
            this.value = defaultFormat.parseObject(null);
          } else {
            this.value = defaultFormat.parseObject(value.toString());
          }
        } catch (ParseException pe) {
          setValue(value);
        }
      } else {
        setValue(value);
      }
      this.preformatted = false;
    }

    /** Set control value from Object received from DataBase with help of db format.
    @deprecated Use {@link #setValueFromDb(Object,Format)} instead. */
    public void setValueFromDb(Object value) {
      if (!StringUtils.isEmpty(dbFormatPattern)) {
        try {
          Format fmt = page.getCCSLocale().getFormat(type, dbFormatPattern);
          if (value == null) {
            this.value = fmt.parseObject(null);
          } else {
            this.value = fmt.parseObject(value.toString());
          }
        } catch (ParseException pe) {
          setValue(value);
        }
      } else {
        setValue(value);
      }
      this.preformatted = false;
    }
    /** Set control value from String received from DataBase with help of db format.
      @deprecated Replaced by {@link #setValueFromDb(Object)}. */
    public void setValueFromDb(String value) {
        try {
            this.value = formControlValue( value, dbFormatPattern );
        } catch ( ParseException pe ) {
            CCLogger.getInstance().debug("Control: "+name+" Unable to parse dbValue:", pe);
        }
        this.preformatted = false;
    }

    /** Stores all string values as control values. Used in multiselect ListBox and CheckBoxList controls. */
    public void setValuesFromRequest(String[] values) throws ParseException {
        if ( values != null && values.length > 0 ) {
            setValueFromRequest( values[0] );
        }
    }

    /** Set control value from String received from HTTP query (format is used if set). */
    public void setValueFromRequest(String value) throws ParseException {
        try {
            this.value = formControlValue( value, formatPattern );
            this.preformatted = false;
        } catch (ParseException pe) {
            setFormattedValue(value);
            throw new ParseException("Unable to parse '"+value+"'",0);
        }
    }

    /** Retrieves the value of the control. This is the Object value of the control, when format was not applied yet.
      @return not formatted control value */
    public Object getValue() {
      if (value == null) {
         return defaultValue;
      } else {
         return value;
      }
    }

    protected String formattedValue = "";
    protected boolean preformatted = false;
    protected boolean eventRunning = false;

    /** Set the control value from String. Value is taken as is, formatting will not be applied to this value.
      @param value preformatted control value */
    public void setFormattedValue(String value) {
      this.formattedValue = value;
      preformatted = true;
    }

    /** Compare two controls by its value. */
    public boolean equals(Object obj) {
        boolean isEquals = false;
        if ( obj instanceof Control ) {
            Control c = (Control) obj;
            if ( type == c.getType() ) {
                if ( getValue() == null && c.getValue() == null ) {
                    isEquals = true;
                } else if ( getValue() != null && c.getValue() != null ) {
                    isEquals = getValue().equals( c.getValue() );
                }
            }
        }
        return isEquals;
    }

    /** Get the value formatted according to the control format.
      @return formatted control value */
    public String getFormattedValue() {
      if (preformatted) {
        return toHtml(formattedValue);
      } else {
        String result = "";
        Object v = value;
        if ( value == null || (value instanceof String && ((String)value).length()==0) ) {
          if (defaultValue != null) {
            v = defaultValue;
          }
        }
        Format fmt = page.getCCSLocale().getFormat(type, formatPattern);
        if (v instanceof String) {
          result = (String)v;
        } else if ( fmt != null && type != ControlType.DATE && !( hasErrorByType( ControlErrorTypes.getErrorType( ControlErrorTypes.FORMAT_ERROR ) ))) {
           result = fmt.format( v );
        } else if ( v == null) {
          result = "";
        } else if ( fmt != null && type == ControlType.DATE && !( hasErrorByType( ControlErrorTypes.getErrorType( ControlErrorTypes.FORMAT_ERROR ) ))) {
          if (v instanceof java.util.Date) {
            result = fmt.format( v );
          }
        } else {
           result = v.toString();
        }
        result = toHtml(result);
        return result;
      }
    }

    /** Convert control value to ready for html format, depending on htmlEncode property. */
    protected String toHtml( String value ) {
      if ( isHtmlEncode() ) {
         value =  StringUtils.toHtml( value );
      }
      return value;
    }

    /** Obtaine string representation of control value. */
    public String toString() {
      String result = "";
      Object v = value;
      if ( v == null || (v instanceof String && ((String)v).length()==0) ) {
        if (defaultValue == null) {
          return result;
        } else {
          v = defaultValue;
        }
      }
      Format fmt = page.getCCSLocale().getFormat(type, formatPattern);
      if ( fmt != null && type != ControlType.DATE && !( hasErrorByType( ControlErrorTypes.getErrorType( ControlErrorTypes.FORMAT_ERROR ) ))) {
         result = fmt.format( v );
      } else if ( v == null ) {
         result = "";
      } else if ( fmt != null && type == ControlType.DATE && !( hasErrorByType( ControlErrorTypes.getErrorType( ControlErrorTypes.FORMAT_ERROR ) ))) {
         result = fmt.format( v );
      } else {
         result = v.toString();
      }
      return result;
    }

    /** Whether the control has (validation) errors.
      @return validation state, true means there were errors */
    public boolean hasErrors() {
      return (errors != null);
    }

    /** Whether control has particular error. */
    public boolean hasErrorByType( ControlErrorType type ) {
        if ( errors == null )
            return false;
        return errors.hasByType( type );
    }

    /** Add error description to errors collection.
      @param error Error description */
    public void addError( String error ) {
      if ( error == null || error.length() == 0 ) return;
      if ( errors == null ) errors = new ControlError();
      errors.add( error );
    }

    /** Add error of given type to errors collection.
      @param type Error type
      @param error Error description */
    public void addError( ControlErrorType type, String error ) {
      if ( error == null || error.length() == 0 ) return;
      if ( errors == null ) errors = new ControlError();
      errors.add( type, error );
    }

    /** Remove error of given type from errors collection. */
    public void removeErrorByType( ControlErrorType type ) {
      if ( errors == null ) return;
      errors.removeByType( type.getType() );
    }

    /** Get all errors as Enumeration. */
    public Enumeration getErrors() {
      return errors==null ? new ControlError().getControlErrorStrings() : errors.getControlErrorStrings();
    }

    /** Get all errors formatted as String, each error starts on new line.
      @return errors description */
    public String getErrorsAsString() {
      if ( ! hasErrors() ) return "";
      StringBuffer sb = new StringBuffer();
      Enumeration errs = getErrors();
      ErrorFormatter errorFormatter = ErrorFormatter.getInstance();
      while ( errs.hasMoreElements() ) {
        sb.append( errorFormatter.formatLine((String) errs.nextElement()) );
      }
      return sb.toString();
    }

    /** Add Event handler. */
    public synchronized void addControlListener (ControlListener listener) {
        listeners.addElement(listener);
    }
    /** Remove Event handler. */
    public synchronized void removeControlListener (ControlListener listener) {
        listeners.removeElement(listener);
    }
    /** Call Event handler that works out BeforeShow event.
      @param e Event object that will be available to Event handler. */
    public void fireBeforeShowEvent(Event e) {
        Vector l;
        e.setSource(this);
        synchronized(this) {l = (Vector)listeners.clone();}
        for (int i=0; i<l.size(); i++) {
            ((ControlListener)l.elementAt(i)).beforeShow(e);
        }
        setBeforeShow(true);
    }

    /** Copy control. */
    public Object clone() {
        Object obj = null;
        try {
            obj = super.clone();
        } catch (CloneNotSupportedException cnse_ignore) {}
        return obj;
    }

}
//End Control component

