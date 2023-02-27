//List component @0-4F8CD0C8
package com.codecharge.components;

import java.util.*;
import java.text.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.validation.*;
import com.codecharge.db.DbRow;

public class List extends VerifiableControl {
    
    final static public int BOUND_COLUMN = 0;
    final static public int TEXT_COLUMN = 1;
    final static public int SELECTED = 2;

    protected Vector options = new Vector();
    protected Object boundColumn = new Integer(0);
    protected Object textColumn = new Integer(1);
    protected Vector values = new Vector();
    protected Vector defaultValues = new Vector();

    public List(String name, String fieldSource, Page page) {
        super(name, fieldSource, page);
    }

    public List(String name, Page page) {
        super(name, page);
    }

    public Object getBoundColumn() {
        return this.boundColumn;
    }
    public Object getTextColumn() {
        return this.textColumn;
    }

    public void setBoundColumn(String name) {
        boundColumn = name;
    }
    public void setTextColumn(String name) {
        textColumn = name;
    }

    public void setBoundColumn(int column) {
        boundColumn = new Integer(column);
    }
    public void setTextColumn(int column) {
        textColumn = new Integer(column);
    }

    /** Set list of values to choose from. Used to populate list values from String.
     @param list Semicolon separated list of values */
    public void setListOfValues(String list) {
        if ( list == null ) return;
		options.clear();
        Vector result = options;
        Enumeration elms = StringUtils.splitLOV( list );
        Integer bound = new Integer(0);
        Integer text = new Integer(1);
        while (elms.hasMoreElements()) {
            String caption;
            String value = elms.nextElement().toString();
            if (elms.hasMoreElements()) {
                caption = elms.nextElement().toString();
            } else {
                caption = "";
            }
            DbRow ht = new DbRow();
            if ( boundColumn != null ) {
              ht.put(boundColumn, value);
              ht.put(textColumn, caption);
            } else {
              ht.put( bound, value );
              ht.put( text, caption );
            }
            result.add(ht);
        }
    }

    /** Set list of values to choose from. Used to populate list values from String.
     @param list Semicolon separated list of values */
    public void setListOfValues(StringBuffer list) {
    	options.clear();
        if ( list != null ) {
            setListOfValues( list.toString() );
        } 
        return;
    }

	public void clearOptions() {
		options = new Vector();
	}
    
    /** Set list of values to choose from. Used to populate list values from String.
     @param list Semicolon separated list of values */
    public void setOptions(String list) {
        setListOfValues(list);
    }
    
    /** Set list of values to choose from.
     @param opts Enumeration of String values */
    public void setOptions(Enumeration opts) {
		options.clear();
        if ( opts == null ) return;
        while ( opts.hasMoreElements() ) {
            options.add( opts.nextElement() );
        }
    }

    /** Set list of values to choose from. Used to populate list values from a DataBase.
     @param opts Enumeration of values
     @param formatter formatter for the values */
    public void setOptions(Enumeration opts, com.codecharge.db.SqlFormatControl formatter) {
		options.clear();
        if ( opts == null ) return;
        if ( formatter != null && ! (type == ControlType.TEXT || type==ControlType.MEMO)) {
            while ( opts.hasMoreElements() ) {
                com.codecharge.db.DbRow row = (com.codecharge.db.DbRow) opts.nextElement();
                Object val = row.get(boundColumn);
                
				//TODO: convert values in the bound column to type of control
				if (val instanceof Number && type == ControlType.BOOLEAN) {
					//val = val.toString();
					//val = page.getCCSLocale().getNumericFormat("#.##").format(val);
					val = String.valueOf(((Number) val).intValue());
				}

                if (val instanceof String) {
                    try {
                        Object obj = formatter.parse((String) val, this);
                        if ( obj != null ) {
                            if ( obj instanceof java.util.Date ) {
                                obj = new java.util.Date(((java.util.Date) obj).getTime());
                            }
                            row.put(boundColumn, obj);
                        }
                    } catch ( java.text.ParseException pe_ignore ) {
                    }
                } else if (val instanceof java.util.Date) {
                    val = new java.util.Date(((java.util.Date) val).getTime());
                    row.put(boundColumn, val);
                }
                options.add( row );
            }
        } else {
            while ( opts.hasMoreElements() ) {
                options.add( opts.nextElement() );
            }
        }
    }

