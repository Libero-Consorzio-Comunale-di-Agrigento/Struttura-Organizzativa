//EditableGrid component @0-C8A52160
package com.codecharge.components;

import java.util.*;
import com.codecharge.events.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.util.*;
import com.codecharge.validation.*;

public class EditableGrid extends Grid implements IRecord {

    protected int mode;
    protected ArrayList primaryKeys = new ArrayList();
    protected ArrayList cachedColumns = new ArrayList();
    protected ArrayList rowControls = new ArrayList();
    protected ArrayList staticControls = new ArrayList();
    protected boolean allowRead = true;
    protected boolean allowUpdate = true;
    protected boolean allowDelete = true;
    protected boolean allowInsert = true;
    protected String returnPage;
    protected int numberEmptyRows;
    protected PreserveParameterType preserveType;
    protected int rowsFromRequest;

    protected String deleteControlName;

    public EditableGrid(String name) {
        super(name);
    }

    public void setMode(int mode) {this.mode = mode;}
    public int getMode() {return mode;}

    public void setReturnPage(String page) {returnPage = page;}
    public String getReturnPage() {return returnPage;}

    public void setDeleteControlName(String deleteControlName) {this.deleteControlName = deleteControlName;}
    public String getDeleteControlName() {return deleteControlName;}

    /** Specify the number of rows for the new records. */
    public void setNumberEmptyRows(int numberEmptyRows) {this.numberEmptyRows = numberEmptyRows;}
    public int getNumberEmptyRows() {return numberEmptyRows;}

    public PreserveParameterType getPreserveType() {return preserveType;}
    public void setPreserveType( PreserveParameterType type ) {preserveType = type;}

    public boolean currentRowHasErrors() {
        return ( childRow != null && childRow.get(Names.CCS_ROW_ERROR_KEY) != null && ((com.codecharge.validation.ErrorCollection) childRow.get(Names.CCS_ROW_ERROR_KEY)).hasErrors() );
    }

    /** Returns the current row. */
    public HashMap getEmptyRow() {
        HashMap emptyRow = new HashMap();
        Iterator it = getChildren().iterator();
        currentRow++;
        while ( it.hasNext() ){
            Model m = (Model) it.next();
            if ( m instanceof Control ) {
                Control c = (Control) ((Control) m).clone();
                c.setValue(null);
                //c.setDefaultValue(null);
                c.setHtmlName(m.getName() + "_" + currentRow);
                emptyRow.put(m.getName(),c);
            } else if (m instanceof DatePicker) {
                DatePicker dp = (DatePicker) ((DatePicker)m).clone();
                dp.setHtmlName(dp.getControlName() + "_" + currentRow);
                emptyRow.put(dp.getName(), dp);
            } else {
                emptyRow.put(m.getName(),m);
            }
        }
        emptyRow.put(Names.CCS_ROW_IS_NEW_KEY,"true");
        childRow = emptyRow;
        return emptyRow;
    }

    /** indicate that component is processed (parameter ccsForm euqals name of component). */
    public boolean isProcessed() {
        return processed;
    }

    public boolean isShowEmptyRow() {
        return (childRow != null && childRow.get(Names.CCS_ROW_IS_NEW_KEY) != null);
    }

    /** Whether read is allowed for this EditableGrid at this moment. You can change this value with setAllowRead. */
    public boolean isAllowRead() {
        return allowRead;
    }
    /** Set whether read operation is allowed for this EditableGrid. Helpful to disallow read operation from events. */
    public void setAllowRead( boolean allowRead ) {
        this.allowRead = allowRead;
    }

    /** Whether insert operation is allowed for this EditableGrid at this moment. You can change this value with setAllowInsert. */
    public boolean isAllowInsert() {
        return allowInsert;
    }
    /** Set whether insert operation is allowed for this EditableGrid. Helpful to disallow insert operation from events. */
    public void setAllowInsert( boolean allowInsert ) {
        this.allowInsert = allowInsert;
    }

    /** Whether update operation is allowed for this EditableGrid at this moment. You can change this value with setAllowUpdate. */
    public boolean isAllowUpdate() {
        return allowUpdate;
    }
    /** Set whether update operation is allowed for this EditableGrid. Helpful to disallow update operation from events. */
    public void setAllowUpdate( boolean allowUpdate ) {
        this.allowUpdate = allowUpdate;
    }

    /** Whether delete operation is allowed for this EditableGrid at this moment. You can change this value with setAllowDelete. */
    public boolean isAllowDelete() {
        return allowDelete;
    }
    /** Set whether delete operation is allowed for this EditableGrid. Helpful to disallow delete operation from events. */
    public void setAllowDelete( boolean allowDelete ) {
        this.allowDelete = allowDelete;
    }

