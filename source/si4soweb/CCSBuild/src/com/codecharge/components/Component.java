//Component component @0-9BD083E2
package com.codecharge.components;

import java.util.*;
import java.lang.reflect.*;
import com.codecharge.util.Permission;

/**
  Component represents an element that is composed of other elements.
  Component has children HashMap so that you can iterate through children and get children by name.
  Page, Grid and Record are Components.
  @see Page
  @see Grid
  @see Record
  @see EditableGrid
  @see Directory
  @see Path
 **/
public class Component extends Model {

    /** Collection of children. **/
    protected HashMap children = new HashMap();
    protected Vector parallelChildren = new Vector();
    protected ArrayList childRows = new ArrayList();
    protected HashMap childRow = null;
    protected Iterator itRows = null;
    /** Collection of errors. **/
    protected Vector errors = new Vector();
    protected StringBuffer error;
    protected boolean restricted;
    protected Permission permissions;
    protected int fetchSize;
    protected Page pageModel;

    protected int currentRow;

    //indicate that component is processed (parameter ccsForm euqals name of component)
    protected boolean processed;

    public boolean allowRead = true;

    public Component (String name) {
        super(name);
    }

    public Permission getPermissions() { return permissions; }
    public void setPermissions( Permission permissions ) { this.permissions = permissions; }

    /** Whether users must be logged in before accessing the form. 
     * @return a boolean
     */
    public boolean isRestricted() { return restricted; }
    /** Specify whether users must be logged in before accessing the form.*/
    public void setRestricted( boolean flag ) { restricted = flag; }

    /**  Page to which the component belongs 
     * @return Page to which the component belongs
     */
    public Page getPageModel() {return pageModel;}
    public void setPageModel(Page model) {pageModel = model;}

    public int getCurrentRowNumber() { return currentRow; }
    public void setCurrentRowNumber(int num) { currentRow = num; }

    public int getPageSize() { return 0; }
    public void setPageSize( int size ) { fetchSize = size; }
    public void setPageSize( String size ) {
      try {
        fetchSize = Integer.parseInt(size);
      } catch ( NumberFormatException nfe ) {
        addError("The value parameter "+name+"PageSize is incorrect");
        fetchSize = 0;
      }
    }

    /** indicate that component is processed (parameter ccsForm euqals name of component)
     
    @return a boolean 
        */
    public boolean isProcessed() {
        return false;
    }

    public void setProcessed(boolean processed) {
        this.processed = processed;
    }

    /** Add element to the Children collection. **/
    public void add(Model m) {
        children.put(m.getName(), m);
	parallelChildren.add(m);
        m.setParent( this );
    }

    /** Initialize inner iterator by childRows */
    public void initializeRows() {
        itRows = childRows.iterator();
        currentRow = 0;
    }

    /** Returns true if the iteration has more elements 
     * @return true if the iteration has more elements
     */
    public boolean hasNextRow() {
        if ( itRows == null ) {
            initializeRows();
        }
        return itRows.hasNext();
    }

    /** Returns the next row. If row isn't available returns empty HashMap; never null 
     * @return a HashMap of all the row controls
     */
    public HashMap nextRow() {
        if ( itRows != null ) {
            childRow = (HashMap) itRows.next();
        } else {
            childRow = new HashMap();
        }
        currentRow++;
        return childRow;
    }

    /** Returns the current row. 
     *@return a HashMap of all the row controls
     */
    public HashMap currentRow() {
        return childRow;
    }

    public void nullChildRow() {
      childRow = null;
    }

    /** Find Child in children collection by name.
        @param the Child name
        @return the Child of the given name or null if no such Child
        exists
    */
    public Model getChild(String name) {
        Model m = null;
        if ( childRow != null ) {
            m = (Model) childRow.get(name);
        }
        if ( m == null ) {
            m = (Model) children.get(name);
        }
        return m;
    }

    /** Return all children as collection. 
     * @return a collection of all the children
     */
    public Collection getChildren() {
        //return children.values();
	return parallelChildren;
    }

    /** Find Control in children collection by name.
        @param name the Control name
        @return the Control of the given name or null if no such Control
        exists
    */
    public Control getControl(String name) {
        return (Control) getChild(name);
    }

    /** Find MutableControl in children collection by name.
        @param name the MutableControl name
        @return the MutableControl of the given name or null if no such MutableControl
        exists
    */
    public VerifiableControl getMutableControl(String name) {
        return (VerifiableControl) getChild(name);
    }

    /** Find FileUpload in children collection by name.
        @param name the FileUpload name
        @return the FileUpload of the given name or null if no such FileUpload
        exists
    */
    public FileUpload getFileUpload(String name) {
        return (FileUpload) getChild(name);
    }

