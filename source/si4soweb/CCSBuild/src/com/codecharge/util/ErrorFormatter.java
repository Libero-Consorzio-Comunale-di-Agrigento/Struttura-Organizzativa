//ErrorFormatter class @0-E3FD7266
package com.codecharge.util;

public class ErrorFormatter implements Formatter {
    
    private static ErrorFormatter instance;
    
    private ErrorFormatter() {
    }
    
    public static ErrorFormatter getInstance() {
        if ( instance == null ) {
            instance = new ErrorFormatter();
        }
        return instance;
    }
    
    public String formatLine( String line ) {
        return StringUtils.replace(line, "\n", "<br>") + "<br>";
    }
    
}
//End ErrorFormatter class

