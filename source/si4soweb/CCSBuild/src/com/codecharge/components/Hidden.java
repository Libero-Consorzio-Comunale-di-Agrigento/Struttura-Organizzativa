//Hidden component @0-8C610E80
package com.codecharge.components;



/**
A Hidden field is the equivalent of a Text Box except that a hidden field has no visual
representation on the rendered page. Unless the user views the source HTML for a page,
there is no visual indication of the existence of a Hidden field. Hidden fields are
often used to contain data that needs to be submitted or propagated but the user should
not or does not need to see the data.
<p>Hidden fields are also useful when entering information that does not require user input.
For instance, you can have a hidden field that contains the current date. The date is
automatically entered into the field by setting the value of the Default property of the
field to a function that returns the current date. The user therefore does not have to enter
the value and neither will they be aware of the fields existence, but the hidden field will
submit the value when the form is submitted.
**/
public class Hidden extends TextBox {

    /** Create new Hidden object.
      @param name Hidden name.
      @param fieldSource DB column name or expression used to read/write Hidden data.
      @param page Page to which this Hidden belongs.
     **/
    public Hidden(String name, String fieldSource, Page page) {
      super(name, fieldSource, page);
    }

    /** Create new Hidden object.
      @param name Hidden name.
      @param page Page to which this Hidden belongs.
     **/
    public Hidden(String name, Page page) {
      super(name, page);
    }


}
//End Hidden component

