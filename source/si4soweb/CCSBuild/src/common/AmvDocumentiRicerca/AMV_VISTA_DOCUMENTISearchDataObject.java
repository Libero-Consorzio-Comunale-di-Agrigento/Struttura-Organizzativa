//AMV_VISTA_DOCUMENTISearch DataSource @6-02CBA6C0
package common.AmvDocumentiRicerca;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AMV_VISTA_DOCUMENTISearch DataSource

//class DataObject Header @6-8A5F1210
public class AMV_VISTA_DOCUMENTISearchDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @6-D2800E7B
    

    TextField urlMVTD = new TextField(null, null);
    
    TextField urlS_ID_TIPOLOGIA = new TextField(null, null);
    
    TextField urlS_ID_CATEGORIA = new TextField(null, null);
    
    TextField urlID_CATEGORIA = new TextField(null, null);
    

    private AMV_VISTA_DOCUMENTISearchRow row = new AMV_VISTA_DOCUMENTISearchRow();

//End attributes of DataObject

//properties of DataObject @6-7AF5973B

    public void  setUrlMVTD( String param ) {
        this.urlMVTD.setValue( param );
    }

    public void  setUrlMVTD( Object param ) {
        this.urlMVTD.setValue( param );
    }

    public void  setUrlMVTD( Object param, Format ignore ) {
        this.urlMVTD.setValue( param );
    }

    public void  setUrlS_ID_TIPOLOGIA( String param ) {
        this.urlS_ID_TIPOLOGIA.setValue( param );
    }

    public void  setUrlS_ID_TIPOLOGIA( Object param ) {
        this.urlS_ID_TIPOLOGIA.setValue( param );
    }

    public void  setUrlS_ID_TIPOLOGIA( Object param, Format ignore ) {
        this.urlS_ID_TIPOLOGIA.setValue( param );
    }

    public void  setUrlS_ID_CATEGORIA( String param ) {
        this.urlS_ID_CATEGORIA.setValue( param );
    }

    public void  setUrlS_ID_CATEGORIA( Object param ) {
        this.urlS_ID_CATEGORIA.setValue( param );
    }

    public void  setUrlS_ID_CATEGORIA( Object param, Format ignore ) {
        this.urlS_ID_CATEGORIA.setValue( param );
    }

    public void  setUrlID_CATEGORIA( String param ) {
        this.urlID_CATEGORIA.setValue( param );
    }

    public void  setUrlID_CATEGORIA( Object param ) {
        this.urlID_CATEGORIA.setValue( param );
    }

    public void  setUrlID_CATEGORIA( Object param, Format ignore ) {
        this.urlID_CATEGORIA.setValue( param );
    }

    public AMV_VISTA_DOCUMENTISearchRow getRow() {
        return row;
    }

    public void setRow( AMV_VISTA_DOCUMENTISearchRow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @6-CC47BC8B
    public AMV_VISTA_DOCUMENTISearchDataObject(Page page) {
        super(page);
    }
//End constructor

//load @6-F9F35707
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select nvl('{MVTD}','{s_ID_TIPOLOGIA}') tipologia "
                    + ",  "
                    + "nvl('{ID_CATEGORIA}','{s_ID_CATEGORIA}') categoria "
                    + ", 'Informazioni per la ricerca' info "
                    + " from dual" );
        if ( StringUtils.isEmpty( (String) urlMVTD.getObjectValue() ) ) urlMVTD.setValue( "" );
        command.addParameter( "MVTD", urlMVTD, null );
        if ( StringUtils.isEmpty( (String) urlS_ID_TIPOLOGIA.getObjectValue() ) ) urlS_ID_TIPOLOGIA.setValue( "" );
        command.addParameter( "s_ID_TIPOLOGIA", urlS_ID_TIPOLOGIA, null );
        if ( StringUtils.isEmpty( (String) urlS_ID_CATEGORIA.getObjectValue() ) ) urlS_ID_CATEGORIA.setValue( "" );
        command.addParameter( "s_ID_CATEGORIA", urlS_ID_CATEGORIA, null );
        if ( StringUtils.isEmpty( (String) urlID_CATEGORIA.getObjectValue() ) ) urlID_CATEGORIA.setValue( "" );
        command.addParameter( "ID_CATEGORIA", urlID_CATEGORIA, null );
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

//loadDataBind @6-FCC214A2
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setS_ID_TIPOLOGIA(Utils.convertToLong(ds.parse(record.get("TIPOLOGIA"), row.getS_ID_TIPOLOGIAField())));
        }
//End loadDataBind

//End of load @6-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @6-CFC5282D
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "MVTD".equals(name) && "url".equals(prefix) ) {
                param = urlMVTD;
            } else if ( "MVTD".equals(name) && prefix == null ) {
                param = urlMVTD;
            }
            if ( "s_ID_TIPOLOGIA".equals(name) && "url".equals(prefix) ) {
                param = urlS_ID_TIPOLOGIA;
            } else if ( "s_ID_TIPOLOGIA".equals(name) && prefix == null ) {
                param = urlS_ID_TIPOLOGIA;
            }
            if ( "s_ID_CATEGORIA".equals(name) && "url".equals(prefix) ) {
                param = urlS_ID_CATEGORIA;
            } else if ( "s_ID_CATEGORIA".equals(name) && prefix == null ) {
                param = urlS_ID_CATEGORIA;
            }
            if ( "ID_CATEGORIA".equals(name) && "url".equals(prefix) ) {
                param = urlID_CATEGORIA;
            } else if ( "ID_CATEGORIA".equals(name) && prefix == null ) {
                param = urlID_CATEGORIA;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addRecordDataObjectListener @6-47141785
    public synchronized void addRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.addElement(l);
    }
//End addRecordDataObjectListener

//removeRecordDataObjectListener @6-A1ABC1F4
    public synchronized void removeRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeRecordDataObjectListener

//fireBeforeBuildSelectEvent @6-305A023C
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

//fireBeforeExecuteSelectEvent @6-D00ACF95
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

//fireAfterExecuteSelectEvent @6-3BAD39CE
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

//fireBeforeBuildInsertEvent @6-FBA08B71
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

//fireBeforeExecuteInsertEvent @6-47AFA6A5
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

//fireAfterExecuteInsertEvent @6-E9CE95AE
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

//fireBeforeBuildSelectEvent @6-2405BE8B
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

//fireBeforeExecuteSelectEvent @6-E9DFF86B
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

//fireAfterExecuteSelectEvent @6-580A2987
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

//fireBeforeBuildSelectEvent @6-D021D0EA
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

//fireBeforeExecuteDeleteEvent @6-DD540FBB
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

//fireAfterExecuteDeleteEvent @6-2A6E2049
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

//class DataObject Tail @6-ED3F53A4
} // End of class DS
//End class DataObject Tail

