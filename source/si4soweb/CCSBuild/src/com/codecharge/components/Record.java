//Record component @0-B976018F
package com.codecharge.components;

import java.util.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.db.DbRow;

/** Record is form that provides for user ability to edit and insert data into Database.
  Usually it consists of Editable controls (that allow to edit data) and buttons
  (that allow to specify operation to perform). */
public class Record extends Component implements IRecord {

    public static final int UPDATE_MODE = 0;
    public static final int INSERT_MODE = 1;

    //public Hashtable record;
    public DbRow record;
    public HashMap outParams;
    public Object row;
    protected PreserveParameterType preserveType;

    protected int mode;
    protected boolean allowRead = true;
    protected boolean allowUpdate = true;
    protected boolean allowDelete = true;
    protected boolean allowInsert = true;
    protected String returnPage;

    public Record(String name) {
        super(name);
    }

    /** Set Record mode (Edit or Insert).
        @param mode integer constant indicating Edit or Insert mode. */
    public void setMode(int mode) {this.mode = mode;}
    /** Get Record mode (Edit or Insert).
        @return integer constant indicating Edit or Insert mode. */
    public int getMode() {return mode;}

    /** Check whether Record is in Edit mode. */    
    public boolean isEditMode() {
        return mode == Record.UPDATE_MODE;
    }

    /** Set page to redirect after record operation was successful.
        @param page absolute or relative path to Page record will redirect after successful operation. */
    public void setReturnPage(String page) {returnPage = page;}
    /** Get page to redirect after record operation was successful.
        @return absolute or relative path to Page record will redirect after successful operation. */
    public String getReturnPage() {return returnPage;}

    /** indicate that component is processed (parameter ccsForm equals name of component). */
    public boolean isProcessed() {
        return processed;
    }

    /** Whether read is allowed for this Record at this moment. You can change this value with setAllowRead. */
    public boolean isAllowRead() {
        return allowRead;
    }
    /** Set whether read operation is allowed for this Record. Helpful to disallow read operation from events. */
    public void setAllowRead( boolean allowRead ) {
        this.allowRead = allowRead;
    }

    /** Whether insert operation is allowed for this Record at this moment. You can change this value with setAllowInsert. */
    public boolean isAllowInsert() {
        return allowInsert;
    }
    /** Set whether insert operation is allowed for this Record. Helpful to disallow insert operation from events. */
    public void setAllowInsert( boolean allowInsert ) {
        this.allowInsert = allowInsert;
    }

    /** Whether update operation is allowed for this Record at this moment. You can change this value with setAllowUpdate. */
    public boolean isAllowUpdate() {
        return allowUpdate;
    }
    /** Set whether update operation is allowed for this Record. Helpful to disallow update operation from events. */
    public void setAllowUpdate( boolean allowUpdate ) {
        this.allowUpdate = allowUpdate;
    }

    /** Whether delete operation is allowed for this Record at this moment. You can change this value with setAllowDelete. */
    public boolean isAllowDelete() {
        return allowDelete;
    }
    /** Set whether delete operation is allowed for this Record. Helpful to disallow delete operation from events. */
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

    public DbRow getRow() {return record;}
    /*
    public void bind() {
      Iterator i = getChildren().iterator();
      while (i.hasNext()) {
        Model m = (Model)i.next();
        if (m instanceof Control) {
            Control c = (Control)m;
            Object value = null;
            if (StringUtils.isEmpty(c.getFieldSource())) {
              value = model.record.get(c.getFieldSource());
            }
            if (value != null) {
              c.setValueFromDb(value);
            }
        }
      }
    }
    */

    /** Get Encoding type with which this record will send data to server.
      By default it is "application/x-www-form-urlencoded"
      but if Record contains FileUpload it will be "multipart/form-data".
      @return MIME type of the encoding */
    public String getFormEnctype() {
      for (Iterator i=getChildren().iterator(); i.hasNext(); ) {
        if (i.next() instanceof FileUpload) {
          return "multipart/form-data";
        }
      }
      return "application/x-www-form-urlencoded";
    }