    /** Get Options list in form of Enumeration of Strings.
        @return options list in form of Enumeration of HashMaps: {{BOUND_COLUMN,TEXT_COLUMN},...} */
    public Enumeration getOptions() {return options.elements();}
    
    /** Prepare list collection for output.
      This method marks those list values that were selected by request.
      @return Enumeration of String arrays in form {BOUND_COLUMN, TEXT_COLUMN, SELECTED} */
    public Enumeration getFormattedOptions() {

        Enumeration enumeration = getOptions();
        Vector formattedOptions = new Vector(options.size());        

        Control val = null;
        Format idFormat = null;
        if ( type == ControlType.FLOAT ) {
            val = new Control("f", page);
            val.setFormat( format );
            val.setType( type );
            val.setDefaultValue( defaultValue );
            idFormat = page.getCCSLocale().getDoubleFormat();
        } else if (type == ControlType.INTEGER) {
            idFormat = page.getCCSLocale().getLongFormat();
        } else if (type == ControlType.BOOLEAN) {
            idFormat = page.getCCSLocale().getBooleanFormat();
        } else if (type == ControlType.DATE) {
            idFormat = page.getCCSLocale().getDateFormat();
        }

        String[] listValues = getFormattedValues();

        String empty = "";
        String selectFlag = "True";
        while ( enumeration.hasMoreElements() ) {
            DbRow row = (DbRow) enumeration.nextElement();
            Object id = row.get( boundColumn );
            Object text = row.get( textColumn );
            String value = empty;
            String caption = empty;
            if ( id == null ) {
                CCLogger.getInstance().debug("List "+getName()+": bound column '"+getBoundColumn()+"' is null");
            } else {
                if ( idFormat == null ) {
                    value = id.toString();
                } else if (id instanceof String && type != ControlType.BOOLEAN) {
                    value = id.toString();
                } else {
                    value = idFormat.format(id);
                }
            }
            if ( text == null ) {
                CCLogger.getInstance().debug("List "+getName()+": text column '"+getTextColumn()+"'is null");
            } else {
                caption = text.toString();
            }
            boolean selected = false;
            for ( int counter = 0; counter < listValues.length; counter++ ) {
                String fv = listValues[counter];
                if ( type != ControlType.FLOAT ) {
                    if ( value.equals(fv) ) {
                        selected = true;
                        break;
                    }
                } else {
                    if (! StringUtils.isEmpty(value)) {
                        try {
                            val.setValueFromRequest( value );
                        } catch ( Exception ignore ) {}
                        if ( val.getFormattedValue() != null && val.getFormattedValue().equals(fv) ) {
                            selected = true;
                            break;
                        }
                    } else if (StringUtils.isEmpty(fv)) {
                        selected = true;
                        break;
                    }
                }
            }

            String[] option = new String[3];
            option[List.BOUND_COLUMN] = toHtml(value);
            option[List.TEXT_COLUMN] = toHtml(caption);
            if ( selected ) {
                option[List.SELECTED] = selectFlag;
            }
            formattedOptions.add(option);
        }
        return formattedOptions.elements();
    }


    public String toHtml( String value ) {
        return StringUtils.toHtml( value );
    }

    /** Get currently selected value or first value if there are many selected values.
      @return currently selected value */
    public Object getValue() {
        if ( values.size() == 0 ) {
            if ( defaultValues.size() == 0 ) {
                return null;
            } else {
                return defaultValues.get(0);
            }
        } else {
            return values.get(0);
        }
    }

