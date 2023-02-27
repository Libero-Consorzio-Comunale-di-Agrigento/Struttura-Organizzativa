//Sorter component @0-EEFAAB27
package com.codecharge.components;

import java.util.Vector;
import com.codecharge.events.*;

public class Sorter extends Model {

    protected String column;
    protected String reverseColumn;

    protected Page page; // Page on which this control lives

    public Sorter(String name, Grid parent, Page page) {
      super(name);
      setParent(parent);
      setPage(page);
      addExcludeParam("ccsForm");
      if (parent != null) {
        addExcludeParam(parent.getName()+"Order");
        addExcludeParam(parent.getName()+"Dir");
        addExcludeParam(parent.getName()+"Page");
      }
    }

    /** Get page of this Sorter. This method allows to get Page - root of the controls tree consisting of components and different controls.
       @return page - root of the controls tree */
    public Page getPage() { return page; }
    /** Set page of this Sorter. Called automatically by ModelParser and not used by programmer.
      @parm page page - root of the control tree */
    public void setPage( Page page ) { this.page = page; }

    public void setReverseColumn(String column) {this.reverseColumn = column;}
    public void setColumn(String column) {this.column = column;}
    /** Find column by which to sort.
      @param direction State of the active sorter "ASC" or "DESC".
      @return DB column by which to sort.
    **/
    public String getColumn( String direction ) {
      String result = null;
      if ( "desc".equalsIgnoreCase( direction ) ) {
          if ( reverseColumn == null ) {
              result = new String( column + " DESC" );
          } else {
              result = new String( reverseColumn );
          }
      } else {
          result = new String( column );
      }
      return result;
    }

    public synchronized void addControlListener (ControlListener listener) {
        listeners.addElement(listener);
    }
    public synchronized void removeControlListener (ControlListener listener) {
        listeners.removeElement(listener);
    }
    public void fireBeforeShowEvent(Event e) {
        Vector l;
        e.setSource(this);
        synchronized(this) {l = (Vector)listeners.clone();}
        for (int i=0; i<l.size(); i++) {
            ((ControlListener)l.elementAt(i)).beforeShow(e);
        }
    }
}

//End Sorter component

