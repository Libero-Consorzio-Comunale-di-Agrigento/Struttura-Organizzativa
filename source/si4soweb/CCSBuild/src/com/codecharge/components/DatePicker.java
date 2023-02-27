//DatePicker component @0-F92E0BF3
package com.codecharge.components;

import com.codecharge.util.*;

public class DatePicker extends Model implements Cloneable {

    protected Page page;
    protected String styleName;
    protected String controlName;
    protected String formatPattern;
    private String htmlName;

    public DatePicker(String name, Page page) {
        super(name);
        this.page = page;
        visible = true;
        htmlName = name;
    }

    public String getStyleName() {return styleName;}
    public void setStyleName(String styleName) {this.styleName = styleName;}

    public String getControlName() {return controlName;}
    public void setControlName(String controlName) {
        this.controlName = controlName;
        setHtmlName(controlName);
    }

    public void setHtmlName(String htmlName) { this.htmlName = htmlName; }

    public String getHtmlName() {
        return htmlName;
    }
    
    public String getFormatPattern() {
        return (formatPattern == null ? "" : StringUtils.replace(StringUtils.replace(formatPattern,"'","\\'"),"\"","&quot;"));
    }
    
    public void setFormatPattern(String formatPattern) {
        this.formatPattern = formatPattern;   
    }

    /** Copy DatePicker. */
    public Object clone() {
        Object obj = null;
        try {
            obj = super.clone();
        } catch (CloneNotSupportedException ignore) {}
        return obj;
    }

}
//End DatePicker component

