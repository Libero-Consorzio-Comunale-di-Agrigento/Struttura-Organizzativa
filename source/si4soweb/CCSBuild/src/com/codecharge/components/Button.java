//Button component @0-E4A2465B
package com.codecharge.components;

import java.util.Vector;
import com.codecharge.events.*;

/**
  Button reacts on user clicks and defines which operation (Insert, Update, Delete, Cancel, Login etc.) should be performed by Record.
**/
public class Button extends Model {

    protected String returnPage;
    protected Page page;
    private String operation;

    /** Create new Button object.
      @param name Name of the button.
      @param page Page to which the button belongs.
    **/
    public Button(String name, Page page) {
      super(name);
      this.page = page;
    }

    /** Page to which the button belongs. **/
    public void setPage(Page page) {this.page = page;}
    /** Page to which the button belongs. **/
    public Page getPage() {return page;}

    /** Page to which redirect after successful button operation.
      @see Record#setReturnPage
    **/
    public void setReturnPage(String returnPage) {this.returnPage=returnPage;}
    /** Page to which redirect after successful button operation.
      @see Record#getReturnPage
    **/
    public String getReturnPage() {return returnPage;}

    /** Predefined operation used to identify special buttons like Insert, Update, Delete, Cancel. **/
    public void setOperation(String op) {this.operation = op;}
    /** Predefined operation used to identify special buttons like Insert, Update, Delete, Cancel. **/
    public String getOperation() {return operation;}

    /** Add Button events handler to the list of listeners. **/
    public synchronized void addButtonListener(ButtonListener l) {
        listeners.addElement(l);
    }

    /** Remove Button events handler from the list of listeners. **/
    public synchronized void removeButtonListener(ButtonListener l) {
        listeners.removeElement(l);
    }


    public void fireOnClickEvent() {
        Vector v;
        Event e = new Event(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((ButtonListener)v.elementAt(i)).onClick(e);
        }
    }

    public void fireBeforeShowEvent(Event e) {
        Vector l;
        e.setSource(this);
        synchronized(this) {l = (Vector)listeners.clone();}
        for (int i=0; i<l.size(); i++) {
            ((ButtonListener)l.elementAt(i)).beforeShow(e);
        }
    }

}
//End Button component

