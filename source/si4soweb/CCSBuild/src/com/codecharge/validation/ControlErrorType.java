//ControlErrorType @0-1CAD3333
package com.codecharge.validation;

public class ControlErrorType {
  private int type;
  private String typeName;
  
  private static int counter;
  
  public ControlErrorType( String typeName ) {
    type = counter++;
    this.typeName = typeName;
  }
  
  public int getType() { return type; }
  public String getTypeAsString() { return typeName; }
}
//End ControlErrorType

