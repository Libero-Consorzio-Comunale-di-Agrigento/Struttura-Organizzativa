//AD4_RICHIESTE_ABILITAZIONE DataSource @6-13CB8F63
package amvadm.AdmRichiestaNotifica;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_RICHIESTE_ABILITAZIONE DataSource

//class DataObject Header @6-D8D2B3E8
public class AD4_RICHIESTE_ABILITAZIONEDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @6-EF486666
    

    TextField postTIPO_NOTIFICA = new TextField(null, null);
    
    TextField postINDIRIZZO_NOTIFICA = new TextField(null, null);
    
    TextField urlID = new TextField(null, null);
    

    private AD4_RICHIESTE_ABILITAZIONERow row = new AD4_RICHIESTE_ABILITAZIONERow();

//End attributes of DataObject

//properties of DataObject @6-DF355528

    public void  setPostTIPO_NOTIFICA( String param ) {
        this.postTIPO_NOTIFICA.setValue( param );
    }

    public void  setPostTIPO_NOTIFICA( Object param ) {
        this.postTIPO_NOTIFICA.setValue( param );
    }

    public void  setPostTIPO_NOTIFICA( Object param, Format ignore ) {
        this.postTIPO_NOTIFICA.setValue( param );
    }

    public void  setPostINDIRIZZO_NOTIFICA( String param ) {
        this.postINDIRIZZO_NOTIFICA.setValue( param );
    }

    public void  setPostINDIRIZZO_NOTIFICA( Object param ) {
        this.postINDIRIZZO_NOTIFICA.setValue( param );
    }

    public void  setPostINDIRIZZO_NOTIFICA( Object param, Format ignore ) {
        this.postINDIRIZZO_NOTIFICA.setValue( param );
    }

    public void  setUrlID( String param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlID( Object param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlID( Object param, Format ignore ) {
        this.urlID.setValue( param );
    }

    public AD4_RICHIESTE_ABILITAZIONERow getRow() {
        return row;
    }

    public void setRow( AD4_RICHIESTE_ABILITAZIONERow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @6-CBCD891C
    public AD4_RICHIESTE_ABILITAZIONEDataObject(Page page) {
        super(page);
    }
//End constructor

//load @6-6FD34C85
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT m.descrizione||' - '||i.descrizione servizio "
                    + ", u.nominativo richiedente "
                    + ",  "
                    + "r.data data,  "
                    + "decode(r.stato,'C','In attesa di approvazione (Dati convalidati)','F',  "
                    + "'In attesa di revisione (Dati non corretti)','A','Approvata','R','Respinta') stato "
                    + ", r.tipo_notifica tipo_notifica "
                    + ",  "
                    + "r.indirizzo_notifica indirizzo_notifica "
                    + " FROM ad4_richieste_abilitazione r, ad4_istanze i, ad4_moduli m,  "
                    + "ad4_utenti u "
                    + "WHERE r.modulo = m.modulo "
                    + "AND r.istanza = i.istanza "
                    + "AND r.utente = u.utente "
                    + "AND r.id_richiesta = '{ID}'" );
        if ( StringUtils.isEmpty( (String) urlID.getObjectValue() ) ) urlID.setValue( "" );
        command.addParameter( "ID", urlID, null );
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

//loadDataBind @6-E655EAD8
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setSERVIZIO(Utils.convertToString(ds.parse(record.get("SERVIZIO"), row.getSERVIZIOField())));
            row.setTIPO_NOTIFICA(Utils.convertToString(ds.parse(record.get("TIPO_NOTIFICA"), row.getTIPO_NOTIFICAField())));
            row.setINDIRIZZO_NOTIFICA(Utils.convertToString(ds.parse(record.get("INDIRIZZO_NOTIFICA"), row.getINDIRIZZO_NOTIFICAField())));
        }
//End loadDataBind

//End of load @6-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//update @6-49C09F1C
        boolean update() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            command.setNeedQuotes(true);
            command.setSql("UPDATE AD4_RICHIESTE_ABILITAZIONE SET TIPO_NOTIFICA = {postTIPO_NOTIFICA}, INDIRIZZO_NOTIFICA = {postINDIRIZZO_NOTIFICA}");
            command.addParameter("postTIPO_NOTIFICA", postTIPO_NOTIFICA);
            command.addParameter("postINDIRIZZO_NOTIFICA", postINDIRIZZO_NOTIFICA);

            fireBeforeBuildUpdateEvent( new DataObjectEvent(command) );

            String where1 = WhereParams.rawOperation( "ID_RICHIESTA", FieldOperation.EQUAL, urlID, null, ds );
            if (StringUtils.isEmpty(where1)) command.setCmdExecution(false);
            String whereParams = where1;

            if ( where1 == null ) {
                addError(getResourceBundle().getString("CustomOperationError_MissingParameters"));
            }
            if ( ! StringUtils.isEmpty(whereParams) ) {
                if ( ! StringUtils.isEmpty(command.getWhere()) ) {
                    command.setWhere( command.getWhere() + " AND (" + whereParams + ")" );
                } else {
                    command.setWhere( whereParams );
                }
            }

//End update

//updateDataBound @6-35E17193
            fireBeforeExecuteUpdateEvent( new DataObjectEvent(command) );
            if (!command.isCmdExecution()) {
                ds.closeConnection();
                return false;
            }

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

//getParameterByName @6-F38006DD
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "TIPO_NOTIFICA".equals(name) && "post".equals(prefix) ) {
                param = postTIPO_NOTIFICA;
            } else if ( "TIPO_NOTIFICA".equals(name) && prefix == null ) {
                param = postTIPO_NOTIFICA;
            }
            if ( "INDIRIZZO_NOTIFICA".equals(name) && "post".equals(prefix) ) {
                param = postINDIRIZZO_NOTIFICA;
            } else if ( "INDIRIZZO_NOTIFICA".equals(name) && prefix == null ) {
                param = postINDIRIZZO_NOTIFICA;
            }
            if ( "ID".equals(name) && "url".equals(prefix) ) {
                param = urlID;
            } else if ( "ID".equals(name) && prefix == null ) {
                param = urlID;
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

