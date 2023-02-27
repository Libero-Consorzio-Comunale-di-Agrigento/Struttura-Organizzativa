//Query class @0-0BFBACD1
package com.codecharge.util;

import java.util.*;
import javax.servlet.http.*;
import com.codecharge.util.*;
import com.codecharge.Names;

public abstract class Query {
    protected Hashtable params = new Hashtable();
    protected HttpServletRequest req;
    protected String encoding;
    protected String defaultEncoding;
  
    public Query( HttpServletRequest req ) {
        this.req = req;
        this.encoding = ((CCSLocale) SessionStorage.getInstance(req).getAttribute(Names.CCS_LOCALE_KEY)).getCharacterEncoding();
        if ( this.encoding == null ) this.encoding = "ISO-8859-1";
        this.defaultEncoding=System.getProperty("file.encoding", "ISO-8859-1");
        try {
            byte[] tmp = "test".getBytes( encoding); 
        } catch (java.io.UnsupportedEncodingException e) { encoding="ISO-8859-1"; }
    }

    public Query( HttpServletRequest req, String encoding ) 
            throws java.io.UnsupportedEncodingException {
        this.req = req;
        this.defaultEncoding=System.getProperty("file.encoding", "ISO-8859-1");
        this.encoding=encoding;
        byte[] tmp = "test".getBytes( encoding); 
    }

    public Hashtable getParams() { return params; }
  
    public String getParameter( String name ) {
        return getParameter(name, null);  
    }
  
    public String getParameter( String name, String defaultValue ) {
        String param = defaultValue;
        if ( params != null ) {
            Vector values = (Vector) params.get( name );
            if ( values != null ) {
                param = (String) values.get( 0 );
            }
        }
        return param;  
    }
  
  public String getParameterAsString( String name ) {
    if ( params == null ) return "";
    String param = null;
    Vector values = (Vector) params.get( name );
    if ( values != null ) 
      param = (String) values.get( 0 );
    return ( param == null ? "" : param );  
  }
  
  public String[] getParameterValues( String name ) {
    String[] values = null;
    if ( params == null ) return values;
    Vector vals = (Vector) params.get( name );
    if ( vals != null ) {
      values = new String[vals.size()];
      vals.toArray( values );
    }  
    return values;  
  }
  
  public Enumeration getParameterNames() {
    if ( params == null ) return null;
    return params.keys();
  }

  public String toString() {
    return toString ( (String[]) null );
  }

  public HashMap getPreserveParameters(Vector excludeNames) {
    HashMap result = new HashMap();
    if ( params == null ) return result;

    Enumeration paramNames = getParameterNames();
    boolean applyExclude = (excludeNames == null || 
            excludeNames.size() == 0 ) ? false : true;
    while ( paramNames.hasMoreElements() ) {
      String name = (String) paramNames.nextElement();
      boolean includeName = true;
      if ( applyExclude ) {
        for ( int i = 0; i < excludeNames.size(); i++ ) {
          if ( name.equals( ((String) excludeNames.get(i)) ) ) {
            includeName = false;
            break;
          }
        }
      }
      if ( includeName ) {
        result.put( name, paramToString( name ) );
      }
    }
    return result;
  }
  
  public String toString( String[] excludeNames ) {
    if ( params == null ) return "";
    Enumeration paramNames = getParameterNames();
    boolean applyExclude = excludeNames == null ? false : true;
    StringBuffer result = new StringBuffer();
    while ( paramNames.hasMoreElements() ) {
      String name = (String)  paramNames.nextElement();
      boolean includeName = true;
      if ( applyExclude ) {
        for ( int i = 0; i < excludeNames.length; i++ ) {
          if ( name.equals( excludeNames[i] ) ) {
            includeName = false;
            break;
          }
        }
      }
      if ( includeName ) {
        result.append( paramToString( name ) );
        if ( paramNames.hasMoreElements() ) 
          result.append( "&" );
      }
    }
    return result.toString();
  }
  
  public String toString( Vector excludeNames ) {
      return toString( excludeNames, null );
  }
      
  public String toString( Vector excludeNames, String prefix ) {
    if ( params == null ) return "";
    String prefixName = StringUtils.isEmpty(prefix) ? "" : prefix;
    Enumeration paramNames = getParameterNames();
    boolean applyExclude = (excludeNames == null || 
            excludeNames.size() == 0 ) ? false : true;
    StringBuffer result = new StringBuffer();
    while ( paramNames.hasMoreElements() ) {
      String name = (String) paramNames.nextElement();
      boolean includeName = true;
      if ( applyExclude ) {
        for ( int i = 0; i < excludeNames.size(); i++ ) {
          if ( name.equals( prefixName + ((String) excludeNames.get(i)) ) ) {
            includeName = false;
            break;
          }
        }
      }
      if ( includeName ) {
        result.append( paramToString( name ) );
        if ( paramNames.hasMoreElements() ) 
          result.append( "&" );
      }
    }
    return result.toString();
  }
  
  private String paramToString( String name) {
    if ( name == null ) return "";
    String[] qvals = getParameterValues( name );
    if ( qvals == null ) return "";
    StringBuffer result = new StringBuffer();
    if ( qvals.length == 1 ) {
      result.append( name + "=" + java.net.URLEncoder.encode(qvals[0]) );
    }
    else {
      for ( int i = 0; i < qvals.length; i++ ) {
        result.append( name + "=" + java.net.URLEncoder.encode(qvals[i]) );
        if ( i < qvals.length - 1 ) 
          result.append( "&" );
      }
    }
    return result.toString();
  }

    protected String encodingByContentType(){
        String tmp = req.getHeader("Content-Type");
        if (tmp != null) {
            int i = tmp.indexOf(";");
            if (i != -1) {
                String tmp1 = tmp.substring(i+1);
                int j = tmp1.indexOf("charset=");
                if (j != -1) {
                    tmp = tmp1.substring(j+8).trim();
                    try {
                        byte[] tst = "test".getBytes( tmp);
                        return tmp;
                    } catch( java.io.UnsupportedEncodingException e) {
                        return null;
                    }
                }
            }
        }
        return null;
    }

  protected String reEncode( String value){
    String tmp=null;
        if (value != null) {
             String reqEnc = req.getCharacterEncoding();
             if (reqEnc == null) reqEnc="ISO-8859-1";
             try {
                 tmp = new String( value.getBytes( reqEnc), encoding ); 
             } catch(java.io.UnsupportedEncodingException e){
                 tmp=value;
             }
        }
        return tmp;
  }
  
    public String getRequestParameter(String name){
        return reEncode( req.getParameter( name)); 
    }

    public Enumeration getRequestParameterNames(){
       return req.getParameterNames();
    }
    
    public String[] getRequestParameterValues(String name){
        String[] tmpS = req.getParameterValues(name);
        if ( tmpS != null) {
            for( int i=0; i<tmpS.length; i++) {
                tmpS[i]=reEncode( tmpS[i]);
            }
        }
        return tmpS;
    }
    
}
//End Query class

