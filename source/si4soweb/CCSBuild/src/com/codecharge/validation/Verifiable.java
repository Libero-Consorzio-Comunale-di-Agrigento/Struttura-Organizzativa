//Verifiable interface @0-B6A8159E
package com.codecharge.validation;

import java.text.*;
import com.codecharge.components.*;

public interface Verifiable {
  Object getValue();
  void addError( String error );
  void addError( ControlErrorType type, String error );
  boolean hasErrorByType( ControlErrorType type );
  ControlType getType();
  Format getFormat();
  String getFormatPattern();
  String getCaption();
}
//End Verifiable interface

