//ControlError class @0-89F1EB13
package com.codecharge.validation;

import java.util.*;

public class ControlError {
  Vector errors;

  public ControlError() {
    errors = new Vector();
  }
  
  private class Error {
    ControlErrorType type;
    String message;
    
    public Error( ControlErrorType type, String message ) {
      this.type = type;
      this.message = message;
    }
    
    public ControlErrorType getControlErrorType() {
      return type;
    }
    
    public String getMessage() {
      return message;
    }
  } // End of class Error
  
  public Enumeration getControlErrorTypes() {
    Vector types = new Vector();
    for ( int i = 0; i < errors.size(); i++ ) {
      types.add ( ((Error) errors.get( i )).getControlErrorType() );
    }
    return types.elements();
  }
  
  public Enumeration getControlErrorStrings() {
    Vector types = new Vector();
    for ( int i = 0; i < errors.size(); i++ ) {
      types.add ( ((Error) errors.get( i )).getMessage() );
    }
    return types.elements();
  }
  
  public void add( ControlErrorType type, String message ) {
    errors.add( new Error( type, message ));
  }

  public void add( String message ) {
    errors.add( new Error( (ControlErrorType) ControlErrorTypes.getErrorType( ControlErrorTypes.GENERAL_ERROR ), message ));
  }
  
  public boolean hasByType( ControlErrorType type ) {
    return hasByType( type.getType() );
  }
  
  public boolean hasByType( int type ) {
    boolean hasError = false;
    for ( int i = 0; i < errors.size(); i++ ) {
      if ( (((Error) errors.get( i )).getControlErrorType()).getType() == type ) {
        hasError = true;
        break;
      }
    }
    return hasError;
  } // End of function isError( int )
  
  public void removeByType( ControlErrorType type ) {
    removeByType( type.getType() );
  }
  
  public void removeByType( int type ) {
    for ( int i = 0; i < errors.size(); i++ ) {
      if ( (((Error) errors.get( i )).getControlErrorType()).getType() == type ) {
        errors.remove( i );
        i--;
      }
    }
  } // End of function removeByType( int )
  
  public void removeAll() {
    errors.removeAllElements();
  }
  
} // End of class ControlError
//End ControlError class

