//RICHIESTA_INOLTRA DataSource @6-7683D9A6
package common.AmvRichiestaInoltra;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End RICHIESTA_INOLTRA DataSource

//class DataObject Header @6-317D2E2D
public class RICHIESTA_INOLTRADataObject extends DS {
//End class DataObject Header

//attributes of DataObject @6-6AD5F075
    

    DoubleField sesMVIDRIC = new DoubleField(null, null);
    
    DoubleField sesMVREVRIC = new DoubleField(null, null);
    
    TextField sesMVSF = new TextField(null, null);
    
    TextField urlP_NOTE = new TextField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    TextField urlP_DESTINATARIO = new TextField(null, null);
    
    TextField postNOTE = new TextField(null, null);
    
    TextField postUTENTE_REDAZIONE = new TextField(null, null);
    

    private RICHIESTA_INOLTRARow row = new RICHIESTA_INOLTRARow();

//End attributes of DataObject

//properties of DataObject @6-B12CC427

    public void  setSesMVIDRIC( double param ) {
        this.sesMVIDRIC.setValue( param );
    }

    public void  setSesMVIDRIC( double param, Format ignore ) throws java.text.ParseException {
        this.sesMVIDRIC.setValue( param );
    }

    public void  setSesMVIDRIC( Object param, Format format ) throws java.text.ParseException {
        this.sesMVIDRIC.setValue( param, format );
    }

    public void  setSesMVIDRIC( Double param ) {
        this.sesMVIDRIC.setValue( param );
    }

    public void  setSesMVREVRIC( double param ) {
        this.sesMVREVRIC.setValue( param );
    }

    public void  setSesMVREVRIC( double param, Format ignore ) throws java.text.ParseException {
        this.sesMVREVRIC.setValue( param );
    }

    public void  setSesMVREVRIC( Object param, Format format ) throws java.text.ParseException {
        this.sesMVREVRIC.setValue( param, format );
    }

    public void  setSesMVREVRIC( Double param ) {
        this.sesMVREVRIC.setValue( param );
    }

    public void  setSesMVSF( String param ) {
        this.sesMVSF.setValue( param );
    }

    public void  setSesMVSF( Object param ) {
        this.sesMVSF.setValue( param );
    }

    public void  setSesMVSF( Object param, Format ignore ) {
        this.sesMVSF.setValue( param );
    }

    public void  setUrlP_NOTE( String param ) {
        this.urlP_NOTE.setValue( param );
    }

    public void  setUrlP_NOTE( Object param ) {
        this.urlP_NOTE.setValue( param );
    }

    public void  setUrlP_NOTE( Object param, Format ignore ) {
        this.urlP_NOTE.setValue( param );
    }

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

    public void  setUrlP_DESTINATARIO( String param ) {
        this.urlP_DESTINATARIO.setValue( param );
    }

    public void  setUrlP_DESTINATARIO( Object param ) {
        this.urlP_DESTINATARIO.setValue( param );
    }

    public void  setUrlP_DESTINATARIO( Object param, Format ignore ) {
        this.urlP_DESTINATARIO.setValue( param );
    }

    public void  setPostNOTE( String param ) {
        this.postNOTE.setValue( param );
    }

    public void  setPostNOTE( Object param ) {
        this.postNOTE.setValue( param );
    }

    public void  setPostNOTE( Object param, Format ignore ) {
        this.postNOTE.setValue( param );
    }

    public void  setPostUTENTE_REDAZIONE( String param ) {
        this.postUTENTE_REDAZIONE.setValue( param );
    }

    public void  setPostUTENTE_REDAZIONE( Object param ) {
        this.postUTENTE_REDAZIONE.setValue( param );
    }

    public void  setPostUTENTE_REDAZIONE( Object param, Format ignore ) {
        this.postUTENTE_REDAZIONE.setValue( param );
    }

    public RICHIESTA_INOLTRARow getRow() {
        return row;
    }

