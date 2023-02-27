//ErrorCollection class @0-94C5E795
package com.codecharge.validation;

import java.util.ArrayList;
import java.util.Collection;

import com.codecharge.util.Formatter;

public class ErrorCollection {
    
    /** Collection of errors. **/
    protected ArrayList errors = new ArrayList();

    /** Error formatter. Called by adding new error. */
    protected Formatter addingFormatter;

    /** Line formatter. Called from getErrorsAsString */
    protected Formatter showingFormatter;
    
    /** Whether Component has errors. **/
    public boolean hasErrors() {
        return ( errors.size() > 0 );
    }

    /** Get Collection of errors. **/
    public Collection getErrors() {
        return errors;
    }

    /** Add several errors to errors collection. **/
    public void addErrors( Collection errors ) {
        this.errors.addAll( errors );
    }

    /** Add Error to errors collection. **/
    public void addError( String error ) {
        String fError = error;
        if ( addingFormatter != null ) {
            fError = addingFormatter.formatLine(error);
        }
        if ( fError != null ) {
            errors.add( error );
        }
    }

    /** Get all errors represented as one string. **/
    public String getErrorsAsString() {
        StringBuffer sb = new StringBuffer();
        String fError = null;
        for ( int i = 0; i < errors.size(); i++ ) {
            fError = (String) errors.get( i );
            if ( showingFormatter != null ) {
                fError = showingFormatter.formatLine(fError);
            }
            if ( fError != null ) {
                sb.append( fError );
            }
        }
        return sb.toString();
    }

    public void setAddingFormatter(Formatter formatter) {
        addingFormatter = formatter;
    }
    
    public void setShowingFormatter(Formatter formatter) {
        showingFormatter = formatter;
    }
    
}
//End ErrorCollection class

