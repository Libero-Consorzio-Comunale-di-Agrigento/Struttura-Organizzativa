//VerifableControl component @0-CA1F8726
package com.codecharge.components;

import java.util.*;
import com.codecharge.validation.*;
import com.codecharge.events.*;

/** VerifiableControl class is a base class for all editable controls.
  All controls that can be edited from client side extend this class.
  This class also presumes that all controls are validated with validate method. */
public class VerifiableControl extends Control implements Verifiable {

    protected boolean unique;
    protected String errorControlName;
    protected ValidateHandler validateHandler;
    protected ValidateHandler lastValidateHandler;

    public VerifiableControl( String name, String fieldSource, Page page ) {
      super( name, fieldSource, page );
    }
    
    public VerifiableControl( String name, Page page ) {
      super( name, page );
    }

    /** Whether this control should undergo unique validation.
       @return boolean flag that indicates to check uniqeness */
    public boolean isUnique() {
        return unique;
    }

    /** Set whether this control should undergo unique validation.
      @param unique boolean flag that indicates to check uniqeness */
    public void setUnique(boolean unique) {
        this.unique = unique;
    }

    /** Get control name that will show validation error for this control.
       @return errorControlName name of the control that will show error */
    public String getErrorControlName() {
        return errorControlName;
    }
    
    /** Set control name that will show validation error for this control.
       @param errorControlName name of the control that will show error */
    public void setErrorControlName( String errorControlName ) {
        this.errorControlName = errorControlName;
    }

    /** Validate this control. This method calls chain of validation handlers and fires OnValidate Event.
       @return boolean value indicating result of the validation. */
    public boolean validate() {
      fireOnValidateEvent();
      if ( validateHandler != null ) {
        validateHandler.validate( (VerifiableControl) this );
      }
      return ( ! hasErrors() );
    }

    /** Add validation handler to the chain of validation handlers.
       @param handler Validatioin handler */
    public synchronized void addValidateHandler( ValidateHandler handler ) {
      if ( validateHandler == null ) {
        validateHandler = handler;
        lastValidateHandler = handler;
      }  
      else {
        lastValidateHandler.setNextHandler( handler );
        lastValidateHandler = handler;
      }
    }

    /** Remove all validation handlers. */
    public synchronized void removeAllValidateHandler() {
      validateHandler = null;
    }

    /** Remove validation handler from the chain of validation handlers.
      @param handler Validation handler to remove */
    public synchronized void removeValidateHandler( ValidateHandler handler ) {
      if ( handler != null && validateHandler != null ) {
        ValidateHandler vhandler = validateHandler;
        ValidateHandler prevHandler = null;
        while ( vhandler != null ) {
          if ( handler.getClass().getName().equals( vhandler.getClass().getName() ) ) {
            if ( prevHandler == null ) { // remove first handler in chain
              validateHandler = vhandler.getNextHandler();
              vhandler = validateHandler;
            }
            else {
              prevHandler.setNextHandler( vhandler.getNextHandler() );
              vhandler = vhandler.getNextHandler();
            }
          } // End if
          else {
            prevHandler = vhandler;
            vhandler = vhandler.getNextHandler();
          }
        }
      } // End if ( handler != hull && validateHandlers != null )
    } // End of removeValidateHandler( Handler handler )

    public synchronized void addValidationListener(ValidationListener l) {
        listeners.addElement(l);
    }
    public synchronized void removeValidationListener(ValidationListener l) {
        listeners.removeElement(l);
    }
    public void fireOnValidateEvent() {
        Vector l;
        Event e = new Event(this);
        synchronized(this) {l = (Vector)listeners.clone();}
        for (int i=0; i<l.size(); i++) {
            ((ValidationListener)l.elementAt(i)).onValidate(e);
        }
    }
}
//End VerifableControl component