    /** Find FileUpload in children collection by name.
        @param name the FileUpload name
        @return the FileUpload of the given name or null if no such FileUpload
        exists
    */
    public Button getButton(String name) {
        return (Button) getChild(name);
    }

    /** Find List in children collection by name.
        @param name the List name
        @return the List of the given name or null if no such List
        exists
    */
    public List getList(String name) {
        return (List) getChild(name);
    }

    /** Find ListBox in children collection by name.
        @param name the ListBox name
        @return the ListBox of the given name or null if no such ListBox
        exists
    */
    public ListBox getListBox(String name) {
        return (ListBox) getChild(name);
    }

    /** Find RadioButton in children collection by name.
        @param name the RadioButton name
        @return the RadioButton of the given name or null if no such RadioButton
        exists
    */
    public RadioButton getRadioButton(String name) {
        return (RadioButton) getChild(name);
    }

    /** Find CheckBoxList in children collection by name.
        @param name the CheckBoxList name
        @return the CheckBoxList of the given name or null if no such CheckBoxList
        exists
    */
    public CheckBoxList getCheckBoxList(String name) {
        return (CheckBoxList) getChild(name);
    }

    /** Find getLink in children collection by name.
        @param name the getLink name
        @return the getLink of the given name or null if no such getLink
        exists
    */
    public Link getLink(String name) {
        return (Link) getChild(name);
    }

    /** Find ImageLink in children collection by name.
        @param name the ImageLink name
        @return the ImageLink of the given name or null if no such ImageLink
        exists
    */
    public ImageLink getImageLink(String name) {
        return (ImageLink) getChild(name);
    }

    /** Find DatePicker in children collection by name.
        @param name the DatePicker name
        @return the DatePicker of the given name or null if no such DatePicker
        exists
    */
    public DatePicker getDatePicker(String name) {
        return (DatePicker) getChild(name);
    }

    public void bind(Hashtable row) {
        Iterator i = getChildren().iterator();
        while (i.hasNext()) {
            Model m = (Model)i.next();
            if (m instanceof Control && ((Control)m).getFieldSource() != null ) {
                ((Control)m).setValueFromDb(row.get(((Control)m).getFieldSource()));
            }
        }
    }

    public void bind(Object objRow) {
        if ( objRow == null ) return;
        Iterator i = getChildren().iterator();
        while (i.hasNext()) {
            Model m = (Model)i.next();
            String methodName = null;
            if (m instanceof Control && ((Control)m).getFieldSource() != null ) {
                String field = ((Control)m).getFieldSource();
                if ( field != null && field.length() > 0 ) {
                    try {
                        methodName = "get" + field.substring(0,1).toUpperCase() +
                                field.substring(1).replace('.' , '_' );
                        Method mget = objRow.getClass().getMethod( methodName, new Class[]{} );
                        if ( mget != null ) {
                            Object value = mget.invoke(objRow,null);
                            if ( value != null ) ((Control)m).setValueFromDb( value );
                        }
                    } catch ( NoSuchMethodException nsme ) {
                      error.append( "Method '"+methodName+"' not found\n" );
                    } catch ( IllegalAccessException iae ) {
                    } catch ( InvocationTargetException ite ) {
                    }
                }
            }
        }
    }

    public boolean checkAccess( int groupId, int permission ) {
        if ( this.permissions == null ) return true;
        return this.permissions.checkPermissions( groupId, permission );
    }

    /** Whether Component has errors. 
   * @return true - if Component has errors; false otherwise
     */
    public boolean hasErrors() {
        return ( errors.size() > 0 );
    }

    /** Get Collection of errors. 
     * @return the collection of errors
     */
    public Vector getErrors() {
        return errors;
    }

    /** Get all errors represented as one string. 
     * @return a String that represent of the all errors. 
     */
    public String getErrorsAsString() {
        StringBuffer sb = new StringBuffer();
        for ( int i = 0; i < errors.size(); i++ ) {
            sb.append( errors.get( i ) );
        }
        return sb.toString();
    }

    /** Add error message to errors collection. 
     * @param error the error message
     */
    public void addError( String error ) {
        errors.add( error );
    }

    /** Add several errors to errors collection. **/
    public void addErrors( Collection errors ) {
        this.errors.addAll( errors );
    }

    public void addChildRow( HashMap row ) {
        if ( row == null ) {
            return;
        }
        childRows.add(row);
    }

    public ArrayList getChildRows() {
        return (ArrayList) childRows.clone();
    }

    public String getFormAction() {
      return "";
    }

    public String getFormState() {
        return "";
    }

    public void setFormState(String formState) {
        return;
    }

}
//End Component component

