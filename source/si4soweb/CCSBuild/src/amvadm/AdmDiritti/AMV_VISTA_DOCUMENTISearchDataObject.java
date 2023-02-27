//AMV_VISTA_DOCUMENTISearch DataSource @31-27D2FD44
package amvadm.AdmDiritti;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AMV_VISTA_DOCUMENTISearch DataSource

//class DataObject Header @31-8A5F1210
public class AMV_VISTA_DOCUMENTISearchDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @31-0991893D
    

    TextField urlS_AREA = new TextField(null, null);
    
    TextField urlS_GRUPPO = new TextField(null, null);
    

    private AMV_VISTA_DOCUMENTISearchRow row = new AMV_VISTA_DOCUMENTISearchRow();

//End attributes of DataObject

//properties of DataObject @31-427E5237

    public void  setUrlS_AREA( String param ) {
        this.urlS_AREA.setValue( param );
    }

    public void  setUrlS_AREA( Object param ) {
        this.urlS_AREA.setValue( param );
    }

    public void  setUrlS_AREA( Object param, Format ignore ) {
        this.urlS_AREA.setValue( param );
    }

    public void  setUrlS_GRUPPO( String param ) {
        this.urlS_GRUPPO.setValue( param );
    }

    public void  setUrlS_GRUPPO( Object param ) {
        this.urlS_GRUPPO.setValue( param );
    }

    public void  setUrlS_GRUPPO( Object param, Format ignore ) {
        this.urlS_GRUPPO.setValue( param );
    }

    public AMV_VISTA_DOCUMENTISearchRow getRow() {
        return row;
    }

    public void setRow( AMV_VISTA_DOCUMENTISearchRow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @31-CC47BC8B
    public AMV_VISTA_DOCUMENTISearchDataObject(Page page) {
        super(page);
    }
//End constructor

//load @31-59315BB6
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select '{s_AREA}' area "
                    + ", '{s_GRUPPO}' gruppo from dual" );
        if ( StringUtils.isEmpty( (String) urlS_AREA.getObjectValue() ) ) urlS_AREA.setValue( "" );
        command.addParameter( "s_AREA", urlS_AREA, null );
        if ( StringUtils.isEmpty( (String) urlS_GRUPPO.getObjectValue() ) ) urlS_GRUPPO.setValue( "" );
        command.addParameter( "s_GRUPPO", urlS_GRUPPO, null );
        if ( ! command.isSetAllParams() ) {
            empty = true;
            ds.closeConnection();
            return true;
        }
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        }

        fireBeforeBuildSelectEvent( new DataObjectEvent(command) );


        fireBeforeExecuteSelectEvent( new DataObjectEvent(command) );

        DbRow record = null;
        if ( ! ds.hasErrors() ) {
            record = command.getOneRow();
        }

        CCLogger.getInstance().debug(command.toString());

        fireAfterExecuteSelectEvent( new DataObjectEvent(command) );

        ds.closeConnection();
//End load

//loadDataBind @31-B558E495
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setS_AREA(Utils.convertToLong(ds.parse(record.get("AREA"), row.getS_AREAField())));
            row.setS_GRUPPO(Utils.convertToString(ds.parse(record.get("GRUPPO"), row.getS_GRUPPOField())));
        }
//End loadDataBind

//End of load @31-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @31-022A50F6
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "s_AREA".equals(name) && "url".equals(prefix) ) {
                param = urlS_AREA;
            } else if ( "s_AREA".equals(name) && prefix == null ) {
                param = urlS_AREA;
            }
            if ( "s_GRUPPO".equals(name) && "url".equals(prefix) ) {
                param = urlS_GRUPPO;
            } else if ( "s_GRUPPO".equals(name) && prefix == null ) {
                param = urlS_GRUPPO;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addRecordDataObjectListener @31-47141785
    public synchronized void addRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.addElement(l);
    }
//End addRecordDataObjectListener

//removeRecordDataObjectListener @31-A1ABC1F4
    public synchronized void removeRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeRecordDataObjectListener

//fireBeforeBuildSelectEvent @31-305A023C
    public void fireBeforeBuildSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeBuildSelect(e);
        }
    }
//End fireBeforeBuildSelectEvent

//fireBeforeExecuteSelectEvent @31-D00ACF95
    public void fireBeforeExecuteSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeExecuteSelect(e);
        }
    }
//End fireBeforeExecuteSelectEvent

//fireAfterExecuteSelectEvent @31-3BAD39CE
    public void fireAfterExecuteSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).afterExecuteSelect(e);
        }
    }
//End fireAfterExecuteSelectEvent

//fireBeforeBuildInsertEvent @31-FBA08B71
    public void fireBeforeBuildInsertEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeBuildInsert(e);
        }
    }
//End fireBeforeBuildInsertEvent

//fireBeforeExecuteInsertEvent @31-47AFA6A5
    public void fireBeforeExecuteInsertEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeExecuteInsert(e);
        }
    }
//End fireBeforeExecuteInsertEvent

//fireAfterExecuteInsertEvent @31-E9CE95AE
    public void fireAfterExecuteInsertEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).afterExecuteInsert(e);
        }
    }
//End fireAfterExecuteInsertEvent

//fireBeforeBuildSelectEvent @31-2405BE8B
    public void fireBeforeBuildUpdateEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeBuildUpdate(e);
        }
    }
//End fireBeforeBuildSelectEvent

//fireBeforeExecuteSelectEvent @31-E9DFF86B
    public void fireBeforeExecuteUpdateEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeExecuteUpdate(e);
        }
    }
//End fireBeforeExecuteSelectEvent

//fireAfterExecuteSelectEvent @31-580A2987
    public void fireAfterExecuteUpdateEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).afterExecuteUpdate(e);
        }
    }
//End fireAfterExecuteSelectEvent

//fireBeforeBuildSelectEvent @31-D021D0EA
    public void fireBeforeBuildDeleteEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeBuildDelete(e);
        }
    }
//End fireBeforeBuildSelectEvent

//fireBeforeExecuteDeleteEvent @31-DD540FBB
    public void fireBeforeExecuteDeleteEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeExecuteDelete(e);
        }
    }
//End fireBeforeExecuteDeleteEvent

//fireAfterExecuteDeleteEvent @31-2A6E2049
    public void fireAfterExecuteDeleteEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).afterExecuteDelete(e);
        }
    }
//End fireAfterExecuteDeleteEvent

//class DataObject Tail @31-ED3F53A4
} // End of class DS
//End class DataObject Tail

