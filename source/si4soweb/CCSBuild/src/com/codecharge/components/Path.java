//Path component @0-2AE25E62
package com.codecharge.components;

import java.util.*;
import com.codecharge.events.*;
import com.codecharge.util.*;

/**
  Path element shows path to selected category in directory.
*/
public class Path extends Component {

    protected String categoryIdField;
    protected String parentIdField;

    public Path(String name) {
        super(name);
        error = new StringBuffer();
    }

    /** Get name of the field that provides category id. */
    public String getCategoryIdField() {return categoryIdField;}
    /** Set name of the field that provides category id. */
    public void setCategoryIdField(String categoryIdField) {
        this.categoryIdField = categoryIdField;
    }

    /** Get name of the field by which to find parent category. */
    public String getParentIdField() {return parentIdField;}
    /** Set name of the field by which to find parent category. */
    public void setParentIdField(String parentIdField) {
        this.parentIdField = parentIdField;
    }

    public boolean hasReadPermission( int groupId ) {
        if ( permissions == null ) {
            return true;
        } else {
            return permissions.checkPermissions( groupId, Permission.ALLOW_READ );
        }
    }

    public synchronized void addPathListener( PathListener l ) {
        listeners.addElement(l);
    }

    public synchronized void removePathListener( PathListener l ) {
        listeners.removeElement(l);
    }

    public void fireBeforeShowEvent(Event e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((PathListener)v.elementAt(i)).beforeShow(e);
        }
    }

    public void fireBeforeShowCategoryEvent( Event e ) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((PathListener)v.elementAt(i)).beforeShowCategory(e);
        }
    }

    public void fireBeforeSelectEvent(Event e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((PathListener)v.elementAt(i)).beforeSelect(e);
        }
    }

//  DataSource Events
    public void fireBeforeBuildSelectEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((DataObjectListener)v.elementAt(i)).beforeBuildSelect(e);
        }
    }
    public void fireBeforeExecuteSelectEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((DataObjectListener)v.elementAt(i)).beforeExecuteSelect(e);
        }
    }
    public void fireAfterExecuteSelectEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((DataObjectListener)v.elementAt(i)).afterExecuteSelect(e);
        }
    }

}

//End Path component

