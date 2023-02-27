//AMV_DOCUMENTO_RESPINGI DataSource @6-E654E462
package common.AmvRichiestaElimina;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AMV_DOCUMENTO_RESPINGI DataSource

//class DataObject Header @6-3243D14B
public class AMV_DOCUMENTO_RESPINGIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @6-A16F4664
    

    DoubleField postID_DOCUMENTO = new DoubleField(null, null);
    
    DoubleField postREVISIONE = new DoubleField(null, null);
    
    TextField exprKey45 = new TextField(null, null);
    
    TextField postNOTE = new TextField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    TextField postUTENTE_REDAZIONE = new TextField(null, null);
    
    LongField sesMVIDRIC = new LongField(null, null);
    
    LongField sesMVREVRIC = new LongField(null, null);
    

    private AMV_DOCUMENTO_RESPINGIRow row = new AMV_DOCUMENTO_RESPINGIRow();

//End attributes of DataObject

//properties of DataObject @6-11C622A4

    public void  setPostID_DOCUMENTO( double param ) {
        this.postID_DOCUMENTO.setValue( param );
    }

    public void  setPostID_DOCUMENTO( double param, Format ignore ) throws java.text.ParseException {
        this.postID_DOCUMENTO.setValue( param );
    }

    public void  setPostID_DOCUMENTO( Object param, Format format ) throws java.text.ParseException {
        this.postID_DOCUMENTO.setValue( param, format );
    }

    public void  setPostID_DOCUMENTO( Double param ) {
        this.postID_DOCUMENTO.setValue( param );
    }

    public void  setPostREVISIONE( double param ) {
        this.postREVISIONE.setValue( param );
    }

    public void  setPostREVISIONE( double param, Format ignore ) throws java.text.ParseException {
        this.postREVISIONE.setValue( param );
    }

    public void  setPostREVISIONE( Object param, Format format ) throws java.text.ParseException {
        this.postREVISIONE.setValue( param, format );
    }

    public void  setPostREVISIONE( Double param ) {
        this.postREVISIONE.setValue( param );
    }

    public void  setExprKey45( String param ) {
        this.exprKey45.setValue( param );
    }

    public void  setExprKey45( Object param ) {
        this.exprKey45.setValue( param );
    }

    public void  setExprKey45( Object param, Format ignore ) {
        this.exprKey45.setValue( param );
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

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
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

    public void  setSesMVIDRIC( long param ) {
        this.sesMVIDRIC.setValue( param );
    }

    public void  setSesMVIDRIC( long param, Format ignore ) throws java.text.ParseException {
        this.sesMVIDRIC.setValue( param );
    }

    public void  setSesMVIDRIC( Object param, Format format ) throws java.text.ParseException {
        this.sesMVIDRIC.setValue( param, format );
    }

    public void  setSesMVIDRIC( Long param ) {
        this.sesMVIDRIC.setValue( param );
    }

    public void  setSesMVREVRIC( long param ) {
        this.sesMVREVRIC.setValue( param );
    }

    public void  setSesMVREVRIC( long param, Format ignore ) throws java.text.ParseException {
        this.sesMVREVRIC.setValue( param );
    }

    public void  setSesMVREVRIC( Object param, Format format ) throws java.text.ParseException {
        this.sesMVREVRIC.setValue( param, format );
    }

    public void  setSesMVREVRIC( Long param ) {
        this.sesMVREVRIC.setValue( param );
    }

    public AMV_DOCUMENTO_RESPINGIRow getRow() {
        return row;
    }

    public void setRow( AMV_DOCUMENTO_RESPINGIRow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @6-E6E1DBFC
    public AMV_DOCUMENTO_RESPINGIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @6-68D64C4C
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

//loadDataBind @6-797F37B3
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
        }
//End loadDataBind

//End of load @6-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//delete @6-912D5EA8
        boolean delete() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMV_REVISIONE.GESTISCI_REVISIONE ( ?, ?, ?, ?, ?, ? ) }" );
            command.addParameter( "P_ID_DOCUMENTO", postID_DOCUMENTO, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_REVISIONE", postREVISIONE, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) exprKey45.getObjectValue() ) ) exprKey45.setValue( "" );
            command.addParameter( "P_STATO_FUTURO", exprKey45, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
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

//getParameterByName @6-9D9649D7
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "ID_DOCUMENTO".equals(name) && "post".equals(prefix) ) {
                param = postID_DOCUMENTO;
            } else if ( "ID_DOCUMENTO".equals(name) && prefix == null ) {
                param = postID_DOCUMENTO;
            }
            if ( "REVISIONE".equals(name) && "post".equals(prefix) ) {
                param = postREVISIONE;
            } else if ( "REVISIONE".equals(name) && prefix == null ) {
                param = postREVISIONE;
            }
            if ( "exprKey45".equals(name) && "expr".equals(prefix) ) {
                param = exprKey45;
            } else if ( "exprKey45".equals(name) && prefix == null ) {
                param = exprKey45;
            }
            if ( "NOTE".equals(name) && "post".equals(prefix) ) {
                param = postNOTE;
            } else if ( "NOTE".equals(name) && prefix == null ) {
                param = postNOTE;
            }
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "UTENTE_REDAZIONE".equals(name) && "post".equals(prefix) ) {
                param = postUTENTE_REDAZIONE;
            } else if ( "UTENTE_REDAZIONE".equals(name) && prefix == null ) {
                param = postUTENTE_REDAZIONE;
            }
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

