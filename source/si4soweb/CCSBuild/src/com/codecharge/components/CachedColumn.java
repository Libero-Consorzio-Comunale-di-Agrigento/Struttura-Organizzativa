//CachedColumn class @0-E71F8343
package com.codecharge.components;
      
import java.util.*;
import com.codecharge.util.*;
import com.codecharge.db.*;
      
public class CachedColumn implements Cloneable, ReadOnlyField {
    private String name;
    private String alias;
    private Object value;
    private ControlType type;
    private CCSLocale locale;
    
    public CachedColumn(String name, String alias, ControlType type, CCSLocale locale) {
        this.name = name;
        this.alias = alias;
        this.type = type;
        this.locale = locale;
    }
    
    public CachedColumn(String name, ControlType type, CCSLocale locale) {
        this(name, name, type, locale);
    }
    
    public Object getObjectValue() {
        return getValue();
    }
    public void setObjectValue(Object value) {
        setValue(value);
    }
    public String getDbFormatPattern() {
        return null;
    }
    public java.text.Format getDbFormat(){
        return null;
    }
    public java.text.Format getFormat(){
        return null;
    }
    public void setDbFormat(java.text.Format format){}
    public void applyDefaultValue(){}
    
    
    public String getName() {
        return name;
    }
    public String getField() {
        return name;
    }
    public String getAlias() {
        return alias;
    }
    public void setAlias(String alias) {
        this.alias = alias;
    }
    public ControlType getType() {
        return type;
    }
    public CCSLocale getCCSLocale() {
        return locale;
    }
    
    public Object getValue() {
        return value;
    }
    
    public String getFormattedValue() {
        String result = null;
        if (type==ControlType.TEXT || type==ControlType.MEMO) {
            if (value!=null) {
                result = (String) value;
            } else {
                result = "";
            }
        } else if (type!=ControlType.DATE) {
            result = locale.getFormat(type).format(value);
        } else if (value==null) {
            result = "";
        } else if (type==ControlType.DATE) {
            result = locale.getFormat(type).format(value);
        }
        return result;
    }
    
    public void setValue(boolean value) {
        if (type==ControlType.BOOLEAN) {
            this.value = new Boolean(value);
        } else if (type==ControlType.TEXT || type==ControlType.MEMO) {
            this.value = locale.getBooleanFormat().format(new Boolean(value));
        } else {
            throw new IllegalArgumentException(
                    "CachedColumn.setValue(boolean value): type mismatch (column name: "+name+").");
        }
    }

    public void setValue(double value) {
        if (type==ControlType.INTEGER) {
            this.value = new Long((long) value);
        } else if (type==ControlType.FLOAT) {
            this.value = new Double(value);
        } else if (type==ControlType.TEXT || type==ControlType.MEMO) {
            this.value = locale.getDoubleFormat().format(new Double(value));
        } else if (type==ControlType.DATE) {
            this.value = new Date((long) value);
        } else {
            throw new IllegalArgumentException(
                    "CachedColumn.setValue(double value): type mismatch (column name: "+name+").");
        }
    }

    public void setValue(Boolean value) {
        if (type==ControlType.BOOLEAN) {
            this.value = value;
        } else if (type==ControlType.TEXT || type==ControlType.MEMO) {
            this.value = locale.getBooleanFormat().format(value);
        } else {
            throw new IllegalArgumentException(
                    "CachedColumn.setValue(Boolean value): type mismatch (column name: "+name+").");
        }
    }

    public void setValue(Number value) {
        if (type==ControlType.INTEGER) {
            this.value = new Long(((Number) value).longValue());
        } else if (type==ControlType.FLOAT) {
            this.value = new Double(((Number) value).doubleValue());
        } else if (type==ControlType.TEXT || type==ControlType.MEMO) {
            this.value = locale.getDoubleFormat().format(new Double(((Number) value).doubleValue()));
        } else if (type==ControlType.DATE) {
            this.value = new Date(((Number) value).longValue());
        } else {
            throw new IllegalArgumentException(
                    "CachedColumn.setValue(Number value): type mismatch (column name: "+name+").");
        }
    }

    public void setValue(Date value) {
        if (type==ControlType.DATE) {
            this.value = value;
        } else if (type==ControlType.TEXT || type==ControlType.MEMO) {
            if (value!=null) {
                this.value = locale.getDateFormat().format(value);
            } else {
                this.value = null;
            }
        } else {
            throw new IllegalArgumentException(
                    "CachedColumn.setValue(Boolean value): type mismatch (column name: "+name+").");
        }
    }

    public void setValue(String value) {
        try {
            if (value==null || type==ControlType.TEXT || type==ControlType.MEMO) {
                this.value = value;
            } else if (type==ControlType.DATE) {
                this.value = locale.getDateFormat().parse(value);
            } else if (type==ControlType.INTEGER) {
                this.value = locale.getLongFormat().parseLong(value);
            } else if (type==ControlType.FLOAT) {
                this.value = locale.getDoubleFormat().parseDouble(value);
            } else if (type==ControlType.BOOLEAN) {
                this.value = locale.getBooleanFormat().parse(value);
            } else {
                throw new IllegalArgumentException(
                        "CachedColumn.setValue(String value): type mismatch (column name: "+name+").");
            }
        } catch (java.text.ParseException pe) {
            throw new IllegalArgumentException(
                    "CachedColumn.setValue(String value): unable parse data (column name: "+name+").");
        }
    }

    public void setValue(Object value) {
        if (value==null) {
            value = null;
        } else if (value instanceof String) {
            setValue((String) value);
        } else if (value instanceof Number ) {
            setValue((Number) value);
        } else if (value instanceof Boolean ) {
            setValue((Boolean) value);
        } else if (value instanceof Date ) {
            setValue((Date) value);
        } else {
            throw new IllegalArgumentException(
                    "CachedColumn.setValue(Object value): type mismatch (column name: "+name+").");
        }
    }
    
    public Object clone() {
        Object obj = null;
        try {
            obj = super.clone();
        } catch (CloneNotSupportedException cnse_ignore) {}
        ((CachedColumn) obj).value = null;
        return obj;
    }

}

//End CachedColumn class

