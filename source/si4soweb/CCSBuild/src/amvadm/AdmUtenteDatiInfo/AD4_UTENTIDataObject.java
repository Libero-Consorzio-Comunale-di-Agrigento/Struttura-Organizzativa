//AD4_UTENTI DataSource @59-13CDDC89
package amvadm.AdmUtenteDatiInfo;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_UTENTI DataSource

//class DataObject Header @59-587BC4AB
public class AD4_UTENTIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @59-BB7CE011
    

    TextField sesMVUTE = new TextField(null, null);
    

    private AD4_UTENTIRow row = new AD4_UTENTIRow();

//End attributes of DataObject

//properties of DataObject @59-5214400B

    public void  setSesMVUTE( String param ) {
        this.sesMVUTE.setValue( param );
    }

    public void  setSesMVUTE( Object param ) {
        this.sesMVUTE.setValue( param );
    }

    public void  setSesMVUTE( Object param, Format ignore ) {
        this.sesMVUTE.setValue( param );
    }

    public AD4_UTENTIRow getRow() {
        return row;
    }

    public void setRow( AD4_UTENTIRow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @59-BB1D6425
    public AD4_UTENTIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @59-EB86CE5B
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT u.NOMINATIVO NOMINATIVO "
                    + ", AD4_SOGGETTO.GET_NOME(s.SOGGETTO,'Y') NOME "
                    + ",  "
                    + "AD4_SOGGETTO.GET_SESSO(s.SOGGETTO) SESSO "
                    + ",  "
                    + "AD4_SOGGETTO.GET_DATA_NASCITA(s.SOGGETTO) DATA_NASCITA "
                    + ", AD4_SOGGETTO.GET_DES_COMUNE_NAS(s.SOGGETTO) DES_COMUNE_NAS "
                    + ",  "
                    + "AD4_SOGGETTO.GET_DES_PROVINCIA_NAS(s.SOGGETTO) DES_PROVINCIA_NAS "
                    + ",  "
                    + "AD4_SOGGETTO.GET_CODICE_FISCALE(s.SOGGETTO) CODICE_FISCALE "
                    + ",  "
                    + "AD4_SOGGETTO.GET_INDIRIZZO_COMPLETO(s.SOGGETTO) INDIRIZZO_COMPLETO "
                    + ",  "
                    + "AD4_SOGGETTO.GET_INDIRIZZO_WEB(s.SOGGETTO) INDIRIZZO_WEB "
                    + ", AD4_SOGGETTO.GET_TELEFONO(s.SOGGETTO) TELEFONO "
                    + ",  "
                    + "AD4_SOGGETTO.GET_FAX(s.SOGGETTO) FAX "
                    + ",  "
                    + "to_date(AD4_UTENTE.GET_DATA_PASSWORD('{MVUTE}','Y'),'dd/mm/yyyy') DATA_PASSWORD "
                    + ",  "
                    + "decode(AD4_UTENTE.GET_RINNOVO_PASSWORD('{MVUTE}'),'NO','Non rinnovabile','Rinnovabile') RINNOVO_PASSWORD "
                    + ",  "
                    + "to_date(AD4_UTENTE.GET_ULTIMO_TENTATIVO('{MVUTE}'),'dd/mm/yyyy hh24:mi:ss') ULTIMO_TENTATIVO "
                    + ",  "
                    + "decode(AD4_UTENTE.GET_STATO('{MVUTE}'),'U','Attivo','S','Sospeso','R','Revocato') STATO "
                    + ",  "
                    + "u.DATA_INSERIMENTO "
                    + ", u.DATA_AGGIORNAMENTO "
                    + "FROM AD4_UTENTI u,  "
                    + "AD4_UTENTI_SOGGETTI s  "
                    + "WHERE u.UTENTE = '{MVUTE}' AND s.utente = u.utente" );
        if ( StringUtils.isEmpty( (String) sesMVUTE.getObjectValue() ) ) sesMVUTE.setValue( "" );
        command.addParameter( "MVUTE", sesMVUTE, null );
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

