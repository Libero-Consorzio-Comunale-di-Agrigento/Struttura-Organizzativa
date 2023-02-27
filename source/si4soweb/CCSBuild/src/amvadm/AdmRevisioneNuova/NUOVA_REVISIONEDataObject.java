//NUOVA_REVISIONE DataSource @6-017C92C3
package amvadm.AdmRevisioneNuova;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End NUOVA_REVISIONE DataSource

//class DataObject Header @6-D259DDB8
public class NUOVA_REVISIONEDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @6-F66E6B46
    

    DoubleField postID_DOCUMENTO = new DoubleField(null, null);
    
    DoubleField postREVISIONE = new DoubleField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    TextField postREDAZIONE = new TextField(null, null);
    
    TextField postVERIFICA = new TextField(null, null);
    
    TextField postAPPROVAZIONE = new TextField(null, null);
    
    DateField postINIZIO_PUBBLICAZIONE = new DateField(null, null);
    
    DateField postFINE_PUBBLICAZIONE = new DateField(null, null);
    
    LongField urlID = new LongField(null, null);
    
    LongField urlREV = new LongField(null, null);
    

    private NUOVA_REVISIONERow row = new NUOVA_REVISIONERow();

//End attributes of DataObject

//properties of DataObject @6-E24D9DAF

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

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

    public void  setPostREDAZIONE( String param ) {
        this.postREDAZIONE.setValue( param );
    }

    public void  setPostREDAZIONE( Object param ) {
        this.postREDAZIONE.setValue( param );
    }

    public void  setPostREDAZIONE( Object param, Format ignore ) {
        this.postREDAZIONE.setValue( param );
    }

    public void  setPostVERIFICA( String param ) {
        this.postVERIFICA.setValue( param );
    }

    public void  setPostVERIFICA( Object param ) {
        this.postVERIFICA.setValue( param );
    }

    public void  setPostVERIFICA( Object param, Format ignore ) {
        this.postVERIFICA.setValue( param );
    }

    public void  setPostAPPROVAZIONE( String param ) {
        this.postAPPROVAZIONE.setValue( param );
    }

    public void  setPostAPPROVAZIONE( Object param ) {
        this.postAPPROVAZIONE.setValue( param );
    }

    public void  setPostAPPROVAZIONE( Object param, Format ignore ) {
        this.postAPPROVAZIONE.setValue( param );
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

    public NUOVA_REVISIONERow getRow() {
        return row;
    }

    public void setRow( NUOVA_REVISIONERow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @6-BDE2DC99
    public NUOVA_REVISIONEDataObject(Page page) {
        super(page);
    }
//End constructor

//load @6-436AAF83
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT ID_DOCUMENTO, REVISIONE, TITOLO,DES_TIPOLOGIA "
                    + ", DES_CATEGORIA,  "
                    + "DES_ARGOMENTO "
                    + ", NOME_AUTORE, DATA_INSERIMENTO "
                    + ", INIZIO_PUBBLICAZIONE,  "
                    + "FINE_PUBBLICAZIONE "
                    + " FROM AMV_VISTA_DOCUMENTI "
                    + "WHERE ID_DOCUMENTO = {ID} "
                    + "  AND REVISIONE = {REV} "
                    + "  AND UTENTE = '{Utente}' "
                    + "  AND STATO = 'U'" );
        if ( urlID.getObjectValue() == null ) urlID.setValue( -1 );
        command.addParameter( "ID", urlID, null );
        if ( urlREV.getObjectValue() == null ) urlREV.setValue( -1 );
        command.addParameter( "REV", urlREV, null );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
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

//loadDataBind @6-1610B636
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setTITOLO(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getTITOLOField())));
            row.setDES_TIPOLOGIA(Utils.convertToString(ds.parse(record.get("DES_TIPOLOGIA"), row.getDES_TIPOLOGIAField())));
            row.setDES_CATEGORIA(Utils.convertToString(ds.parse(record.get("DES_CATEGORIA"), row.getDES_CATEGORIAField())));
            row.setDES_ARGOMENTO(Utils.convertToString(ds.parse(record.get("DES_ARGOMENTO"), row.getDES_ARGOMENTOField())));
            row.setNOME_AUTORE(Utils.convertToString(ds.parse(record.get("NOME_AUTORE"), row.getNOME_AUTOREField())));
            try {
                row.setDATA_INSERIMENTO(Utils.convertToDate(ds.parse(record.get("DATA_INSERIMENTO"), row.getDATA_INSERIMENTOField())));
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid data" );
            }
            try {
                row.setINIZIO_PUBBLICAZIONE_LABEL(Utils.convertToDate(ds.parse(record.get("INIZIO_PUBBLICAZIONE"), row.getINIZIO_PUBBLICAZIONE_LABELField())));
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid data" );
            }
            try {
                row.setFINE_PUBBLICAZIONE_LABEL(Utils.convertToDate(ds.parse(record.get("FINE_PUBBLICAZIONE"), row.getFINE_PUBBLICAZIONE_LABELField())));
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid data" );
            }
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

//update @6-8116ACAA
        boolean update() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMV_REVISIONE.CREAZIONE_REVISIONE ( ?, ?, ?, ?, ?, ?, ?, ? ) }" );
            command.addParameter( "P_ID_DOCUMENTO", postID_DOCUMENTO, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_REVISIONE", postREVISIONE, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
            command.addParameter( "P_UTENTE", sesUtente, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postREDAZIONE.getObjectValue() ) ) postREDAZIONE.setValue( "" );
            command.addParameter( "P_UTENTE_REDAZIONE", postREDAZIONE, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postVERIFICA.getObjectValue() ) ) postVERIFICA.setValue( "" );
            command.addParameter( "P_UTENTE_VERIFICA", postVERIFICA, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postAPPROVAZIONE.getObjectValue() ) ) postAPPROVAZIONE.setValue( "" );
            command.addParameter( "P_UTENTE_APPROVAZIONE", postAPPROVAZIONE, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
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

//getParameterByName @6-149A449F
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
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "REDAZIONE".equals(name) && "post".equals(prefix) ) {
                param = postREDAZIONE;
            } else if ( "REDAZIONE".equals(name) && prefix == null ) {
                param = postREDAZIONE;
            }
            if ( "VERIFICA".equals(name) && "post".equals(prefix) ) {
                param = postVERIFICA;
            } else if ( "VERIFICA".equals(name) && prefix == null ) {
                param = postVERIFICA;
            }
            if ( "APPROVAZIONE".equals(name) && "post".equals(prefix) ) {
                param = postAPPROVAZIONE;
            } else if ( "APPROVAZIONE".equals(name) && prefix == null ) {
                param = postAPPROVAZIONE;
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

