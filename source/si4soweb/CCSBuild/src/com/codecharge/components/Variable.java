//Variable component @0-123D52DC
package com.codecharge.components;

/**
A Variable is provided to be able to hide some html and other components enclosed in it, by setting its visible property.
 **/
public class Variable {

  private String name;
  private boolean visible;
  private String value;

  public Variable(String name) {
    this.name = name;
    visible = true;
    value = "";
  }
  public boolean isVisible() {return visible;}
  public void setVisible(boolean f) {visible = f;}
  public String getName() {return name;}
  public void setName(String name) {this.name = name;}
  public String getValue() { return value; }
  public void setValue(String value) {
    if ( value == null ) {
        this.value = "";
    } else {
        this.value = value;
    }
  }

}
//End Variable component