    /** Get action to be inserted into action attribute of HTML form element.
      It also contains record preserved parameters and ccsForm parameter
      indicating which form was submitted to server.
      @return Form Action that consists of path to Page, ccsForm parameter and Record preserved parameters. */
    public String getFormAction() {
      StringBuffer value = new StringBuffer();
      String getParams = pageModel.getHttpGetParams().toString(new String[] {"ccsForm"});
      String[] exclude = new String[excludeParams.size()];
      for ( int i = 0; i < excludeParams.size(); i++ ) {
          exclude[i] = (String) excludeParams.get(i);
      }
      String postParams = pageModel.getHttpPostParams().toString(exclude);

      String reqURI = pageModel.getRequest().getRequestURI();
      String cPath = pageModel.getRequest().getContextPath();

      if ( reqURI.startsWith( cPath ) ) {
            reqURI = reqURI.substring( cPath.length() - 1 );
      }
      int pos = reqURI.lastIndexOf( '/' );
      if ( pos > -1 ) {
            reqURI = reqURI.substring( pos + 1 );
      }

      value.append( reqURI );
      value.append("?ccsForm=").append(getName());
      if (mode == UPDATE_MODE) value.append(":Edit");
      value.append(StringUtils.isEmpty(getParams)?"":"&"+getParams);
      boolean errorScreen = pageModel.getHttpGetParams().getParameter("ccsForm") != null;
      if (preserveType == PreserveParameterType.ALL && !errorScreen) {
        value.append(StringUtils.isEmpty(postParams)?"":"&"+postParams);
      }
      return SessionStorage.getInstance( pageModel.getRequest() ).encodeURL(value.toString());
    }

    /** Which parameters to preserve GET, POST or ALL. */
    public PreserveParameterType getPreserveType() {return preserveType;}
    /** Set which parameters to preserve GET, POST or ALL. */
    public void setPreserveType( PreserveParameterType type ) {preserveType = type;}

    /** Get preserved parameters in form of URL encoded String.
        @return URL encoded preserved parameters. */
    public String getPreserveParameters() {
        String[] p = new String[excludeParams.size()];
        for ( int i = 0; i < excludeParams.size(); i++ ) {
            p[i] = (String) excludeParams.get(i);
        }
        StringBuffer result = new StringBuffer();
        if ( preserveType == PreserveParameterType.GET || preserveType == PreserveParameterType.ALL ) {
            result.append( pageModel.getHttpGetParams().toString( p ) );
        }
        return result.toString();
    }

    public synchronized void addRecordListener (RecordListener l) {
        listeners.addElement(l);
    }
    public synchronized void removeRecordListener (RecordListener l) {
        listeners.removeElement(l);
    }

    public void fireBeforeShowEvent( Event e ) { 
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordListener)v.elementAt(i)).beforeShow(e);
        }
    }

    public void fireBeforeSelectEvent() { 
        Vector v;
        Event e = new Event(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordListener)v.elementAt(i)).beforeSelect(e);
        }
    }
    
    public void fireOnValidateEvent() {
        Vector v;
        Event e = new Event(this); 
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordListener)v.elementAt(i)).onValidate(e);
        }
    }
//  DataSource Events
    public void fireBeforeBuildSelectEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeBuildSelect(e);
        }
    }
    public void fireBeforeExecuteSelectEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeExecuteSelect(e);
        }
    }
    public void fireAfterExecuteSelectEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).afterExecuteSelect(e);
        }
    }
    public void fireBeforeInsertEvent() {
        Vector v;
        Event e = new Event(this); // TODO: no such class
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordListener)v.elementAt(i)).beforeInsert(e);
        }
    }
//  DataSource Events
    public void fireBeforeBuildInsertEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeBuildInsert(e);
        }
    }
    public void fireBeforeExecuteInsertEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeExecuteInsert(e);
        }
    }
    public void fireAfterExecuteInsertEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).afterExecuteInsert(e);
        }
    }
    public void fireAfterInsertEvent() {
        Vector v;
        Event e = new Event(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordListener)v.elementAt(i)).afterInsert(e);
        }
    }
    public void fireBeforeUpdateEvent() {
        Vector v;
        Event e = new Event(this); // TODO: no such class
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordListener)v.elementAt(i)).beforeUpdate(e);
        }
    }
//  DataSource Events
    public void fireBeforeBuildUpdateEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeBuildUpdate(e);
        }
    }
    public void fireBeforeExecuteUpdateEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeExecuteUpdate(e);
        }
    }
    public void fireAfterExecuteUpdateEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).afterExecuteUpdate(e);
        }
    }
    public void fireAfterUpdateEvent() {
        Vector v;
        Event e = new Event(this); // TODO: no such class
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordListener)v.elementAt(i)).afterUpdate(e);
        }
    }
    public void fireBeforeDeleteEvent() {
        Vector v;
        Event e = new Event(this); // TODO: no such class
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordListener)v.elementAt(i)).beforeDelete(e);
        }
    }
//  DataSource Events
    public void fireBeforeBuildDeleteEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeBuildDelete(e);
        }
    }
    public void fireBeforeExecuteDeleteEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeExecuteDelete(e);
        }
    }
    public void fireAfterExecuteDeleteEvent(DataObjectEvent e) {
        Vector v;
        e.setSource(this);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).afterExecuteDelete(e);
        }
    }
    public void fireAfterDeleteEvent() {
        Vector v;
        Event e = new Event(this); // TODO: no such class
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i<v.size(); i++) {
            ((RecordListener)v.elementAt(i)).afterDelete(e);
        }
    }
}

//End Record component

