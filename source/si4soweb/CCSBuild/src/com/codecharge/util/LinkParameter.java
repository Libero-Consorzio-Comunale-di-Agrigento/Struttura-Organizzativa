//LinkParameter class @0-0D875321
package com.codecharge.util;

import com.codecharge.db.*;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Collection;
import java.util.Iterator;

public class LinkParameter implements Cloneable {

    protected String name;
    protected ArrayList values = new ArrayList();
    protected String sourceName;
    protected ParameterSource sourceType;
    
    public LinkParameter(String name, String sourceName, ParameterSource sourceType ) {
        this.name = name;
        this.sourceName = sourceName;
        this.sourceType = sourceType;
    }

    public String getName() {
        return name;
    }
    
    public String getValue() {
        String val = null;
        if ( values.size() == 0 ) {
            val = "";
        } else {
            val = values.get(0)==null ? "" : values.get(0).toString();
        }
        return val;
    }
    
	public void setValue(Object value) {
		if (value instanceof Enumeration) {
			setValue((Enumeration) value);
		} else if (value instanceof Collection) {
			setValue((Collection) value);
		} else {
			clearValues();
			addValue(value);
		}
	}
	public void setValue(long value) { setValue(new Long(value)); }
	public void setValue(double value) { setValue(new Double(value)); }
	public void setValue(boolean value) { setValue(new Boolean(value)); }
	
	/** for backward compatibility*/
	public void setValue(Enumeration values) { setValues(values); }
	/** for backward compatibility*/
	public void setValue(Collection values) { setValues(values); }
	/** for backward compatibility*/
	public void setValue(Object[] values) { setValues(values); }
	/** for backward compatibility*/
	public void setValue(long[] value) { setValues(values); }
	/** for backward compatibility*/
	public void setValue(double[] value) { setValues(values); }
	/** for backward compatibility*/
	public void setValue(boolean[] value) { setValues(values); }
    
	public void addValue(Object value) { 
		if (value!=null) this.values.add(value); 
	}
	public void addValue(long value) { addValue(new Long(value)); }
	public void addValue(double value) { addValue(new Double(value)); }
	public void addValue(boolean value) { addValue(new Boolean(value)); }
    
	public void addValues(Object[] values) { 
		if (values==null) return;
		for (int i = 0; i < values.length; i++ ) { addValue(values[i]); } 
	}
	public void addValues(long[] values) { 
		if (values==null) return;
		for (int i = 0; i < values.length; i++ ) { addValue(new Long(values[i])); } 
	}
	public void addValues(double[] values) { 
		if (values==null) return;
		for (int i = 0; i < values.length; i++ ) { addValue(new Double(values[i])); } 
	}
	public void addValues(boolean[] values) { 
		if (values==null) return;
		for (int i = 0; i < values.length; i++ ) { addValue(new Boolean(values[i])); } 
	}
	public void addValues(Enumeration values) { 
		if (values==null) return;
		while (values.hasMoreElements()) { addValue(values.nextElement()); } 
	}
	public void addValues(Collection values) { 
		if (values==null) return;
		for (Iterator it = values.iterator(); it.hasNext(); ) { addValue(it.next()); } 
	}
    
	public void setValues(Enumeration values) {
		clearValues();
		addValues(values);
	}
    
	public void setValues(Collection values) {
		clearValues();
		addValues(values);
	}
    
	public void setValues(Object[] values) {
		clearValues();
		addValues(values);
	}
    
	public void setValues(long[] value) {
		clearValues();
		addValues(values);
	}
    
	public void setValues(double[] value) {
		clearValues();
		addValues(values);
	}
    
	public void setValues(boolean[] value) {
		clearValues();
		addValues(values);
	}

	public void clearValues() { values.clear();	}

    public String getSourceName() {
        return sourceName;
    }
    
    public void setSourceName( String sourceName ) {
        this.sourceName = sourceName;
    }
    
    public ParameterSource getSourceType() {
        return sourceType;
    }
    
    public void setSourceType( ParameterSource sourceType ) {
        this.sourceType = sourceType;
    }
    public Object clone() {
        Object obj = null;
        try {
            obj = super.clone();
			((LinkParameter) obj).values = new ArrayList();
        } catch (CloneNotSupportedException cnse_ignore) {}
        return obj;
    }
    
    public String toString() {
		StringBuffer sb = new StringBuffer();
		int valuesSize = values.size();
		for (int i = 0; i < valuesSize; i++ ) {
			Object val = values.get(i);
			if (val!=null) {
				String value = val.toString();
				sb.append(name+"="+java.net.URLEncoder.encode(value));
				if (i<valuesSize-1) sb.append("&");
			}
		}
		if (valuesSize==0) sb.append(name+"=");
		return sb.toString();
    }
}
//End LinkParameter class

