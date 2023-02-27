//RequestParameters class @0-80EA5A44
package com.codecharge.util.multipart;

import java.util.*;
import com.codecharge.util.*;

public class RequestParameters {
    Hashtable parameters = new Hashtable();
    /** Encoding used to URLencode GET parameter values. */
    private String encoding;

    public RequestParameters(String encoding) {
      this.encoding = encoding;
    }
    public RequestParameters() {
      this.encoding = "UTF-8";
    }
    
    public String getParameter( String name ) {
        return getParameter(name, null);  
    }

    public String getParameterAsString( String name ) {
        return getParameter(name, "");  
    }

    public String getParameter( String name, String defaultValue ) {
        String parameter = defaultValue;
        if (name != null) {
            String[] values = (String[]) parameters.get( name );
            if ( values != null ) { 
                parameter = (String) values[0];
            }
        }
        return parameter;  
    }

    public String[] getParameterValues( String name ) {
        String[] values = (String[]) parameters.get( name );
        String[] result = null;
        if (values != null) {
            result = new String[values.length];
            System.arraycopy(values,0,result,0,result.length);
        }
        return result;
    }

    public Enumeration getParameterNames() {
        return parameters.keys();
    }
    
    public Map getParameterMap() {
        return new Hashtable(parameters);
    }

    void setParameters(Hashtable parameters) {
        if (parameters!=null) {
            this.parameters = parameters;
        }
    }

    public String toString( String[] excludeNames ) {
      if ( parameters == null ) return "";
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
          if ( result.length() > 0)
            result.append( "&" );
          result.append( paramToString( name ) );
        }
      }
      return result.toString();
    }
  
    public String toString( Vector excludeNames ) {
        return toString( excludeNames, null );
    }
      
    public String toString( Vector excludeNames, String prefix ) {
      if ( parameters == null ) return "";
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
          if ( result.length() > 0)
            result.append( "&" );
          result.append( paramToString( name ) );
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
        try {
          qvals[0] = StringUtils.encodeURL(qvals[0], encoding);
        } catch(java.io.UnsupportedEncodingException e) {}
        result.append( name + "=" + qvals[0] );
      }
      else {
        for ( int i = 0; i < qvals.length; i++ ) {
          try {
            qvals[i] = StringUtils.encodeURL(qvals[i], encoding);
          } catch(java.io.UnsupportedEncodingException e) {}
          result.append( name + "=" + qvals[i] );
          if ( i < qvals.length - 1 ) 
            result.append( "&" );
        }
      }
      return result.toString();
    }

    public HashMap getPreserveParameters(Vector excludeNames) {
      HashMap result = new HashMap();
      if ( parameters == null ) return result;

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
  
}

//End RequestParameters class