    public void setRow( RICHIESTA_INOLTRARow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @6-F3F7B977
    public RICHIESTA_INOLTRADataObject(Page page) {
        super(page);
    }
//End constructor

//load @6-8D395EBD
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select d.id_documento "
                    + ", d.titolo "
                    + ", autore "
                    + ",  "
                    + "ad4_utente.get_nominativo(d.autore,'Y',0) nominativo_autore "
                    + ", d.data_inserimento "
                    + ", d.data_aggiornamento "
                    + ",  "
                    + "d.utente_aggiornamento "
                    + ",  "
                    + "ad4_utente.get_nominativo(d.utente_aggiornamento,'Y',0) nominativo_aggiornamento "
                    + ", r.revisione "
                    + ", r.utente_redazione "
                    + ",  "
                    + "ad4_utente.get_nominativo(r.utente_redazione,'Y',0) nominativo_redazione "
                    + ", r.cronologia cronologia "
                    + ",  "
                    + "r.note "
                    + ",decode(afc.get_stringparm(amv_documento.get_link(d.id_documento_padre,  "
                    + "d.revisione),'iter') "
                    + "             , 'N', 'A' "
                    + "             , 'A', 'V' "
                    + "                  ,  "
                    + "'N' "
                    + "             ) stato_futuro "
                    + "from amv_documenti d,  "
                    + "amv_documenti_revisioni r "
                    + "where d.id_documento = r.id_documento "
                    + "  and d.revisione = r.revisione "
                    + "  and d.id_documento = {MVIDRIC} "
                    + "  and d.revisione = {MVREVRIC}" );
        if ( sesMVIDRIC.getObjectValue() == null ) sesMVIDRIC.setValue( null );
        command.addParameter( "MVIDRIC", sesMVIDRIC, null );
        if ( sesMVREVRIC.getObjectValue() == null ) sesMVREVRIC.setValue( null );
        command.addParameter( "MVREVRIC", sesMVREVRIC, null );
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

//loadDataBind @6-CF44CB29
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setTITOLO(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getTITOLOField())));
            try {
                row.setDATA_INSERIMENTO(Utils.convertToDate(ds.parse(record.get("DATA_INSERIMENTO"), row.getDATA_INSERIMENTOField())));
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid data" );
            }
            row.setNOMINATIVO_AUTORE(Utils.convertToString(ds.parse(record.get("NOMINATIVO_AUTORE"), row.getNOMINATIVO_AUTOREField())));
            try {
                row.setDATA_AGGIORNAMENTO(Utils.convertToDate(ds.parse(record.get("DATA_AGGIORNAMENTO"), row.getDATA_AGGIORNAMENTOField())));
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid data" );
            }
            row.setNOMINATIVO_AGGIORNAMENTO(Utils.convertToString(ds.parse(record.get("NOMINATIVO_AGGIORNAMENTO"), row.getNOMINATIVO_AGGIORNAMENTOField())));
            row.setNOTE(Utils.convertToString(ds.parse(record.get("NOTE"), row.getNOTEField())));
            row.setCRONOLOGIA(Utils.convertToString(ds.parse(record.get("CRONOLOGIA"), row.getCRONOLOGIAField())));
            row.setNOTE_LABEL(Utils.convertToString(ds.parse(record.get("NOTE"), row.getNOTE_LABELField())));
            row.setREVISIONE(Utils.convertToLong(ds.parse(record.get("REVISIONE"), row.getREVISIONEField())));
            row.setID_DOCUMENTO(Utils.convertToLong(ds.parse(record.get("ID_DOCUMENTO"), row.getID_DOCUMENTOField())));
            row.setSTATO_FUTURO(Utils.convertToString(ds.parse(record.get("STATO_FUTURO"), row.getSTATO_FUTUROField())));
        }
//End loadDataBind

