//ValidateHandler class @0-3AB24194
package com.codecharge.validation;

public class ValidateHandler {
  protected ValidateHandler nextHandler;

  public void validate( Verifiable control ) {
    if( nextHandler != null ) nextHandler.validate( control );
  }
  
  public void setNextHandler( ValidateHandler handler ) {
    nextHandler = handler;
  }

  public ValidateHandler getNextHandler() {
    return nextHandler;
  }
}
//End ValidateHandler class