    public Object getObjectValue() {
        if ( values.size() == 0 ) {
            return null;
        } else {
            return values.get(0);
        }
    }

    public Enumeration getValues() {
        if ( values.size() == 0 ) {
            defaultValues = new Vector();
            defaultValues.add( defaultValue );
            return defaultValues.elements();
        } else {
            return values.elements();
        }
    }

    protected int getNumberOfValues() {
        if ( this.values.size() == 0 ) {
            return 1;
        } else {
            return values.size();
        }
    }

    public Enumeration getDefaultValues() {
        defaultValues = new Vector();
        defaultValues.add( defaultValue );
        return defaultValues.elements();
    }

    /** Set list selected value.
      @param value New selected value */
    public void setValue( Object value ) {
        this.values = new Vector();
        if ( value == null ) { 
            this.values.add( value );
            this.value = value;
        } else if ( value instanceof Number && type==ControlType.INTEGER ) {
            this.value = new Long(((Number) value).longValue() );
            this.values.add( this.value );
        } else if ( value instanceof Number && type==ControlType.FLOAT) {
            this.value = new Double(((Number) value).doubleValue() );
            this.values.add( this.value );
        } else {
            this.value = value;
            this.values.add( value );
        }
    }

    /** Set list selected value.
      @param value New selected value */
    public void setValue( String value ) {
        if ( value != null && type != ControlType.TEXT && type != ControlType.MEMO ) {
            try {
                setValueFromRequest( value );
            } catch ( ParseException pe_ignore ) {}
        } else {
            this.values = new Vector();
            this.values.add( value );
            this.value = value;
        }
    }

    /** Set list selected value.
      @param value New selected value */
    public void setValue( long value ) {
        this.values = new Vector();
        if ( type == ControlType.FLOAT ) {
            this.value = new Double( value );
            this.values.add( this.value );
        } else {
            this.value = new Long( value );
            this.values.add( this.value );
        }
    }

    /** Set list selected value.
      @param value New selected value */
    public void setValue( double value ) {
        this.values = new Vector();
        if ( type == ControlType.INTEGER ) {
            this.value = new Long( (long) value );
            this.values.add( this.value );
        } else {
            this.value = new Double( value );
            this.values.add( this.value );
        }
    }

    /** Set list selected value.
      @param value New selected value */
    public void setValue( boolean value ) {
        this.values = new Vector();
        this.value = new Boolean( value );
        this.values.add( this.value );
    }

    /** For Multiselect lists add value to selected values list.
        @param value Value to add to selected values list */
    public void addValue( Object value ) {
        if ( value == null ) { 
            this.values.add( value );
        } else if ( value instanceof Number && type==ControlType.INTEGER ) {
            this.values.add( new Long(((Number) value).longValue() ) );
        } else if ( value instanceof Number && type==ControlType.FLOAT) {
            this.values.add( new Double(((Number) value).doubleValue() ) );
        } else {
            this.values.add( value );
        }
    }

    /** For Multiselect lists add value to selected values list.
        @param value Value to add to selected values list */
    public void addValue( String value ) {
        if ( value != null && type != ControlType.TEXT && type != ControlType.MEMO ) {
            try {
                addValueFromRequest( value );
            } catch ( ParseException pe_ignore ) {}
        } else {
            this.values.add( value );
        }
    }

    /** For Multiselect lists add value to selected values list.
        @param value Value to add to selected values list */
    public void addValue( long value ) {
        if ( type == ControlType.FLOAT ) {
            this.values.add( new Double( value ) );
        } else {
            this.values.add( new Long( value ) );
        }
    }

    /** For Multiselect lists add value to selected values list.
        @param value Value to add to selected values list */
    public void addValue( double value ) {
        if ( type == ControlType.INTEGER ) {
            this.values.add( new Long( (long) value ) );
        } else {
            this.values.add( new Double( value ) );
        }
    }

