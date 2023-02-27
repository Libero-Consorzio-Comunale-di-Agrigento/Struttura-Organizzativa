//AD4_UTENTI DataSource @6-DDC74323
package common.AmvModificaPassword;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_UTENTI DataSource

//class DataObject Header @6-587BC4AB
public class AD4_UTENTIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @6-1CE0236F
    

    TextField postNUOVA_PASSWORD = new TextField(null, null);
    
    TextField postCONFERMA_PASSWORD = new TextField(null, null);
    
    TextField postUTENTE = new TextField(null, null);
    
    TextField urlCOD = new TextField(null, null);
    

    private AD4_UTENTIRow row = new AD4_UTENTIRow();

//End attributes of DataObject

//properties of DataObject @6-C5DC5606

    public void  setPostNUOVA_PASSWORD( String param ) {
        this.postNUOVA_PASSWORD.setValue( param );
    }

    public void  setPostNUOVA_PASSWORD( Object param ) {
        this.postNUOVA_PASSWORD.setValue( param );
    }

    public void  setPostNUOVA_PASSWORD( Object param, Format ignore ) {
        this.postNUOVA_PASSWORD.setValue( param );
    }

    public void  setPostCONFERMA_PASSWORD( String param ) {
        this.postCONFERMA_PASSWORD.setValue( param );
    }

    public void  setPostCONFERMA_PASSWORD( Object param ) {
        this.postCONFERMA_PASSWORD.setValue( param );
    }

    public void  setPostCONFERMA_PASSWORD( Object param, Format ignore ) {
        this.postCONFERMA_PASSWORD.setValue( param );
    }

    public void  setPostUTENTE( String param ) {
        this.postUTENTE.setValue( param );
    }

    public void  setPostUTENTE( Object param ) {
        this.postUTENTE.setValue( param );
    }

    public void  setPostUTENTE( Object param, Format ignore ) {
        this.postUTENTE.setValue( param );
    }

    public void  setUrlCOD( String param ) {
        this.urlCOD.setValue( param );
    }

    public void  setUrlCOD( Object param ) {
        this.urlCOD.setValue( param );
    }

    public void  setUrlCOD( Object param, Format ignore ) {
        this.urlCOD.setValue( param );
    }

    public AD4_UTENTIRow getRow() {
        return row;
    }

    public void setRow( AD4_UTENTIRow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @6-BB1D6425
    public AD4_UTENTIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @6-29146898
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT UTENTE UTENTE "
                    + "FROM AD4_UTENTI "
                    + "WHERE note like 'Codice='||'{CODICE}'" );
        if ( StringUtils.isEmpty( (String) urlCOD.getObjectValue() ) ) urlCOD.setValue( "" );
        command.addParameter( "CODICE", urlCOD, null );
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

//loadDataBind @6-977BF228
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setUTENTE(Utils.convertToString(ds.parse(record.get("UTENTE"), row.getUTENTEField())));
        }
//End loadDataBind

//End of load @6-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//update @6-1068A8C7
        boolean update() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMV_UTENTE.MODIFICA_PASSWORD ( ?, ?, ? ) }" );
            if ( StringUtils.isEmpty( (String) postNUOVA_PASSWORD.getObjectValue() ) ) postNUOVA_PASSWORD.setValue( "" );
            command.addParameter( "P_NUOVA_PASSWORD", postNUOVA_PASSWORD, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postCONFERMA_PASSWORD.getObjectValue() ) ) postCONFERMA_PASSWORD.setValue( "" );
            command.addParameter( "P_CONFERMA_PASSWORD", postCONFERMA_PASSWORD, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postUTENTE.getObjectValue() ) ) postUTENTE.setValue( "" );
            command.addParameter( "P_UTENTE", postUTENTE, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );

            fireBeforeBuildUpdateEvent( new DataObjectEvent(command) );


//End update

//updateDataBound @6-0130DCE2
            fireBeforeExecuteUpdateEvent( new DataObjectEvent(command) );

            if ( ! ds.hasErrors() ) {
                command.executeUpdate();
            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteUpdateEvent( new DataObjectEvent(command) );

//End updateDataBound

//End of update @6-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of update

//getParameterByName @6-18CB4C12
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "NUOVA_PASSWORD".equals(name) && "post".equals(prefix) ) {
                param = postNUOVA_PASSWORD;
            } else if ( "NUOVA_PASSWORD".equals(name) && prefix == null ) {
                param = postNUOVA_PASSWORD;
            }
            if ( "CONFERMA_PASSWORD".equals(name) && "post".equals(prefix) ) {
                param = postCONFERMA_PASSWORD;
            } else if ( "CONFERMA_PASSWORD".equals(name) && prefix == null ) {
                param = postCONFERMA_PASSWORD;
            }
            if ( "UTENTE".equals(name) && "post".equals(prefix) ) {
                param = postUTENTE;
            } else if ( "UTENTE".equals(name) && prefix == null ) {
                param = postUTENTE;
            }
            if ( "COD".equals(name) && "url".equals(prefix) ) {
                param = urlCOD;
            } else if ( "COD".equals(name) && prefix == null ) {
                param = urlCOD;
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

