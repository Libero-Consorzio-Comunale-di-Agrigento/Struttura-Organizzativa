//Image component @0-409B6591
package com.codecharge.components;

import com.codecharge.util.StringUtils;


/**
  Image is an html image where src attribute is calculated dynamically or red from DB.
**/
public class Image extends Control {
    /** Create new Image object.
      @param name Name of the Image.
      @param fieldSource Column used to retrieve Image value from DB.
      @param page Page that ownes this Image.
    **/
    public Image(String name, String fieldSource, Page page) {
        super(name, fieldSource, page);
    }

    /** Create new Image object.
      @param name Name of the Image.
      @param page Page that ownes this Image.
    **/
    public Image(String name, Page page) {
        super(name, page);
    }

    protected String toHtml( String value ) {
        value = StringUtils.toHtml( value );
        value = StringUtils.replace( value, "\r", "" );
        value = StringUtils.replace( value, "\n", "<br>" );
        return value;
    }


}
//End Image component