//loadDataBind @59-8F32BBF5
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setNOME(Utils.convertToString(ds.parse(record.get("NOME"), row.getNOMEField())));
            row.setSESSO(Utils.convertToString(ds.parse(record.get("SESSO"), row.getSESSOField())));
            row.setCODICE_FISCALE(Utils.convertToString(ds.parse(record.get("CODICE_FISCALE"), row.getCODICE_FISCALEField())));
            row.setDATA_NASCITA(Utils.convertToString(ds.parse(record.get("DATA_NASCITA"), row.getDATA_NASCITAField())));
            row.setDES_COMUNE_NAS(Utils.convertToString(ds.parse(record.get("DES_COMUNE_NAS"), row.getDES_COMUNE_NASField())));
            row.setDES_PROVINCIA_NAS(Utils.convertToString(ds.parse(record.get("DES_PROVINCIA_NAS"), row.getDES_PROVINCIA_NASField())));
            row.setINDIRIZZO_COMPLETO(Utils.convertToString(ds.parse(record.get("INDIRIZZO_COMPLETO"), row.getINDIRIZZO_COMPLETOField())));
            row.setINDIRIZZO_WEB(Utils.convertToString(ds.parse(record.get("INDIRIZZO_WEB"), row.getINDIRIZZO_WEBField())));
            row.setTELEFONO(Utils.convertToString(ds.parse(record.get("TELEFONO"), row.getTELEFONOField())));
            row.setFAX(Utils.convertToString(ds.parse(record.get("FAX"), row.getFAXField())));
            try {
                row.setDATA_PASSWORD(Utils.convertToDate(ds.parse(record.get("DATA_PASSWORD"), row.getDATA_PASSWORDField())));
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid data" );
            }
            row.setRINNOVO_PASSWORD(Utils.convertToString(ds.parse(record.get("RINNOVO_PASSWORD"), row.getRINNOVO_PASSWORDField())));
            try {
                row.setULTIMO_TENTATIVO(Utils.convertToDate(ds.parse(record.get("ULTIMO_TENTATIVO"), row.getULTIMO_TENTATIVOField())));
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid data" );
            }
            row.setSTATO(Utils.convertToString(ds.parse(record.get("STATO"), row.getSTATOField())));
            try {
                row.setDATA_INSERIMENTO(Utils.convertToDate(ds.parse(record.get("DATA_INSERIMENTO"), row.getDATA_INSERIMENTOField())));
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid data" );
            }
            try {
                row.setDATA_AGGIORNAMENTO(Utils.convertToDate(ds.parse(record.get("DATA_AGGIORNAMENTO"), row.getDATA_AGGIORNAMENTOField())));
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid data" );
            }
        }
//End loadDataBind

//End of load @59-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @59-004CC2DF
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "MVUTE".equals(name) && "ses".equals(prefix) ) {
                param = sesMVUTE;
            } else if ( "MVUTE".equals(name) && prefix == null ) {
                param = sesMVUTE;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addRecordDataObjectListener @59-47141785
    public synchronized void addRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.addElement(l);
    }
//End addRecordDataObjectListener

//removeRecordDataObjectListener @59-A1ABC1F4
    public synchronized void removeRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeRecordDataObjectListener

//fireBeforeBuildSelectEvent @59-305A023C
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

//fireBeforeExecuteSelectEvent @59-D00ACF95
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

//fireAfterExecuteSelectEvent @59-3BAD39CE
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

//fireBeforeBuildInsertEvent @59-FBA08B71
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

//fireBeforeExecuteInsertEvent @59-47AFA6A5
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

//fireAfterExecuteInsertEvent @59-E9CE95AE
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

//fireBeforeBuildSelectEvent @59-2405BE8B
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

//fireBeforeExecuteSelectEvent @59-E9DFF86B
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

//fireAfterExecuteSelectEvent @59-580A2987
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

//fireBeforeBuildSelectEvent @59-D021D0EA
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

//fireBeforeExecuteDeleteEvent @59-DD540FBB
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

//fireAfterExecuteDeleteEvent @59-2A6E2049
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

//class DataObject Tail @59-ED3F53A4
} // End of class DS
//End class DataObject Tail

