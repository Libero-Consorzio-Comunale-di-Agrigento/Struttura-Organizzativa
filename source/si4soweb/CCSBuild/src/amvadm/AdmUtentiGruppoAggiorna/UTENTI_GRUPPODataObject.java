//UTENTI_GRUPPO DataSource @2-38B7FA0F
package amvadm.AdmUtentiGruppoAggiorna;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End UTENTI_GRUPPO DataSource

//class DataObject Header @2-089FBA0B
public class UTENTI_GRUPPODataObject extends DS {
//End class DataObject Header

//attributes of DataObject @2-749AEE4B
    

    TextField sesUtente = new TextField(null, null);
    TextField urlP_DB_USER = new TextField(null, null);
    TextField sesProgetto = new TextField(null, null);
    TextField urlSTYLESHEET = new TextField(null, null);
    TextField urlMVUTE = new TextField(null, null);
    TextField urlMVGRU = new TextField(null, null);

    private UTENTI_GRUPPORow row = new UTENTI_GRUPPORow();

//End attributes of DataObject

//properties of DataObject @2-CFED12EA

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

    public void  setUrlP_DB_USER( String param ) {
        this.urlP_DB_USER.setValue( param );
    }

    public void  setUrlP_DB_USER( Object param ) {
        this.urlP_DB_USER.setValue( param );
    }

    public void  setUrlP_DB_USER( Object param, Format ignore ) {
        this.urlP_DB_USER.setValue( param );
    }

    public void  setSesProgetto( String param ) {
        this.sesProgetto.setValue( param );
    }

    public void  setSesProgetto( Object param ) {
        this.sesProgetto.setValue( param );
    }

    public void  setSesProgetto( Object param, Format ignore ) {
        this.sesProgetto.setValue( param );
    }

    public void  setUrlSTYLESHEET( String param ) {
        this.urlSTYLESHEET.setValue( param );
    }

    public void  setUrlSTYLESHEET( Object param ) {
        this.urlSTYLESHEET.setValue( param );
    }

    public void  setUrlSTYLESHEET( Object param, Format ignore ) {
        this.urlSTYLESHEET.setValue( param );
    }

    public void  setUrlMVUTE( String param ) {
        this.urlMVUTE.setValue( param );
    }

    public void  setUrlMVUTE( Object param ) {
        this.urlMVUTE.setValue( param );
    }

    public void  setUrlMVUTE( Object param, Format ignore ) {
        this.urlMVUTE.setValue( param );
    }

    public void  setUrlMVGRU( String param ) {
        this.urlMVGRU.setValue( param );
    }

    public void  setUrlMVGRU( Object param ) {
        this.urlMVGRU.setValue( param );
    }

    public void  setUrlMVGRU( Object param, Format ignore ) {
        this.urlMVGRU.setValue( param );
    }

    public UTENTI_GRUPPORow getRow() {
        return row;
    }

    public void setRow( UTENTI_GRUPPORow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @2-8E2E17E3
    public UTENTI_GRUPPODataObject(Page page) {
        super(page);
    }
//End constructor

//load @2-3EA8DF12
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select '{Utente}' P_UTENTE, '{Gruppo}' P_GRUPPO from dual" );
        if ( StringUtils.isEmpty( (String) urlMVUTE.getObjectValue() ) ) urlMVUTE.setValue( "" );
        command.addParameter( "Utente", urlMVUTE, null );
        if ( StringUtils.isEmpty( (String) urlMVGRU.getObjectValue() ) ) urlMVGRU.setValue( "" );
        command.addParameter( "Gruppo", urlMVGRU, null );
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

//loadDataBind @2-73E6B559
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setUTENTE(Utils.convertToString(ds.parse(record.get("P_UTENTE"), row.getUTENTEField())));
            row.setP_GRUPPO(Utils.convertToString(ds.parse(record.get("P_GRUPPO"), row.getP_GRUPPOField())));
        }
//End loadDataBind

//End of load @2-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//update @2-F3105114
        boolean update() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMVWEB.SET_STYLE ( ?, ?, ?, ? ) }" );
            if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
            command.addParameter( "P_UTENTE", sesUtente, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) urlP_DB_USER.getObjectValue() ) ) urlP_DB_USER.setValue( "" );
            command.addParameter( "P_DB_USER", urlP_DB_USER, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "" );
            command.addParameter( "P_PROGETTO", sesProgetto, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) urlSTYLESHEET.getObjectValue() ) ) urlSTYLESHEET.setValue( "" );
            command.addParameter( "P_STYLESHEET", urlSTYLESHEET, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );

            fireBeforeBuildUpdateEvent( new DataObjectEvent(command) );


//End update

//updateDataBound @2-0130DCE2
            fireBeforeExecuteUpdateEvent( new DataObjectEvent(command) );

            if ( ! ds.hasErrors() ) {
                command.executeUpdate();
            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteUpdateEvent( new DataObjectEvent(command) );

//End updateDataBound

//End of update @2-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of update

//getParameterByName @2-CD473F99
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "P_DB_USER".equals(name) && "url".equals(prefix) ) {
                param = urlP_DB_USER;
            } else if ( "P_DB_USER".equals(name) && prefix == null ) {
                param = urlP_DB_USER;
            }
            if ( "Progetto".equals(name) && "ses".equals(prefix) ) {
                param = sesProgetto;
            } else if ( "Progetto".equals(name) && prefix == null ) {
                param = sesProgetto;
            }
            if ( "STYLESHEET".equals(name) && "url".equals(prefix) ) {
                param = urlSTYLESHEET;
            } else if ( "STYLESHEET".equals(name) && prefix == null ) {
                param = urlSTYLESHEET;
            }
            if ( "MVUTE".equals(name) && "url".equals(prefix) ) {
                param = urlMVUTE;
            } else if ( "MVUTE".equals(name) && prefix == null ) {
                param = urlMVUTE;
            }
            if ( "MVGRU".equals(name) && "url".equals(prefix) ) {
                param = urlMVGRU;
            } else if ( "MVGRU".equals(name) && prefix == null ) {
                param = urlMVGRU;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addRecordDataObjectListener @2-47141785
    public synchronized void addRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.addElement(l);
    }
//End addRecordDataObjectListener

//removeRecordDataObjectListener @2-A1ABC1F4
    public synchronized void removeRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeRecordDataObjectListener

//fireBeforeBuildSelectEvent @2-305A023C
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

//fireBeforeExecuteSelectEvent @2-D00ACF95
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

//fireAfterExecuteSelectEvent @2-3BAD39CE
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

//fireBeforeBuildInsertEvent @2-FBA08B71
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

//fireBeforeExecuteInsertEvent @2-47AFA6A5
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

//fireAfterExecuteInsertEvent @2-E9CE95AE
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

//fireBeforeBuildSelectEvent @2-2405BE8B
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

//fireBeforeExecuteSelectEvent @2-E9DFF86B
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

//fireAfterExecuteSelectEvent @2-580A2987
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

//fireBeforeBuildSelectEvent @2-D021D0EA
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

//fireBeforeExecuteDeleteEvent @2-DD540FBB
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

//fireAfterExecuteDeleteEvent @2-2A6E2049
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

//class DataObject Tail @2-ED3F53A4
} // End of class DS
//End class DataObject Tail