    public boolean hasReadPermission( int groupId ) {
        if ( permissions == null ) {
            return true;
        } else {
            return permissions.checkPermissions( groupId, Permission.ALLOW_READ );
        }
    }

    public boolean hasInsertPermission( int groupId ) {
        if ( permissions == null ) {
            return true;
        } else {
            return permissions.checkPermissions( groupId, Permission.ALLOW_INSERT );
        }
    }

    public boolean hasUpdatePermission( int groupId ) {
        if ( permissions == null ) {
            return true;
        } else {
            return permissions.checkPermissions( groupId, Permission.ALLOW_UPDATE );
        }
    }

    public boolean hasDeletePermission( int groupId ) {
        if ( permissions == null ) {
            return true;
        } else {
            return permissions.checkPermissions( groupId, Permission.ALLOW_DELETE );
        }
    }

    public void addRowControl(String model) {
        if ( model != null ) {
            rowControls.add(model);
        }
    }

    public Collection getRowControls() {
        return rowControls;
    }

    public void addStaticControl(String model) {
        if ( model != null ) {
            staticControls.add(model);
        }
    }

    public Collection getStaticControls() {
        return staticControls;
    }

    public String getPreserveParameters() {
        String[] p = new String[excludeParams.size()];
        for ( int i = 0; i < excludeParams.size(); i++ ) {
            p[i] = (String) excludeParams.get(i);
        }
        StringBuffer result = new StringBuffer();
        if ( preserveType == PreserveParameterType.GET || preserveType == PreserveParameterType.ALL ) {
            result.append( pageModel.getHttpGetParams().toString( p ) );
        }
        if ( preserveType == PreserveParameterType.POST || preserveType == PreserveParameterType.ALL ) {
            result.append( pageModel.getHttpPostParams().toString( p ) );
        }
        return result.toString();
    }

    public String getFormScript() {
        StringBuffer sb = new StringBuffer("\n<script language=\"JavaScript\">\n<!--\nvar "+getName()+"Elements;\n");
        sb.append("var "+getName()+"EmptyRows = "+getNumberEmptyRows()+";\n");
        int total = 0;
        for (int i = 0; i < rowControls.size(); i++) {
            if (getChild((String) rowControls.get(i)) instanceof VerifiableControl) {
                sb.append("var "+getName()+((String) rowControls.get(i))+"ID = "+i+";\n");
            }
        }
        sb.append("var "+getName()+"DeleteControl = "+rowControls.size()+";\n");
        sb.append("\nfunction init"+getName()+"Elements() {\n");
        sb.append("  var ED = document.forms[\""+getName()+"\"];\n");
        sb.append("  "+getName()+"Elements = new Array (\n");
        int numElements = isProcessed() ? rowsFromRequest : getChildRows().size();
        while (total < numElements + getNumberEmptyRows()) {
            if (total>0) sb.append(",\n");
            total++;
            sb.append("    new Array(");
            for ( int k = 0; k < rowControls.size(); k++ ) {
                if (getChild((String) rowControls.get(k)) instanceof VerifiableControl) {
                    sb.append("ED."+((String) rowControls.get(k))+"_").append(total).append(", ");
                }
            }
            sb.append("ED."+deleteControlName+"_").append(total).append(")");
        }

        sb.append(");\n}\n");
        sb.append("//-->\n</script>\n");
        return sb.toString();
    }

    public void addPrimaryKey( Field key ) {
        primaryKeys.add( key );
    }
    public Iterator getPrimaryKeys() { return primaryKeys.iterator(); }


    private String serializeCachedColumnsRow(HashMap row) {
        StringBuffer sb = new StringBuffer();
        if ( row != null ) {
            ArrayList cColumns = (ArrayList) row.get(Names.CCS_CACHED_COLUMNS);
            if (cColumns != null) {
                Iterator it = cColumns.iterator();
                while ( it.hasNext() ) {
                    CachedColumn c = (CachedColumn) it.next();
                    String columnValue = "";
                    if (c != null) {
                        columnValue = StringUtils.replace(c.getFormattedValue(),"\\","\\\\");
                        columnValue = StringUtils.replace(columnValue,";","\\;");
                    }
                    sb.append(columnValue);
                    if (it.hasNext()) {
                        sb.append(";");
                    }
                }
            }
            if (sb.length()>0) {
                sb.insert(0, ";");
            }
        }
        return sb.toString();
    }

