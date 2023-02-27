//BooleanFormat class @0-4CB370E0
package com.codecharge.util;

import java.text.*;
import java.util.Locale;

public class BooleanFormat extends java.text.Format {
    private String trueValue;
    private String falseValue;
    private Object defaultValue;
//    private Locale locale = new Locale(System.getProperty("user.language"), System.getProperty("user.country"));
    private Locale locale = Locale.getDefault();

    public BooleanFormat() {
        this.trueValue = "true";
        this.falseValue = "false";
        this.defaultValue = "null";
    }

    public BooleanFormat(String trueValue, String falseValue, String defaultValue) {
        this.trueValue = trueValue;
        this.falseValue = falseValue;
        this.defaultValue = defaultValue;
    }

    public BooleanFormat(String trueValue, String falseValue, Object defaultValue) {
        this.trueValue = trueValue;
        this.falseValue = falseValue;
        this.defaultValue = defaultValue;
    }

    public BooleanFormat(String trueValue, String falseValue, boolean defaultValue) {
        this.trueValue = trueValue;
        this.falseValue = falseValue;
        this.defaultValue = new Boolean( defaultValue );
    }

    public BooleanFormat(String trueValue, String falseValue, long defaultValue) {
        this.trueValue = trueValue;
        this.falseValue = falseValue;
        this.defaultValue = new Long( defaultValue );
    }

    public BooleanFormat(String trueValue, String falseValue, double defaultValue) {
        this.trueValue = trueValue;
        this.falseValue = falseValue;
        this.defaultValue = new Double( defaultValue );
    }

    public BooleanFormat(Locale locale) {
        this();
        if ( locale != null ) {
            this.locale = locale;
        }
    }

    public BooleanFormat(String trueValue, String falseValue, String defaultValue, Locale locale) {
        this(trueValue, falseValue, defaultValue);
        if ( locale != null ) {
            this.locale = locale;
        }
    }

    public BooleanFormat(String trueValue, String falseValue, Object defaultValue, Locale locale) {
        this(trueValue, falseValue, defaultValue);
        if ( locale != null ) {
            this.locale = locale;
        }
    }

    public BooleanFormat(String trueValue, String falseValue, boolean defaultValue, Locale locale) {
        this(trueValue, falseValue, new Boolean( defaultValue ));
        if ( locale != null ) {
            this.locale = locale;
        }
    }

    public BooleanFormat(String trueValue, String falseValue, long defaultValue, Locale locale) {
        this(trueValue, falseValue, new Long(defaultValue));
        if ( locale != null ) {
            this.locale = locale;
        }
    }

    public BooleanFormat(String trueValue, String falseValue, double defaultValue, Locale locale) {
        this(trueValue, falseValue, new Double(defaultValue));
        if ( locale != null ) {
            this.locale = locale;
        }
    }

    public StringBuffer format(Object value, StringBuffer toAppendTo ,
            FieldPosition ignore) throws IllegalArgumentException {
        String result = null;
        Object val = value;
        if (value == null) {
            val = defaultValue;
        }

        if ( val == null ) {
          result = "";
        } else {

            if (val instanceof Boolean) {
                if (((Boolean) val).booleanValue()) {
                    result = trueValue;
                } else {
                    result = falseValue;
                }
            } else {
                String stringValue = val.toString();
                if (stringValue.equals(trueValue)) {
                    result = trueValue;
                } else if (stringValue.equals(falseValue)) {
                    result = falseValue;
                } else {
                    result = defaultValue == null ? "" : defaultValue.toString();
                }
            }
        }
        toAppendTo.append(result);
        return toAppendTo;
    }

    public Object parseObject(String value, ParsePosition ignore) {
        Object result = null;
        try {
            result = parse(value);
        } catch (ParseException peignore) {}
        return result;
    }

    public Object parseObject(String value) {
        Object result = null;
        try {
            result = parse(value);
        } catch (ParseException peignore) {}
        return result;
    }

    public Boolean parse(String value) throws ParseException {
        Boolean result = null;
        String dValue = defaultValue == null ? "null" : defaultValue.toString();
        if (value == null) {
            if (trueValue == null) {
                result = Boolean.TRUE;
            } else if (falseValue == null) {
                result = Boolean.FALSE;
            } else if ( "null".equalsIgnoreCase( dValue ) ) {
                result = null;
            } else {
                throw new ParseException("Boolean format" , 0);
            }
        } else if (value.equals(trueValue)) {
            result = Boolean.TRUE;
        } else if (value.equals(falseValue)) {
            result = Boolean.FALSE;
        } else if (value.equals(dValue)) {
            result = null;
        } else {
            throw new ParseException("Boolean format" , 0);
        }
        return result;
    }

} // End of class
//End BooleanFormat class

