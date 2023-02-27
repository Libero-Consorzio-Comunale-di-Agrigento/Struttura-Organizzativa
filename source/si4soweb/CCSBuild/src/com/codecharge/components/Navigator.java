//Navigator component @0-2700949A
package com.codecharge.components;

import java.util.Vector;
import com.codecharge.events.*;

public class Navigator extends Model {

    public static final int NO_PAGES = -1;
    public static final int SIMPLE = 0;
    public static final int CENTERED = 1;
    public static final int MOVING = 2;

    protected Page page; // Page on which this control lives
    protected int numberOfPages;
    protected int navigatorType;

    public Navigator(String name, Grid parent, Page page) {
       super(name);
       setParent(parent);
       setPage(page);
	   navigatorType = Navigator.NO_PAGES;
       addExcludeParam("ccsForm");
       if (parent != null) addExcludeParam(parent.getName()+"Page");
    }

    /** Get page of this Sorter. This method allows to get Page - root of the controls tree consisting of components and different controls.
       @return page - root of the controls tree */
    public Page getPage() { return page; }
    /** Set page of this Sorter. Called automatically by ModelParser and not used by programmer.
      @parm page page - root of the control tree */
    public void setPage( Page page ) { this.page = page; }

    public int getNumberOfPages() { return numberOfPages; }
    public void setNumberOfPages( int numberOfPages ) { 
        this.numberOfPages = numberOfPages; 
    }

	public int getNavigatorType() { return navigatorType; }
	public void setNavigatorType( int navigatorType ) { 
		this.navigatorType = navigatorType; 
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

//End Navigator component