    public String getFormEnctype() {
      for (Iterator i=getChildren().iterator(); i.hasNext(); ) {
        if (i.next() instanceof FileUpload) {
          return "multipart/form-data";
        }
      }
      return "application/x-www-form-urlencoded";
    }

    public String getFormAction() {
      StringBuffer value = new StringBuffer();
      String query = pageModel.getHttpGetParams().toString(new String[] {"ccsForm"});

      String reqURI = pageModel.getRequest().getRequestURI();
      String cPath = pageModel.getRequest().getContextPath();

      if ( reqURI.startsWith( cPath ) ) {
            reqURI = reqURI.substring( cPath.length() - 1 );
      }
      int pos = reqURI.lastIndexOf( '/' );
      if ( pos > -1 ) {
            reqURI = reqURI.substring( pos + 1 );
      }

      value.append( SessionStorage.getInstance( pageModel.getRequest() ).encodeURL( reqURI ));
      value.append("?ccsForm=").append(getName());
      // if (mode == Record.UPDATE_MODE) value.append(":Edit"); EditableGrid doesn't have modes.
      value.append(StringUtils.isEmpty(query)?"":"&"+query);
      return value.toString();
    }

    public String getFormState() {
        StringBuffer sb = new StringBuffer();
        if ( isProcessed() ) {
           sb.append(rowsFromRequest).append(";");
        } else {
          sb.append(childRows.size()).append(";");
        }
        if (numberEmptyRows>0 && allowInsert) {
            sb.append(numberEmptyRows);
        } else {
            sb.append("0");
        }
        Iterator it = cachedColumns.iterator();
        if (amountOfRows==0) return sb.toString();
        else if (it.hasNext()) sb.append(";");
        while (it.hasNext()) {
            String columnName = ((CachedColumn) it.next()).getName();
            columnName = StringUtils.replace(columnName,"\\","\\\\");
            sb.append(StringUtils.replace(columnName,";","\\;"));
            if (it.hasNext()) {
                sb.append(";");
            }
        }
        it = childRows.iterator();
        while ( it.hasNext() ) {
            sb.append( serializeCachedColumnsRow((HashMap) it.next()) );
        }
        return StringUtils.toHtml(sb.toString());
    }

    public void setFormState(String formState) {

        if (StringUtils.isEmpty(formState)) return;

        Enumeration items = StringUtils.split(formState);
        if (items.hasMoreElements()) {
            String item = (String) items.nextElement();
            try {
                amountOfRows = Integer.parseInt(item);
            } catch (NumberFormatException nfe) {
                amountOfRows = 0;
            }
        }
        if (items.hasMoreElements()) {
            String item = (String) items.nextElement();
            try {
                numberEmptyRows = Integer.parseInt(item);
            } catch (NumberFormatException nfe) {
                numberEmptyRows = 0;
            }
        }
        for (int i = 0; i < cachedColumns.size(); i++ ) {
            if (items.hasMoreElements()) {
                String item = (String) items.nextElement();
                if (! item.equals((String) ((CachedColumn)cachedColumns.get(i)).getName() )) {
                    //TODO: error - data corrupted
                    CCLogger.getInstance().error("EditableGrid '"+name+"': FormState is corrupted.");
                }
            } else {
                CCLogger.getInstance().error("EditableGrid '"+name+"': FormState is corrupted.");
            }
        }
        int itemCount = 0;
        int curRow = -1;
        ArrayList columns = null;
        ArrayList keys = null;
        while (items.hasMoreElements()) {
            if (itemCount == 0) {
                columns = new ArrayList();
            }
            for (int i = 0; i < cachedColumns.size(); i++ ) {
                if (items.hasMoreElements()) {
                    String item = (String) items.nextElement();
                    CachedColumn column = (CachedColumn) ((CachedColumn) cachedColumns.get(i)).clone();
                    column.setValue(item);
                    columns.add(column);
                }
            }
            curRow++;
            HashMap row = null;
            if ( curRow < childRows.size() ) {
                row = (HashMap) childRows.get(curRow);
            } else {
                row = getEmptyRow();
            }
            if (curRow < amountOfRows) {
                row.remove(Names.CCS_ROW_IS_NEW_KEY);
            } else {
                row.remove(deleteControlName);
            }
            row.put(Names.CCS_CACHED_COLUMNS, columns);
            if (primaryKeys.size()>0) {
                keys = new ArrayList();
                for (int i = 0; i < columns.size(); i++ ) {
                    for (int j = 0; j < primaryKeys.size(); j++ ) {
                        CachedColumn column = (CachedColumn) columns.get(i);
                        Field key = (Field) ((Field) primaryKeys.get(j)).clone();
                        if ( column.getName().equals(key.getName())) {
                            key.setObjectValue(column.getValue());
                            keys.add(key);
                        }
                    }
                }
                row.put(Names.CCS_PK_KEY, keys);
            }

            if ( curRow >= childRows.size() ) {
                childRows.add(row);
            }
        }
        rowsFromRequest = childRows.size();
		if (rowsFromRequest<amountOfRows) {
			for (int i = rowsFromRequest; i < amountOfRows; i++ ) {
				HashMap row = getEmptyRow();
				row.remove(Names.CCS_ROW_IS_NEW_KEY);
				childRows.add(row);
			}
		}
        for (int i = 0; i < numberEmptyRows; i++) {
            HashMap row = getEmptyRow();
            row.remove(deleteControlName);
            childRows.add(row);
        }
    }

