//ControlErrorTypes @0-40B6E09C
package com.codecharge.validation;

import java.util.*;

final public class ControlErrorTypes {
  public static HashMap errorTypes = new HashMap();
  
  final public static String REQUIRED_ERROR = "REQUIRED";
  final public static String INPUT_MASK_ERROR = "INPUT_MASK";
  final public static String USER_VALID_ERROR = "USER_VALIDATION";
  final public static String UNIQUE_ERROR = "UNIQUE";
  final public static String FORMAT_ERROR = "FORMAT";
  final public static String FILE_NOT_FOUND_ERROR = "FILE_NOT_FOUND";
  final public static String GENERAL_ERROR = "GENERAL";
  
  static {
    errorTypes.put ( REQUIRED_ERROR, new ControlErrorType( REQUIRED_ERROR ));
    errorTypes.put ( INPUT_MASK_ERROR, new ControlErrorType( INPUT_MASK_ERROR ));
    errorTypes.put ( USER_VALID_ERROR, new ControlErrorType( USER_VALID_ERROR ));
    errorTypes.put ( UNIQUE_ERROR, new ControlErrorType( UNIQUE_ERROR ));
    errorTypes.put ( FORMAT_ERROR, new ControlErrorType( FORMAT_ERROR ));
    errorTypes.put ( FILE_NOT_FOUND_ERROR, new ControlErrorType( FILE_NOT_FOUND_ERROR ));
    errorTypes.put ( GENERAL_ERROR, new ControlErrorType( GENERAL_ERROR ));
  }
  
  public static ControlErrorType getErrorType( String errorName ) {
      return (ControlErrorType) errorTypes.get ( errorName );
  }

  public static void addErrorType( String errorName ) {
    if ( ! isSystemType( errorName ) ) {
      errorTypes.put ( errorName, new ControlErrorType( errorName ));
    }
  }

  public static void removeErrorType( String errorName ) {
    if ( ! isSystemType( errorName ) ) {
      errorTypes.remove ( errorName );
    }  
  }
  
  private static boolean isSystemType( String errorName ) {
    return ( REQUIRED_ERROR.equals( errorName )
           || INPUT_MASK_ERROR.equals( errorName )
           || USER_VALID_ERROR.equals( errorName )
           || UNIQUE_ERROR.equals( errorName )
           || FORMAT_ERROR.equals( errorName )
           || GENERAL_ERROR.equals( errorName ) );
  }
  
}
//End ControlErrorTypes