//End of load @6-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//update @6-B8AADEC5
        boolean update() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMV_REVISIONE.GESTISCI_REVISIONE ( ?, ?, ?, ?, ?, ? ) }" );
            command.addParameter( "P_ID_DOCUMENTO", sesMVIDRIC, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_REVISIONE", sesMVREVRIC, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) sesMVSF.getObjectValue() ) ) sesMVSF.setValue( "" );
            command.addParameter( "P_STATO_FUTURO", sesMVSF, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) urlP_NOTE.getObjectValue() ) ) urlP_NOTE.setValue( "" );
            command.addParameter( "P_NOTE", urlP_NOTE, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
            command.addParameter( "P_AUTORE", sesUtente, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) urlP_DESTINATARIO.getObjectValue() ) ) urlP_DESTINATARIO.setValue( "" );
            command.addParameter( "P_DESTINATARIO", urlP_DESTINATARIO, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );

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

//delete @6-782232CF
        boolean delete() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMV_REVISIONE.GESTISCI_REVISIONE ( ?, ?, ?, ?, ?, ? ) }" );
            command.addParameter( "P_ID_DOCUMENTO", sesMVIDRIC, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_REVISIONE", sesMVREVRIC, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) sesMVSF.getObjectValue() ) ) sesMVSF.setValue( "" );
            command.addParameter( "P_STATO_FUTURO", sesMVSF, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postNOTE.getObjectValue() ) ) postNOTE.setValue( "" );
            command.addParameter( "P_NOTE", postNOTE, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
            command.addParameter( "P_AUTORE", sesUtente, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postUTENTE_REDAZIONE.getObjectValue() ) ) postUTENTE_REDAZIONE.setValue( "" );
            command.addParameter( "P_DESTINATARIO", postUTENTE_REDAZIONE, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );

            fireBeforeBuildDeleteEvent( new DataObjectEvent(command) );


//End delete

//deleteDataBound @6-67425D5E
            fireBeforeExecuteDeleteEvent( new DataObjectEvent(command) );

            if ( ! ds.hasErrors() ) {
                command.executeUpdate();
            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteDeleteEvent( new DataObjectEvent(command) );

//End deleteDataBound

//End of delete @6-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of delete

//getParameterByName @6-038B6439
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "MVIDRIC".equals(name) && "ses".equals(prefix) ) {
                param = sesMVIDRIC;
            } else if ( "MVIDRIC".equals(name) && prefix == null ) {
                param = sesMVIDRIC;
            }
            if ( "MVREVRIC".equals(name) && "ses".equals(prefix) ) {
                param = sesMVREVRIC;
            } else if ( "MVREVRIC".equals(name) && prefix == null ) {
                param = sesMVREVRIC;
            }
            if ( "MVSF".equals(name) && "ses".equals(prefix) ) {
                param = sesMVSF;
            } else if ( "MVSF".equals(name) && prefix == null ) {
                param = sesMVSF;
            }
            if ( "P_NOTE".equals(name) && "url".equals(prefix) ) {
                param = urlP_NOTE;
            } else if ( "P_NOTE".equals(name) && prefix == null ) {
                param = urlP_NOTE;
            }
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "P_DESTINATARIO".equals(name) && "url".equals(prefix) ) {
                param = urlP_DESTINATARIO;
            } else if ( "P_DESTINATARIO".equals(name) && prefix == null ) {
                param = urlP_DESTINATARIO;
            }
            if ( "NOTE".equals(name) && "post".equals(prefix) ) {
                param = postNOTE;
            } else if ( "NOTE".equals(name) && prefix == null ) {
                param = postNOTE;
            }
            if ( "UTENTE_REDAZIONE".equals(name) && "post".equals(prefix) ) {
                param = postUTENTE_REDAZIONE;
            } else if ( "UTENTE_REDAZIONE".equals(name) && prefix == null ) {
                param = postUTENTE_REDAZIONE;
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

