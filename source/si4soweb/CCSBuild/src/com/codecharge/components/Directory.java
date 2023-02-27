//Directory component @0-C051A95C
package com.codecharge.components;

import java.util.*;
import com.codecharge.events.*;
import com.codecharge.util.*;

/** Directory represents a list of categories with ability to browse through them. */
public class Directory extends Component {

    public final static String CATEGORY_KEY = "~It's a category~";
    public final static String SUBCATEGORY_KEY = "~It's a subcategory~";
    public final static String LAST_SUBCATEGORY_KEY = "~LASTSUBCAT~";

    /**
        id of current root category
    */
    protected long currentCategoryId;

    /**
        name of category id field
    */
    protected String categoryFieldName;

    /**
        name of subcategory id field
    */
    protected String subcategoryFieldName;

    /**
        number of children rows
        it isn't a number categories nor subcategories
        it is a number rows that were returned from dataSource class
    */
    protected long amountOfRows;

    /**
        number of categories
    */
    protected long numberOfCategories;

    /**
        number of subcategories that will be shown for each category
        if category has more subcategories than <b>numberOfSubCategories</b> then
        will be shown only first numberOfSubCategories subcategories
    */
    protected long numberOfSubCategories;

    /**
        number of columns
    */
    protected long numberOfColumns;

    /**
        number by order of current category
    */
    protected long currentCategoryNumber;

    /**
        number by order of current subcategories
    */
    protected long currentSubCategoryNumber;

    protected long lastCategoryId;

    public Directory(String name) {
        super(name);
        error = new StringBuffer();
        numberOfColumns = 1;
    }

    /** Get currently selected category ID. */
    public long getCurrentCategoryId() { return currentCategoryId; }
    /** Set currently selected category ID. */
    public void setCurrentCategoryId(long currentCategoryId) { this.currentCategoryId = currentCategoryId; }

    /** Get name of the field that holds category name. */
    public String getCategoryFieldName() {return categoryFieldName;}
    /** Set name of the field that holds category name. */
    public void setCategoryFieldName(String categoryFieldName) {
        this.categoryFieldName = categoryFieldName;
    }

    /** Get name of the field through which to get subcategoty name. */
    public String getSubCategoryFieldName() {return subcategoryFieldName;}
    /** Set name of the field through which to get subcategoty name. */
    public void setSubCategoryFieldName(String subcategoryFieldName) {
        this.subcategoryFieldName = subcategoryFieldName;
    }

    /** Get total number of records at current directory level. */
    public long getAmountOfRows() {return amountOfRows;}
    /** Set total number of records at current directory level. */
    public void setAmountOfRows(long count) {this.amountOfRows = count;}

    /** Check whether categories list is empty. */
    public boolean isEmpty() { return (amountOfRows == 0); }

    /** Get the number of categories. */
    public long getNumberOfCategories() {return numberOfCategories;}
    public void setNumberOfCategories(long count) {this.numberOfCategories = count;}

    /** Get the number of subcategories shown for each category. */
    public long getNumberOfSubCategories() {return numberOfSubCategories;}
    /** Specify the number of subcategories shown for each category. */
    public void setNumberOfSubCategories(long count) {this.numberOfSubCategories = count;}

    /** Get the order number of the current category. */
    public long getCurrentCategoryNumber() {return currentCategoryNumber;}
    public void setCurrentCategoryNumber(long currentCategoryNumber) {
        this.currentCategoryNumber = currentCategoryNumber;
    }

    /** Get the order number of the current subcategory. */
    public long getCurrentSubCategoryNumber() {return currentSubCategoryNumber;}
    public void setCurrentSubCategoryNumber(long currentSubCategoryNumber) {
        this.currentSubCategoryNumber = currentSubCategoryNumber;
    }

    /** Get Number of columns this Directory should be showen in. */
    public long getNumberOfColumns() {return numberOfColumns;}
    /** Set Number of columns this Directory should be showen in. */
    public void setNumberOfColumns(long numberOfColumns) {
        this.numberOfColumns = numberOfColumns;
    }

