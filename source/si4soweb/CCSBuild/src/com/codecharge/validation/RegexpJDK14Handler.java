//RegexpJDK14Handler class @0-531834B5
package com.codecharge.validation;

import java.util.regex.*;
import com.codecharge.components.*;
import com.codecharge.util.*;

public class RegexpJDK14Handler extends ValidateHandler {
    private String pattern;
    private String message;
    
    public RegexpJDK14Handler( String pattern ) {
        this.pattern = pattern;
    }

    public RegexpJDK14Handler( String pattern, String message ) {
        this.pattern = pattern;
        this.message = message;
    }

    public void setMessage( String message ) {
        this.message = message;
    }
    
    public boolean isText(Verifiable control) {
      if (control == null) {
        return false;
      } else if (control.getType() == ControlType.TEXT || control.getType() == ControlType.MEMO) {
        return true;
      } else {
        return false;
      }
    }
    public void validate( Verifiable control ) {
        if ( ! control.hasErrorByType( ControlErrorTypes.getErrorType( ControlErrorTypes.REQUIRED_ERROR ) ) ) {
            String value = (String)control.toString();
            if ( ! StringUtils.isEmpty(value) ) {
              if ( ! regexpVerification( value, pattern ) ) {
                  control.addError( ControlErrorTypes.getErrorType( ControlErrorTypes.INPUT_MASK_ERROR ), message );
              }
            }
        }  
        super.validate( control );
    }

    public boolean regexpVerification( String text, String ptrn ) {
      try {
        Pattern p = Pattern.compile(ptrn);
        Matcher matcher = p.matcher(text);
        return matcher.matches();
      } catch (PatternSyntaxException pse) {
        return false; // FIXME: maybe return true
      }
    }
}
//End RegexpJDK14Handler class