    public void processRows() {
        //mark deleted rows
        for ( int i = 0; i < childRows.size(); i++ ) {
            boolean isDeleted = true;
            Model delCtrl = (Model) ((HashMap) childRows.get(i)).get(deleteControlName);
            if ( delCtrl == null ) {
                isDeleted = false;
            } else {
                if ( delCtrl instanceof CheckBox) {
                    String value = ((CheckBox)delCtrl).getFormattedValue();
                    if (StringUtils.isEmpty(value)) isDeleted = false;
                } else if ( delCtrl instanceof Control ) {
                    Object value = ((Control) delCtrl).getValue();
                    if ( value == null || ( (value instanceof String) && (StringUtils.isEmpty((String) value)) ) ) {
                        isDeleted = false;
                    }
                }
            }
            if ( isDeleted ) {
                ((HashMap) childRows.get(i)).put(Names.CCS_ROW_IS_DELETE_KEY,"true");
            }
        }

        //check insert rows
        if ( allowInsert ) {
        if ( getNumberEmptyRows() > 0 ) {
            int offset = (int) amountOfRows;
            if ( offset >= 0 ) {
                for ( int i = offset; i < childRows.size(); i++ ) {
                    HashMap row = (HashMap) childRows.get(i);
                    if ( row.get(Names.CCS_ROW_IS_DELETE_KEY) == null ) {
                        Iterator controls = row.keySet().iterator();
                        boolean isEmpty = true;
                        while ( controls.hasNext() ) {
                            Control control = null;
                            String name = (String) controls.next();
                            Object obj = row.get(name);
                            if ( obj instanceof Control ) {
                                control = (com.codecharge.components.Control) obj;
                                if (
                                      !(
                                       control.getValue() == null ||
                                       (
                                        (control.getType() == ControlType.TEXT || control.getType() == ControlType.MEMO)
                                        &&
                                        (control.getValue() instanceof String)
                                        &&
                                        StringUtils.isEmpty((String) control.getValue())
                                       )
                                      )
                                      ||
                                      control.hasErrors()
                            		
                                   ) {
                                    isEmpty = false;
                                }
                            }
                        }
                        if ( isEmpty) {
                            ((HashMap) childRows.get(i)).put(Names.CCS_ROW_IS_NOT_APPLY_KEY,"true");
                        }
                    }
                }
            }
        }
        }
    }

    public void checkUnique() {
        Iterator controls = getChildren().iterator();
        while ( controls.hasNext() ) {
            Model m = (Model) controls.next();
            if ( m instanceof VerifiableControl ) {
                VerifiableControl vc = (VerifiableControl) m;
                if ( vc.isUnique() ) {
                    String name = vc.getName();
                    for ( int j = 0; j < childRows.size(); j++ ) {
                        HashMap etlRow = (HashMap) childRows.get(j);
                        if ( etlRow.get(Names.CCS_ROW_IS_NOT_APPLY_KEY) != null ||
                                etlRow.get(Names.CCS_ROW_IS_DELETE_KEY) != null ) {
                            continue;
                        }
                        VerifiableControl etl = (VerifiableControl) etlRow.get(name);
                        if ( etl.hasErrorByType( ControlErrorTypes.getErrorType( ControlErrorTypes.UNIQUE_ERROR ) ) ) {
                            continue;
                        }
                        for ( int i = j+1; i < childRows.size(); i++ ) {
                            HashMap compRow = (HashMap) childRows.get(i);
                            if ( compRow.get(Names.CCS_ROW_IS_NOT_APPLY_KEY) != null ||
                                    compRow.get(Names.CCS_ROW_IS_DELETE_KEY) != null ) {
                                continue;
                            }
                            VerifiableControl comp = (VerifiableControl) compRow.get(name);
                            if ( etl.equals( comp ) ) {
                                comp.addError(ControlErrorTypes.getErrorType(ControlErrorTypes.UNIQUE_ERROR), "Must be Unique");
                            }
                        }
                    }
                } // end if unique
            } // end if VerifiableConrtol
        } // end while by controls
    }

