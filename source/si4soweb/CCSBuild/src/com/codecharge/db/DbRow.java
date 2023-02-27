//DbRow @0-44EF35B7
package com.codecharge.db;

import java.util.*;

public class DbRow extends Hashtable {

    private boolean useUpperCase;

    public DbRow() {
        super();
    }

    public DbRow(int initialCapacity) {
        super(initialCapacity);
    }

    public DbRow(int initialCapacity, float loadFactor) {
        super(initialCapacity, loadFactor);
    }

    public DbRow(Map t) {
        super(t);
    }

    public boolean isUseUpperCase() {
        return useUpperCase;
    }

    public void setUseUpperCase( boolean useUpperCase ) {
        this.useUpperCase = useUpperCase;
    }
           
    public boolean containsKey(Object key) {
        boolean containsKey = false;
        if ( (key instanceof String) && useUpperCase ) {
            containsKey = super.containsKey( ((String) key).toUpperCase() );
        } else {
            containsKey = super.containsKey( key );
        }
        return containsKey;
    }

    public Object get(Object key) {
        Object value = null;
        if ( (key instanceof String) && useUpperCase ) {
            value = super.get( ((String) key).toUpperCase() );
        } else {
            value = super.get( key );
        }
        return value;
    }

    public Object remove(Object key) {
        Object value = null;
        if ( (key instanceof String) && useUpperCase ) {
            value = super.remove( ((String) key).toUpperCase() );
        } else {
            value = super.remove( key );
        }
        return value;
    }

    public Object put(Object key, Object value) {
        Object val = null;
        if ( (key instanceof String) && useUpperCase ) {
            val = super.put(((String) key).toUpperCase(), value);
        } else {
            val = super.put(key, value);
        }
        return val;
    }


}
//End DbRow

