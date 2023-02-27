//PostParams class @0-210CA267
package com.codecharge.util;

import java.util.*;
import javax.servlet.http.*;

public class PostParams extends Query {
  QueryString qs;
  boolean isNullQueryString;
  
  public PostParams( HttpServletRequest req ) {
    super( req );
    this.qs = new QueryString( req );
    isNullQueryString = false;
    fillPostParams();
  }

  public PostParams( HttpServletRequest req, QueryString qs ) {
    super( req );
    this.qs = qs;
    isNullQueryString = false;
    fillPostParams();
  }

  private void fillPostParams() {
    if ( qs.getQueryString() == null ) {
      isNullQueryString = true;
    }
    final String EMPTY = "";
    Enumeration paramNames = getRequestParameterNames();
    while ( paramNames.hasMoreElements() ) {
      String name = (String) paramNames.nextElement();
      String[] vals = qs.getParameterValues( name );
      String[] reqVals = getRequestParameterValues( name );
      if ( vals == null && reqVals != null ) {
        Vector items = null;
        int k = 0;
        for ( int i = 0; i < reqVals.length; i++ ) {
          if ( ( items = (Vector) params.get( name )) == null ) {
            items = new Vector();
          }
          items.addElement( reqVals[i] );
          params.put( name, items );
        }
      }
      else if ( vals != null && reqVals != null && vals.length < reqVals.length ) {
        Vector items = null;
        int k = 0;
        for ( int i = 0; i < reqVals.length; i++ ) {
          boolean found = false;
          for ( int j = k; j < vals.length; j++ ) {
            if ( reqVals[i].equals( vals[j] ) ) {
              found = true;
              vals[j] = null;
              break;
            }
          }
          if ( ! found ) {
            if ( ( items = (Vector) params.get( name )) == null ) {
              items = new Vector();
            }
            items.addElement( reqVals[i] );
            params.put( name, items );
          }
        }
      }
    }
  }
}
//End PostParams class

