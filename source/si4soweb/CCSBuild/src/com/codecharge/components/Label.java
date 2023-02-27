//Label component @0-E4ED173D
package com.codecharge.components;

import com.codecharge.util.StringUtils;


/**
  Label is used to show both static and dynamic data without ability to change it.
  Generally Grids are composed of Labels. Labels also can be used in Records to represent read-only fields.
**/
public class Label extends Control {

    /** Create new Label object.
      @param name Name of the Label.
      @param fieldSource DB column or expression used to retrieve Label value.
      @param page Page to which this Label belongs.
     **/
    public Label(String name, String fieldSource, Page page) {
      super(name, fieldSource, page);
    }

    /** Create new Label object.
      @param name Name of the Label.
      @param page Page to which this Label belongs.
     **/
    public Label(String name, Page page) {
      super(name, page);
    }

    /** Escape symbols having specific meaning in HTML. **/
    protected String toHtml( String value ) {
      if ( isHtmlEncode() ) {
         value = StringUtils.toHtml( value );
         value = StringUtils.replace( value, "\r", "" );
         value = StringUtils.replace( value, "\n", "<br>" );
         //value = StringUtils.replace( value, "  ", " &nbsp;" );
      }
      return value;
    }


}

//End Label component

