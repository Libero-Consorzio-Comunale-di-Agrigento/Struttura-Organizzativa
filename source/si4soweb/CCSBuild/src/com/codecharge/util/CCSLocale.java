//CCSLocale @0-58CE0B60
package com.codecharge.util;

import java.util.*;
import java.text.*;

import com.codecharge.components.*;

public class CCSLocale {
    
    private Locale locale;
    private String characterEncoding;
    private String dateFormatPattern;
    private String booleanFormatPattern;
    private String longFormatPattern;
    private String doubleFormatPattern;

    public CCSLocale() {
        this(null, null);
    }

    public CCSLocale(Locale locale) {
        this(locale, null);
    }

    public CCSLocale(Locale locale, String characterEncoding) {
        if ( locale == null ) {
            locale = Locale.getDefault();
        }
        if ( StringUtils.isEmpty(characterEncoding) ) {
            characterEncoding = "ISO-8859-1";
        } else {
            try {
                byte[] tmp = "test".getBytes(characterEncoding); 
            } catch (java.io.UnsupportedEncodingException e) { characterEncoding="ISO-8859-1"; }
        }
        this.locale = locale;
        this.characterEncoding = characterEncoding;
        this.dateFormatPattern = "GeneralDate";
        this.booleanFormatPattern = "True;False";
        this.longFormatPattern = "##";
        this.doubleFormatPattern = "#.##";
    }

    public Locale getLocale() {
        return locale;
    }

    public void setLocale(Locale locale) {
        this.locale = locale;
    }

    public String getCharacterEncoding() {
        return characterEncoding;
    }

    public void setCharacterEncoding(String characterEncoding) {
        this.characterEncoding = characterEncoding;
    }

    public String getDateFormatPattern() {
        return dateFormatPattern;
    }

    public void setDateFormatPattern(String dateFormatPattern) {
        if ( dateFormatPattern == null ) {
            dateFormatPattern = "GeneralDate";
        }
        this.dateFormatPattern = dateFormatPattern;
    }

    public String getBooleanFormatPattern() {
        return booleanFormatPattern;
    }

    public void setBooleanFormatPattern(String booleanFormatPattern) {
        if ( booleanFormatPattern == null ) {
            booleanFormatPattern = "True;False";
        }
        this.booleanFormatPattern = booleanFormatPattern;
    }

    public String getLongFormatPattern() {
        return longFormatPattern;
    }

    public void setLongFormatPattern(String longFormatPattern) {
        if ( longFormatPattern == null ) {
            longFormatPattern = "##";
        }
        this.longFormatPattern = longFormatPattern;
    }

    public String getDoubleFormatPattern() {
        return doubleFormatPattern;
    }

    public void setDoubleFormatPattern(String doubleFormatPattern) {
        if ( doubleFormatPattern == null ) {
            doubleFormatPattern = "#.##";
        }
        this.doubleFormatPattern = doubleFormatPattern;
    }

    public DateFormat getDateFormat() {
        DateFormat format = null;
        if ( "GeneralDate".equalsIgnoreCase( dateFormatPattern ) ) {
            format = DateFormat.getDateTimeInstance(DateFormat.DEFAULT, DateFormat.DEFAULT, locale);
        } else if ( "LongDate".equalsIgnoreCase( dateFormatPattern ) ) {
            format = DateFormat.getDateInstance(DateFormat.LONG, locale);
        } else if ( "ShortDate".equalsIgnoreCase( dateFormatPattern ) ) {
            format = DateFormat.getDateInstance(DateFormat.SHORT, locale);
        } else if ( "LongTime".equalsIgnoreCase( dateFormatPattern ) ) {
            format = DateFormat.getTimeInstance(DateFormat.LONG, locale);
        } else if ( "ShortTime".equalsIgnoreCase( dateFormatPattern ) ) {
            format = DateFormat.getTimeInstance(DateFormat.SHORT, locale);
        } else {
            format = new SimpleDateFormat( dateFormatPattern, locale );
        }
        return format;
    }

    public DateFormat getDateFormat(String formatPattern) {
        DateFormat format = null;
        if ( StringUtils.isEmpty(formatPattern ) ) {
            format = getDateFormat();
        } else if ( "GeneralDate".equalsIgnoreCase( formatPattern ) ) {
            format = DateFormat.getDateTimeInstance(DateFormat.DEFAULT, DateFormat.DEFAULT, locale);
        } else if ( "LongDate".equalsIgnoreCase( formatPattern ) ) {
            format = DateFormat.getDateInstance(DateFormat.LONG, locale);
        } else if ( "ShortDate".equalsIgnoreCase( formatPattern ) ) {
            format = DateFormat.getDateInstance(DateFormat.SHORT, locale);
        } else if ( "LongTime".equalsIgnoreCase( formatPattern ) ) {
            format = DateFormat.getTimeInstance(DateFormat.LONG, locale);
        } else if ( "ShortTime".equalsIgnoreCase( formatPattern ) ) {
            format = DateFormat.getTimeInstance(DateFormat.SHORT, locale);
        } else {
            format = new SimpleDateFormat( formatPattern, locale );
        }
        return format;
    }