    public void addCachedColumn(String name, String alias, ControlType type) {
        cachedColumns.add(new CachedColumn(name,alias,type,pageModel.getCCSLocale()));
    }
    public void addCachedColumn(String name, ControlType type) {
        addCachedColumn(name, name, type);
    }

    public ArrayList getCachedColumns() {
      return cachedColumns;
    }

    public Object getCachedColumnValue(String name) {
        Object columnValue = null;
        CachedColumn column = getCachedColumn(name);
        if (column != null) {
            columnValue = column.getValue();
        }
        return columnValue;
    }

    public CachedColumn getCachedColumn(String name) {
        CachedColumn result = null;
        ArrayList cols = (ArrayList)currentRow().get(Names.CCS_CACHED_COLUMNS);
        if (cols == null) cols = cachedColumns;
        if (name != null) {
            for (int i=0; i < cols.size(); i++) {
                CachedColumn column = (CachedColumn) cols.get(i);
                if (name.equals(column.getName())) {
                    result = column;
                }
            }
        }
        return result;
    }

	public void hideDeleteControl() {
		if (!StringUtils.isEmpty(deleteControlName)) {
			if (isShowEmptyRow() || ! isAllowDelete()) {
				getChild(deleteControlName).setVisible(false);
			}
		}
	}

	public boolean hasRowErrors() {
		if (childRows==null) return false;
		return (childRow != null && childRow.get(Names.CCS_ROW_ERROR_KEY) != null && 
				((ErrorCollection) childRow.get(Names.CCS_ROW_ERROR_KEY)).hasErrors());
	}
	
    public synchronized void addEditableGridListener(EditableGridListener l) {
        listeners.addElement(l);
    }
    public synchronized void removeEditableGridListener(EditableGridListener l) {
        listeners.removeElement(l);
    }

    public void fireBeforeSelectEvent() {
        Vector v;
        Event e = new Event(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((EditableGridListener)v.elementAt(i)).beforeSelect(e);
        }
    }

    public void fireBeforeShowEvent( Event e ) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((EditableGridListener)v.elementAt(i)).beforeShow(e);
        }
    }

    public void fireBeforeShowRowEvent( Event e ) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((EditableGridListener)v.elementAt(i)).beforeShowRow(e);
        }
    }

    public void fireOnValidateEvent() {
        Vector v;
        Event e = new Event(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((EditableGridListener)v.elementAt(i)).onValidate(e);
        }
    }

    public void fireBeforeSubmitEvent() {
        Vector v;
        Event e = new Event(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((EditableGridListener)v.elementAt(i)).beforeSubmit(e);
        }
    }

    public void fireAfterSubmitEvent() {
        Vector v;
        Event e = new Event(this); // TODO: no such class
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((EditableGridListener)v.elementAt(i)).afterSubmit(e);
        }
    }

//  DataSource Events
    public void fireBeforeBuildSelectEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).beforeBuildSelect(e);
        }
    }
    public void fireBeforeExecuteSelectEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).beforeExecuteSelect(e);
        }
    }
    public void fireAfterExecuteSelectEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).afterExecuteSelect(e);
        }
    }
//  DataSource Events
    public void fireBeforeBuildInsertEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).beforeBuildInsert(e);
        }
    }
    public void fireBeforeExecuteInsertEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).beforeExecuteInsert(e);
        }
    }
    public void fireAfterExecuteInsertEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).afterExecuteInsert(e);
        }
    }
//  DataSource Events
    public void fireBeforeBuildUpdateEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).beforeBuildUpdate(e);
        }
    }
    public void fireBeforeExecuteUpdateEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).beforeExecuteUpdate(e);
        }
    }
    public void fireAfterExecuteUpdateEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).afterExecuteUpdate(e);
        }
    }
//  DataSource Events
    public void fireBeforeBuildDeleteEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).beforeBuildDelete(e);
        }
    }
    public void fireBeforeExecuteDeleteEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).beforeExecuteDelete(e);
        }
    }
    public void fireAfterExecuteDeleteEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).afterExecuteDelete(e);
        }
    }

}

//End EditableGrid component