    /** For Multiselect lists add value to selected values list.
        @param value Value to add to selected values list */
    public void addValue( boolean value ) {
        this.values.add( new Boolean( value ) );
    }

    /** Set list selected values from Enumeration of Strings.
        @param records Enumeration of DbRows returned from SQl query
        @param fieldName Which field holds the values */
    public void setValues( Enumeration records, String fieldName ) {
        this.values = new Vector();
        if ( records != null ) {
            if ( records.hasMoreElements() ) {
                DbRow record = (DbRow) records.nextElement();
                setValue( record.get( fieldName ) );
            }
            while ( records.hasMoreElements() ) {
                DbRow record = (DbRow) records.nextElement();
                addValue( record.get( fieldName ) );
            }
        }
    }

	/** Set list selected values from Enumeration of Strings.
		@param records Enumeration of DbRows returned from SQl query
    */
	public void setValues( Enumeration records ) {
		this.values = new Vector();
		Integer key = new Integer(0);
		if ( records != null ) {
			if ( records.hasMoreElements() ) {
				DbRow record = (DbRow) records.nextElement();
				setValue( record.get(key) );
			}
			while ( records.hasMoreElements() ) {
				DbRow record = (DbRow) records.nextElement();
				addValue( record.get(key) );
			}
		}
	}

    public void setValuesFromRequest(String[] values) throws ParseException {
        if ( values != null && values.length > 0 ) {
            setValueFromRequest( values[0] );
            for ( int i = 1; i < values.length; i++ ) {
                addValueFromRequest( values[i] );
            }
        }
    }

    public void setValueFromDb(Object value) {
        this.values = new Vector();
        if (value instanceof java.lang.String && dbFormat != null) {
            try {
                this.value = dbFormat.parseObject((String)value);
                this.values.add( this.value );
            } catch (ParseException pe) {
                this.value = value;
                this.values.add( value );
            }
        } else {
            this.value = value;
            this.values.add( value );
        }
        this.preformatted = false;
    }

    public void setValueFromRequest(String value) throws ParseException {
        this.values = new Vector();
        if ( value == null || value.length() == 0 ) return;
        try {
            if ( ! StringUtils.isEmpty(formatPattern) && !(type==ControlType.TEXT || type==ControlType.MEMO) ) {
                Format fmt = page.getCCSLocale().getFormat(type, formatPattern);
                this.value = fmt.parseObject( value );
                this.values.add( this.value );
            } else if ( StringUtils.isEmpty(formatPattern) && !(type==ControlType.TEXT || type==ControlType.MEMO) ) {
                Format fmt = page.getCCSLocale().getFormat(type);
                this.value = fmt.parseObject( value );
                this.values.add( this.value );
            } else {
                this.value = value;
                this.values.add( this.value );
            }
        } catch (ParseException pe) {
            this.value = value;
            this.values.add( this.value );
            throw new ParseException("Unable parse '"+value+"'",0);
        } catch (NumberFormatException pe) {
            this.value = value;
            this.values.add( this.value );
            throw new ParseException("Unable parse '"+value+"'",0);
        }
    }

    public void addValueFromRequest( String value ) throws ParseException {
        if ( value == null || value.length() == 0 ) return;
        try {
            if ( ! StringUtils.isEmpty(formatPattern) && !(type==ControlType.TEXT || type==ControlType.MEMO) ) {
                Format fmt = page.getCCSLocale().getFormat(type, formatPattern);
                this.values.add( fmt.parseObject( value ) );
            } else if ( StringUtils.isEmpty(formatPattern) && !(type==ControlType.TEXT || type==ControlType.MEMO) ) {
                Format fmt = page.getCCSLocale().getFormat(type);
                this.values.add( fmt.parseObject( value ));
            } else {
                this.values.add( value );
            }
        } catch (ParseException pe) {
            this.values.add( value );
            throw new ParseException("Unable parse '"+value+"'",0);
        } catch (NumberFormatException pe) {
            this.values.add( value );
            throw new ParseException("Unable parse '"+value+"'",0);
        }
    }