    public BooleanFormat getBooleanFormat() {
        BooleanFormat format = null;
        Enumeration tokens = StringUtils.split(booleanFormatPattern);
        String trueValue = tokens.hasMoreElements() ? (String) tokens.nextElement() : null;
        String falseValue = tokens.hasMoreElements() ? (String) tokens.nextElement() : null;
        String defaultValue = tokens.hasMoreElements() ? (String) tokens.nextElement() : null;
        format = new BooleanFormat( trueValue, falseValue, defaultValue, locale);
        return format;
    }

    public BooleanFormat getBooleanFormat(String formatPattern) {
        BooleanFormat format = null;
        if ( StringUtils.isEmpty(formatPattern ) ) {
            format = getBooleanFormat();
        } else {
            Enumeration tokens = StringUtils.split(formatPattern);
            String trueValue = tokens.hasMoreElements() ? (String) tokens.nextElement() : null;
            String falseValue = tokens.hasMoreElements() ? (String) tokens.nextElement() : null;
            String defaultValue = tokens.hasMoreElements() ? (String) tokens.nextElement() : null;
            format = new BooleanFormat( trueValue, falseValue, defaultValue, locale);
        }
        return format;
    }

    public NumericFormat getLongFormat() {
        return new NumericFormat( longFormatPattern, locale );
    }

    public NumericFormat getLongFormat(String formatPattern) {
        NumericFormat format = null;
        if ( StringUtils.isEmpty(formatPattern ) ) {
            format = getLongFormat();
        } else {
            format = new NumericFormat( longFormatPattern, locale );
        }
        return format;
    }

    public NumericFormat getDoubleFormat() {
        return new NumericFormat( doubleFormatPattern, locale );
    }

    public NumericFormat getDoubleFormat(String formatPattern) {
        NumericFormat format = null;
        if ( StringUtils.isEmpty(formatPattern ) ) {
            format = getDoubleFormat();
        } else {
            format = new NumericFormat( longFormatPattern, locale );
        }
        return format;
    }

    public NumericFormat getNumericFormat(String formatPattern) {
        return new NumericFormat( formatPattern, locale );
    }

    public Format getFormat(ControlType type) {
        return getFormat(type, null);
    }

    public Format getFormat(ControlType type, String formatPattern) {
        Format fmt = null;
        if ( ! StringUtils.isEmpty(formatPattern)) {
            if ( type == ControlType.INTEGER ) {
                fmt = getNumericFormat(formatPattern);
            } else if ( type == ControlType.FLOAT ) {
                fmt = getNumericFormat(formatPattern);
            } else if ( type == ControlType.DATE ) {
                fmt = getDateFormat(formatPattern);
            } else if ( type == ControlType.BOOLEAN ) {
                fmt = getBooleanFormat(formatPattern);
            }
        } else {
            if ( type == ControlType.INTEGER ) {
                fmt = getLongFormat();
            } else if ( type == ControlType.FLOAT ) {
                fmt = getDoubleFormat();
            } else if ( type == ControlType.DATE ) {
                fmt = getDateFormat();
            } else if ( type == ControlType.BOOLEAN ) {
                fmt = getBooleanFormat();
            }
        }
        return fmt;
    }

    public Format getFormat(String type) {
        return getFormat((String) type, null);
    }

    public Format getFormat(String type, String formatPattern) {
        Format fmt = null;
        if ( ! StringUtils.isEmpty(formatPattern)) {
            if ( "Integer".equals(type) ) {
                fmt = getNumericFormat(formatPattern);
            } else if ( "Float".equals(type) ) {
                fmt = getNumericFormat(formatPattern);
            } else if ( "Date".equals(type) ) {
                fmt = getDateFormat(formatPattern);
            } else if ( "Boolean".equals(type) ) {
                fmt = getBooleanFormat(formatPattern);
            }
        } else {
            if ( "Integer".equals(type) ) {
                fmt = getLongFormat();
            } else if ( "Float".equals(type) ) {
                fmt = getDoubleFormat();
            } else if ( "Date".equals(type) ) {
                fmt = getDateFormat();
            } else if ( "Boolean".equals(type) ) {
                fmt = getBooleanFormat();
            }
        }
        return fmt;
    }

}

//End CCSLocale

