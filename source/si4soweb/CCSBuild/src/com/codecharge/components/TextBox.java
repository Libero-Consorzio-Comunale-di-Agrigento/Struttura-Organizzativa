//TextBox component @0-7FBE64F1
package com.codecharge.components;



/**
  A TextBox is used to provide single line input so that user could change or add new values to record fields.
**/
public class TextBox extends VerifiableControl {

    /** Create new TextBox object.
      @param name TextBox name.
      @param fieldSource DB column name or expression used to retrieve and store TextBox from/to DB.
      @param page Page to which this TextBox belongs to.
    **/
    public TextBox(String name, String fieldSource, Page page) {
        super(name, fieldSource, page);
    }

    /** Create new TextBox object.
      @param name TextBox name.
      @param page Page to which this TextBox belongs to.
    **/
    public TextBox(String name, Page page) {
        super(name, page);
    }


}
//End TextBox component

