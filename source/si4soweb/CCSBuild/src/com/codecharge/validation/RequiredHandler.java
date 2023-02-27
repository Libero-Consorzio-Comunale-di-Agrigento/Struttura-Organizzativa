//RequiredHandler class @0-A5F50FBA
package com.codecharge.validation;

public class RequiredHandler extends ValidateHandler {

    private String message;
  
    public RequiredHandler() {
    }

    public RequiredHandler( String message ) {
        this.message = message;
    }

    public void validate( Verifiable control ) {
        if ( control != null && ( control.getValue() == null || 
                "".equals(control.getValue().toString()) ) ) {
            if ( message == null || message.length() == 0 ) {
                message = control.getCaption() + " field value is required.";
            }
            control.addError( ControlErrorTypes.getErrorType( 
                        ControlErrorTypes.REQUIRED_ERROR ), message );
    }
    super.validate( control );
  }
}
//End RequiredHandler class