	public boolean isShowCategory() {
		if (childRows==null) return false;
		return ( childRow != null && childRow.get(com.codecharge.components.Directory.CATEGORY_KEY) != null );
	}

	public boolean isShowSubCategory() {
		if (childRows==null) return false;
		return ( childRow != null && childRow.get(com.codecharge.components.Directory.SUBCATEGORY_KEY) != null );
	}

	public boolean isShowSubCategoryTail() {
		if (childRows==null) return false;
		return (getNumberOfSubCategories() > 0 && getCurrentSubCategoryNumber()>=getNumberOfSubCategories());
	}

    public boolean hasReadPermission( int groupId ) {
        if ( permissions == null ) {
            return true;
        } else {
            return permissions.checkPermissions( groupId, Permission.ALLOW_READ );
        }
    }

    /** Iterate over categories list to the next Row. If row isn't available returns empty HashMap; never null.
    @return next row from categories list in form of HashMap. */
    public HashMap nextRow() {
        if ( itRows != null ) {
            childRow = (HashMap) itRows.next();
        } else {
            childRow = new HashMap();
        }
        currentRow++;
        if ( childRow.get(Directory.CATEGORY_KEY) != null ) {
            currentCategoryNumber++;
            currentSubCategoryNumber = 0;
        }
        currentSubCategoryNumber++;
        if ( (numberOfSubCategories > 0) && (currentSubCategoryNumber > numberOfSubCategories ) ) {
            if ( itRows != null ) {
                while ( itRows.hasNext() ) {
                    if ( childRow.get(Directory.CATEGORY_KEY) == null ) {
                        childRow = (HashMap) itRows.next();
                    } else {
                        currentCategoryNumber++;
                        currentSubCategoryNumber = 1;
                        break;
                    }
                }
                if ( childRow.get(Directory.CATEGORY_KEY) == null ) {
                    childRow = new HashMap();
                }
                if ( ! itRows.hasNext() ) {
                    currentSubCategoryNumber = 0;
                }
            }
        }
        return childRow;
    }

    public boolean isNewColumn() {
        long number = 0;
        if ( numberOfColumns == 1 ) return false;
        double numberCatsInColumn = ((double) numberOfCategories)/((double) numberOfColumns);
        number = (int) numberCatsInColumn;
        if ( numberCatsInColumn != number ) {
            number++;
        }
        return ( ((currentCategoryNumber - 1) % number) == 0 );
    }

    /** Get the number of categories in column.
      @return number of categories in column */
    public long getCategoryNumberInColumn() {
        long number = 0;
        if ( numberOfColumns == 1 ) return currentCategoryNumber;
        double numberCatsInColumn = ((double) numberOfCategories)/((double) numberOfColumns);
        number = (int) numberCatsInColumn;
        if ( numberCatsInColumn != number ) {
            number++;
        }
        return ((currentCategoryNumber-1) % number)+1;
    }

    private Vector state;
    public void setStateMachine(Vector machine) {this.state = machine;}
    public Vector getStateMachine() {return state;}

    public synchronized void addDirectoryListener( DirectoryListener l ) {
        listeners.addElement(l);
    }

    public synchronized void removeDirectoryListener( DirectoryListener l ) {
        listeners.removeElement(l);
    }

    public void fireBeforeShowEvent(Event e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((DirectoryListener)v.elementAt(i)).beforeShow(e);
        }
    }
    public void fireBeforeShowCategoryEvent( Event e ) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((DirectoryListener)v.elementAt(i)).beforeShowCategory(e);
        }
    }
    public void fireBeforeShowSubcategoryEvent( Event e ) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((DirectoryListener)v.elementAt(i)).beforeShowSubcategory(e);
        }
    }

    public void fireBeforeSelectEvent(Event e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((DirectoryListener)v.elementAt(i)).beforeSelect(e);
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

//End Directory component

