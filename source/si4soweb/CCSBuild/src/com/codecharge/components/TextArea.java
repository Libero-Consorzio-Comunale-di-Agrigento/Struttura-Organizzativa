//TextArea component @0-FEFD417F
package com.codecharge.components;



/**
  A TextArea is used to provide multiline input so that user could change or add new values to record fields.
**/
public class TextArea extends VerifiableControl {

    /** Create new TextArea object.
      @param name TextArea name.
      @param fieldSource DB column name or expression used to retrieve and store TextArea from/to DB.
      @param page Page to which this TextArea belongs to.
    **/
    public TextArea(String name, String fieldSource, Page page) {
        super(name, fieldSource, page);
    }

    /** Create new TextArea object.
      @param name TextArea name.
      @param page Page to which this TextArea belongs to.
    **/
    public TextArea(String name, Page page) {
        super(name, page);
    }



}
//End TextArea component

