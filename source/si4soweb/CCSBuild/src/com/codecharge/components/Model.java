//Model component @0-A93FC81C
package com.codecharge.components;

import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
import java.util.Vector;
import java.util.StringTokenizer;
import java.util.Iterator;
import java.util.Collection;

/** Model is the base class for all component models and holds all components common properties.
 * CCS employ Model-View-Controller paradigm and Model is the place where all data from Controller is stored
 * and all needed data for View is taken.
 */
public class Model{

    /** Event handlers collection. */
    protected Vector listeners = new Vector();
    /** Name. */
    protected String name;
    /** Value of control name attribute in HTML. */
    protected String htmlName;
    /** Parameters to exclude from request collection. */
    protected Vector excludeParams = new Vector();
    /** Prefix to form request parameter name with value. */
    protected String prefix;
    /** Visible. */
    protected boolean visible = true;
    /** Parent of this model. */
    protected Component parent;

    protected boolean beforeShow = false;

    /** Create new model with name. */
    public Model (String name) {
        this.name = name;
        this.htmlName = name;
    }

    /** Set model name. */
    public void setName (String name) {this.name = name;}
    /** Get model name. */
    public String getName () {return name;}

    /** Set value of the HTML input name attribute. */
    public void setHtmlName (String htmlName) {this.htmlName = htmlName;}
    /** Get value of the HTML input name attribute. */
    public String getHtmlName () {return htmlName;}

    public void setBeforeShow( boolean flag ) {
        this.beforeShow = flag;
    }

    public boolean isBeforeShow() {
        return beforeShow;
    }

    /** Get the parent component that contains this control or component.
       @return parent component */
    public Component getParent() { return parent; }
    /** Set parent component. */
    public void setParent( Component parent ) { this.parent = parent; }

    /** Add collection of string that indicate parameters that should be removed from request query. */
    public void addExcludeParams(Collection excludeParams) {
        this.excludeParams.addAll(excludeParams);
    }

    /** Add parameter that should be removed from request query. */
    public void addExcludeParam(String param) {
        excludeParams.add(param);
    }

    /** Get collection of string that indicate parameters that should be removed from request query. */
    public Vector getExcludeParams() {
        return excludeParams;
    }

    /** Set prefix to retrieve model value. */
    public void setPrefix(String prefix) {
        this.prefix = prefix;
    }

    /** @deprecated Replaced by {@link #getQuery(QueryString)}. */
    public String getQuery(String query) {
        String result = "";
        if (query == null) return result;
        StringTokenizer st = new StringTokenizer(query, "&");
        while (st.hasMoreTokens()) {
            String elm = st.nextToken();
            Iterator i = excludeParams.iterator();
            boolean drop = false;
            while (i.hasNext()) {
                String p = (String)i.next();
                if (prefix == null) {
                    if (elm.startsWith(p)) drop = true;
                } else {
                    if (elm.startsWith(prefix+p)) drop = true;
                }
            }
            if (!drop) result += "&" + elm;
        }
        return result;
    }
    /** Get Query string with excludParams excluded. */
    public String getQuery( QueryString query ) {
        String result = "";
        if (query == null) return result;
        if ( excludeParams.size() == 0 ) 
            result = query.toString();
        else {
            String prefixPar = (prefix==null) ? "" : prefix;
            String[] p = new String[excludeParams.size()];
            for ( int i = 0; i < excludeParams.size(); i++ ) {
                p[i] = prefix + ( (String) excludeParams.get(i) );
            }
            result = query.toString( p );
        }
        return result;
    }
    
    /** Get Query string with excludParams excluded. */
    public String getQuery( RequestParameters query ) {
        /*String result = "";
        if (query == null) return result;
        if ( excludeParams.size() == 0 ) 
            result = query.toString();
        else {
            String prefixPar = (prefix==null) ? "" : prefix;
            String[] p = new String[excludeParams.size()];
            for ( int i = 0; i < excludeParams.size(); i++ ) {
                p[i] = prefix + ( (String) excludeParams.get(i) );
            }
            result = query.toString( p );
        }
        return result;*/
        return query.toString(excludeParams);
    }
    
    /** Whether this control should be shown.
      @return visibility state, false means hidden */
    public boolean isVisible() {
        return visible;
    }

    /** Specify whether this control or component should be shown.
       @param visible visibility boolean state, false means hidden */
    public void setVisible( boolean visible ) {
        this.visible = visible;
    }

    /** Get Event handlers collection. */
    public Iterator getListeners() {return listeners.iterator();}
}
//End Model component

