//AMV_DOCUMENTO_PUBBLICA DataSource @6-42F1BF56
package amvadm.AdmRevisionePubblica;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AMV_DOCUMENTO_PUBBLICA DataSource

//class DataObject Header @6-0DAB8558
public class AMV_DOCUMENTO_PUBBLICADataObject extends DS {
//End class DataObject Header

//attributes of DataObject @6-45142287
    

    DoubleField postID_DOCUMENTO = new DoubleField(null, null);
    
    DoubleField postREVISIONE = new DoubleField(null, null);
    
    DateField postINIZIO_PUBBLICAZIONE = new DateField(null, null);
    
    DateField postFINE_PUBBLICAZIONE = new DateField(null, null);
    
    LongField urlID = new LongField(null, null);
    
    LongField urlREV = new LongField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    TextField sesMVPP = new TextField(null, null);
    

    private AMV_DOCUMENTO_PUBBLICARow row = new AMV_DOCUMENTO_PUBBLICARow();

//End attributes of DataObject

//properties of DataObject @6-853DEFF7

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

    public void  setPostINIZIO_PUBBLICAZIONE( Object param, Format format ) throws java.text.ParseException {
        this.postINIZIO_PUBBLICAZIONE.setValue( param, format );
    }

    public void  setPostINIZIO_PUBBLICAZIONE( Date param ) {
        this.postINIZIO_PUBBLICAZIONE.setValue( param );
    }

    public void  setPostFINE_PUBBLICAZIONE( Object param, Format format ) throws java.text.ParseException {
        this.postFINE_PUBBLICAZIONE.setValue( param, format );
    }

    public void  setPostFINE_PUBBLICAZIONE( Date param ) {
        this.postFINE_PUBBLICAZIONE.setValue( param );
    }