    /** Get selected values formatted with control (or default) formats.
        @return formatted selected values in form of Array of Strings */
    public String[] getFormattedValues() {
        String[] formattedValues = null;
        if ( ! eventRunning ) {
            Enumeration listValues = getValues();
            formattedValues = new String[getNumberOfValues()];
            int counter = 0;
            while ( listValues.hasMoreElements() ) {
                Object v = listValues.nextElement();
                Format fmt = page.getCCSLocale().getFormat(type, formatPattern);
                String result;
                if ( fmt != null && type != ControlType.DATE && !( hasErrorByType( ControlErrorTypes.getErrorType( ControlErrorTypes.FORMAT_ERROR ) ))) {
                   result = fmt.format( v );
                } else if ( v == null ) {
                   result = "";
                } else if ( fmt != null && type == ControlType.DATE && !( hasErrorByType( ControlErrorTypes.getErrorType( ControlErrorTypes.FORMAT_ERROR ) ))) {
                   result = fmt.format( v );
                } else {
                   result = v.toString();
                }
                result = toHtml( result );
                formattedValue = result;
                formattedValues[counter++] = formattedValue;
            }
        }
        preformatted = true;
        return formattedValues;
    }
    
    /** Obtaine string representation of control value. */
    public String toString() {
      StringBuffer result = new StringBuffer();
      Enumeration listValues = getValues();
      int counter = 0;
      while ( listValues.hasMoreElements() ) {
          Object v = listValues.nextElement();
          Format fmt = page.getCCSLocale().getFormat(type, formatPattern);
          String fmtValue = null;
          if ( fmt != null && type != ControlType.DATE && !( hasErrorByType( ControlErrorTypes.getErrorType( ControlErrorTypes.FORMAT_ERROR ) ))) {
             fmtValue = fmt.format( v );
          } else if ( v == null ) {
          } else if ( fmt != null && type == ControlType.DATE && !( hasErrorByType( ControlErrorTypes.getErrorType( ControlErrorTypes.FORMAT_ERROR ) ))) {
             fmtValue = fmt.format( v );
          } else {
             fmtValue = v.toString();
          }
          if ( ! StringUtils.isEmpty(fmtValue) ) {
            if ( result.length() > 0 ) result.append(", ");
            result.append(fmtValue);
          }
      }
      return result.toString();
    }

    public void fireBeforeBuildSelectEvent(DataObjectEvent e) {
        Vector l;
        e.setSource(this);
        synchronized(this) {l = (Vector)listeners.clone();}
        for (int i=0; i<l.size(); i++) {
            if ( l.elementAt(i) instanceof ListDataObjectListener ) {
                ((ListDataObjectListener)l.elementAt(i)).beforeBuildSelect(e);
            }
        }
    }
    public void fireBeforeExecuteSelectEvent(DataObjectEvent e) {
        Vector l;
        e.setSource(this);
        synchronized(this) {l = (Vector)listeners.clone();}
        for (int i=0; i<l.size(); i++) {
            if ( l.elementAt(i) instanceof ListDataObjectListener ) {
                ((ListDataObjectListener)l.elementAt(i)).beforeExecuteSelect(e);
            }
        }
    }
    public void fireAfterExecuteSelectEvent(DataObjectEvent e) {
        Vector l;
        e.setSource(this);
        synchronized(this) {l = (Vector)listeners.clone();}
        for (int i=0; i<l.size(); i++) {
            if ( l.elementAt(i) instanceof ListDataObjectListener ) {
                ((ListDataObjectListener)l.elementAt(i)).afterExecuteSelect(e);
            }
        }
    }
    
}
//End List component

