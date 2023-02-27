//Grid component @0-BC2D7CCE
package com.codecharge.components;

import java.util.*;
import com.codecharge.events.*;
import com.codecharge.util.*;

public class Grid extends Component {

    protected static final int DEFAULT_PAGE = 1;
    protected static final int DEFAULT_SIZE = Integer.MAX_VALUE;

    public Enumeration records;
    public HashMap outParams;

    protected int page = DEFAULT_PAGE;
    protected String sort;
    protected String dir;
    protected boolean more;
    protected long amountOfRows;
    
    private int fetchSize = DEFAULT_SIZE;
    private int fetchSizeLimit;
    private String orderBy = null;

    public String getOrderBy() { return orderBy; }
    public void setOrderBy( String orderBy ) { this.orderBy = orderBy; }

    public Grid(String name) {
        super(name);
        error = new StringBuffer();
    }

    /** Get number of records per page.
       @return number of records per page */
    public int getFetchSize() { return fetchSize; }
    /** Set number of records per page. This value is used to retrieve only
      limited number of records corresponding to current page.
      @param size number of records per page */
    public void setFetchSize( int size ) {
        fetchSize = size; 
        if ( fetchSize < 1 ) {
            if ( fetchSizeLimit > 0 ) {
                fetchSize = fetchSizeLimit;
            } else {
                fetchSize = DEFAULT_SIZE;
            }
        }
    }
    /** Get number of records per page. Equivalent to {@link #getFetchSize getFetchSize}.
      @return number of records per page. */
    public int getPageSize() { return fetchSize; }
    /** Set number of records per page. Equivalent to {@link #setFetchSize setFetchSize}.
      @param size number of records per page. */
    public void setPageSize( int size ) {
      if (size > 0) setFetchSize(size);
    }
    /** Set number of records per page. Used to set grid number of records per page from request parameters.
       @param size number of records per page */
    public void setPageSize( String size ) { 
        try {
            int value = Integer.parseInt(size);
            if (value > 0) fetchSize = value;
        } catch ( NumberFormatException nfe ) {
          //Unable to parse? Leave as is.
            //if ( fetchSizeLimit > 0 ) {
            //    fetchSize = fetchSizeLimit;
            //} else {
            //    fetchSize = DEFAULT_SIZE;
            //}
        }
    }

    /** Get the maximum number of records per page. This property is used
      when {@link #getFetchSize getFetchSize} property is empty to limit output of Grid
      when it returns to many records.
      @return the maximum number of records per page */
    public int getFetchSizeLimit() { return fetchSizeLimit; }
    public void setFetchSizeLimit( int size ) { fetchSizeLimit = size; }
    
    public boolean isEmpty() { return (amountOfRows == 0); }

    /** Set grid page number to show. This method sets grid page number from String,
      handy to set this value from request parameter.
       @param page Integer in form of String */
    public void setPage(String page) {
        try {
            this.page = Integer.parseInt(page);
        } catch (NumberFormatException nfe) {
            this.page = DEFAULT_PAGE;
        }
    }

    /** Set Grid page number to show. This method sets grid page number from int,
      handy to set this value from events as result of arithmetic.
      @param page page number */
    public void setPage(int page) {
        this.page = page;
        if ( this.page < 1 ) {
            this.page = 1;
        }
    }

    /** Get current Grid page.
      @return page number */
    public int getPage() {
        return page;
    }

    /** Set grid sorting.
      @param sort sorter column */
    public void setSort(String sort) {this.sort = sort;}
    /** Set grid sorting. This method is used to set grid sortion from request parameters.
      @param sort sorter column */
    public void setOrder(String sort) {this.sort = sort;}
    /** Get grid sorting. */
    public String getSort() {return sort;}

    /** Set grid sorting direction.
      @param dir grid sorting direction "ASC" or "DESC" */
    public void setDir(String dir) {this.dir = dir;}
    /** Get grid sorting direction.
      @return grid sorting direction "ASC or "DESC" */
    public String getDir() {return dir;}

    public void setCount(long count) {this.amountOfRows = count;}
    public long getCount() {return this.amountOfRows;}

    public void setAmountOfRows(long count) {this.amountOfRows = count;}
    /** Get the total numder of rows. 
     * @return the total numder of rows.
     */
    public long getAmountOfRows() {return amountOfRows;}

    public void setMore(boolean more) {this.more = more;}
    public boolean getMore() {return more;}

    /** Find Sorter in children collection by name.
        @param name the Sorter name
        @return the Sorter of the given name or null if no such Sorter
        exists
    */
    public Sorter getSorter(String name) {
      return (Sorter)getChild(name);
    }
    /** Find Navigator in children collection by name.
        @param name the Navigator name
        @return the Navigator of the given name or null if no such Navigator
        exists
    */
    public Navigator getNavigator(String name) {
      return (Navigator)getChild(name);
    }

    public boolean hasReadPermission( int groupId ) {
        if ( permissions == null ) {
            return true;
        } else {
            return permissions.checkPermissions( groupId, Permission.ALLOW_READ );
        }
    }

    public synchronized void addGridListener( GridListener l ) {
        listeners.addElement(l);
    }

    public synchronized void removeGridListener( GridListener l ) {
        listeners.removeElement(l);
    }

    public void fireBeforeShowEvent( Event e) { // TODO: no such class
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((GridListener)v.elementAt(i)).beforeShow(e);
        }
    }
    public void fireBeforeShowRowEvent( Event e ) { // TODO: no such class
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((GridListener)v.elementAt(i)).beforeShowRow(e);
        }
    }
    public void fireBeforeSelectEvent() {
        Vector v;
        Event e = new Event(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((GridListener)v.elementAt(i)).beforeSelect(e);
        }
    }

//  DataSource Events
    public void fireBeforeBuildSelectEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((GridDataObjectListener)v.elementAt(i)).beforeBuildSelect(e);
        }
    }
    public void fireBeforeExecuteSelectEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((GridDataObjectListener)v.elementAt(i)).beforeExecuteSelect(e);
        }
    }
    public void fireAfterExecuteSelectEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((GridDataObjectListener)v.elementAt(i)).afterExecuteSelect(e);
        }
    }
}

//End Grid component