    public void  setUrlID( long param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlID( long param, Format ignore ) throws java.text.ParseException {
        this.urlID.setValue( param );
    }

    public void  setUrlID( Object param, Format format ) throws java.text.ParseException {
        this.urlID.setValue( param, format );
    }

    public void  setUrlID( Long param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlREV( long param ) {
        this.urlREV.setValue( param );
    }

    public void  setUrlREV( long param, Format ignore ) throws java.text.ParseException {
        this.urlREV.setValue( param );
    }

    public void  setUrlREV( Object param, Format format ) throws java.text.ParseException {
        this.urlREV.setValue( param, format );
    }

    public void  setUrlREV( Long param ) {
        this.urlREV.setValue( param );
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

    public void  setSesMVPP( String param ) {
        this.sesMVPP.setValue( param );
    }

    public void  setSesMVPP( Object param ) {
        this.sesMVPP.setValue( param );
    }

    public void  setSesMVPP( Object param, Format ignore ) {
        this.sesMVPP.setValue( param );
    }

    public AMV_DOCUMENTO_PUBBLICARow getRow() {
        return row;
    }

    public void setRow( AMV_DOCUMENTO_PUBBLICARow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @6-E27C5B75
    public AMV_DOCUMENTO_PUBBLICADataObject(Page page) {
        super(page);
        addRecordDataObjectListener( new AMV_DOCUMENTO_PUBBLICADataObjectHandler() );
    }
//End constructor

//load @6-1F2F6B52
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select d.id_documento "
                    + ", d.titolo "
                    + ",  "
                    + "decode( "
                    + "     instr('{MVPP}','/amvadm/AdmDocumento.do') "
                    + "   , 1 , '../amvadm/AdmRevisioniElenco.do' "
                    + "   ,  "
                    + "'..'||'{MVPP}' "
                    + "  ) mvpages "
                    + ", d.autore "
                    + ", ad4_utente.get_nominativo(d.autore,'Y',0) nominativo_autore "
                    + ",  "
                    + "d.data_inserimento "
                    + ", d.data_aggiornamento "
                    + ", d.utente_aggiornamento "
                    + ",  "
                    + "ad4_utente.get_nominativo(d.utente_aggiornamento,'Y',0) nominativo_aggiornamento "
                    + ",  "
                    + "d.inizio_pubblicazione "
                    + ", d.fine_pubblicazione "
                    + ", r.revisione "
                    + ", nvl(r.utente_approvazione,  "
                    + "'{Utente}') "
                    + ", ad4_utente.get_nominativo(nvl(r.utente_approvazione,  "
                    + "'{Utente}'),'Y',0) nominativo_approvazione "
                    + ", r.cronologia cronologia "
                    + ",  "
                    + "r.note note "
                    + "from amv_documenti d,  "
                    + "amv_documenti_revisioni r "
                    + "where d.id_documento = r.id_documento "
                    + "  and d.revisione = r.revisione "
                    + "  and d.id_documento = {ID} "
                    + "  and d.revisione = {REV}" );
        if ( urlID.getObjectValue() == null ) urlID.setValue( -1 );
        command.addParameter( "ID", urlID, null );
        if ( urlREV.getObjectValue() == null ) urlREV.setValue( -1 );
        command.addParameter( "REV", urlREV, null );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( StringUtils.isEmpty( (String) sesMVPP.getObjectValue() ) ) sesMVPP.setValue( "" );
        command.addParameter( "MVPP", sesMVPP, null );
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

//loadDataBind @6-2C352636
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setTITOLO(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getTITOLOField())));
            row.setMVPAGES(Utils.convertToString(ds.parse(record.get("MVPAGES"), row.getMVPAGESField())));
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
            try {
                row.setINIZIO_PUBBLICAZIONE(Utils.convertToDate(ds.parse(record.get("INIZIO_PUBBLICAZIONE"), row.getINIZIO_PUBBLICAZIONEField())));
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid data" );
            }
            try {
                row.setFINE_PUBBLICAZIONE(Utils.convertToDate(ds.parse(record.get("FINE_PUBBLICAZIONE"), row.getFINE_PUBBLICAZIONEField())));
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid data" );
            }
            row.setCRONOLOGIA(Utils.convertToString(ds.parse(record.get("CRONOLOGIA"), row.getCRONOLOGIAField())));
            row.setNOTE(Utils.convertToString(ds.parse(record.get("NOTE"), row.getNOTEField())));
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

//update @6-DE44DDEA
        boolean update() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMV_REVISIONE.PUBBLICAZIONE_REVISIONE ( ?, ?, ?, ? ) }" );
            command.addParameter( "P_ID_DOCUMENTO", postID_DOCUMENTO, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_REVISIONE", postREVISIONE, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_INIZIO_PUBBLICAZIONE", postINIZIO_PUBBLICAZIONE, java.sql.Types.TIMESTAMP, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_FINE_PUBBLICAZIONE", postFINE_PUBBLICAZIONE, java.sql.Types.TIMESTAMP, 0, SPParameter.INPUT_PARAMETER );

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

//getParameterByName @6-AB2F7ACE
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
            if ( "INIZIO_PUBBLICAZIONE".equals(name) && "post".equals(prefix) ) {
                param = postINIZIO_PUBBLICAZIONE;
            } else if ( "INIZIO_PUBBLICAZIONE".equals(name) && prefix == null ) {
                param = postINIZIO_PUBBLICAZIONE;
            }
            if ( "FINE_PUBBLICAZIONE".equals(name) && "post".equals(prefix) ) {
                param = postFINE_PUBBLICAZIONE;
            } else if ( "FINE_PUBBLICAZIONE".equals(name) && prefix == null ) {
                param = postFINE_PUBBLICAZIONE;
            }
            if ( "ID".equals(name) && "url".equals(prefix) ) {
                param = urlID;
            } else if ( "ID".equals(name) && prefix == null ) {
                param = urlID;
            }
            if ( "REV".equals(name) && "url".equals(prefix) ) {
                param = urlREV;
            } else if ( "REV".equals(name) && prefix == null ) {
                param = urlREV;
            }
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "MVPP".equals(name) && "ses".equals(prefix) ) {
                param = sesMVPP;
            } else if ( "MVPP".equals(name) && prefix == null ) {
                param = sesMVPP;
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

