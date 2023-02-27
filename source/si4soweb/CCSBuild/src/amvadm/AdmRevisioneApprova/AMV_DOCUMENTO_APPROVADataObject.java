//AMV_DOCUMENTO_APPROVA DataSource @6-53D75D99
package amvadm.AdmRevisioneApprova;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AMV_DOCUMENTO_APPROVA DataSource

//class DataObject Header @6-BE610A6D
public class AMV_DOCUMENTO_APPROVADataObject extends DS {
//End class DataObject Header

//attributes of DataObject @6-8A787BDE
    

    DoubleField urlID = new DoubleField(null, null);
    
    DoubleField urlREV = new DoubleField(null, null);
    
    TextField exprKey34 = new TextField(null, null);
    
    TextField postNOTE = new TextField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    TextField urlP_DESTINATARIO = new TextField(null, null);
    
    TextField sesMVPP = new TextField(null, null);
    

    private AMV_DOCUMENTO_APPROVARow row = new AMV_DOCUMENTO_APPROVARow();

//End attributes of DataObject

//properties of DataObject @6-394F1036

    public void  setUrlID( double param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlID( double param, Format ignore ) throws java.text.ParseException {
        this.urlID.setValue( param );
    }

    public void  setUrlID( Object param, Format format ) throws java.text.ParseException {
        this.urlID.setValue( param, format );
    }

    public void  setUrlID( Double param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlREV( double param ) {
        this.urlREV.setValue( param );
    }

    public void  setUrlREV( double param, Format ignore ) throws java.text.ParseException {
        this.urlREV.setValue( param );
    }

    public void  setUrlREV( Object param, Format format ) throws java.text.ParseException {
        this.urlREV.setValue( param, format );
    }

    public void  setUrlREV( Double param ) {
        this.urlREV.setValue( param );
    }

    public void  setExprKey34( String param ) {
        this.exprKey34.setValue( param );
    }

    public void  setExprKey34( Object param ) {
        this.exprKey34.setValue( param );
    }

    public void  setExprKey34( Object param, Format ignore ) {
        this.exprKey34.setValue( param );
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

    public void  setUrlP_DESTINATARIO( String param ) {
        this.urlP_DESTINATARIO.setValue( param );
    }

    public void  setUrlP_DESTINATARIO( Object param ) {
        this.urlP_DESTINATARIO.setValue( param );
    }

    public void  setUrlP_DESTINATARIO( Object param, Format ignore ) {
        this.urlP_DESTINATARIO.setValue( param );
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

    public AMV_DOCUMENTO_APPROVARow getRow() {
        return row;
    }

    public void setRow( AMV_DOCUMENTO_APPROVARow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @6-9B616C48
    public AMV_DOCUMENTO_APPROVADataObject(Page page) {
        super(page);
        addRecordDataObjectListener( new AMV_DOCUMENTO_APPROVADataObjectHandler() );
    }
//End constructor

//load @6-1D2C6E36
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select d.id_documento "
                    + ", d.titolo "
                    + ", '{MVPP}' mvpages "
                    + ", autore "
                    + ",  "
                    + "ad4_utente.get_nominativo(d.autore,'Y',0) nominativo_autore "
                    + ", d.data_inserimento "
                    + ",  "
                    + "d.data_aggiornamento "
                    + ", d.utente_aggiornamento "
                    + ",  "
                    + "ad4_utente.get_nominativo(d.utente_aggiornamento,'Y',0) nominativo_aggiornamento "
                    + ", r.revisione "
                    + ", r.utente_approvazione "
                    + ",  "
                    + "ad4_utente.get_nominativo(r.utente_approvazione,'Y',0) nominativo_approvazione "
                    + ",  "
                    + "r.cronologia cronologia "
                    + ", r.note "
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

//loadDataBind @6-4086F909
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
            row.setAUTORE(Utils.convertToString(ds.parse(record.get("AUTORE"), row.getAUTOREField())));
            try {
                row.setDATA_AGGIORNAMENTO(Utils.convertToDate(ds.parse(record.get("DATA_AGGIORNAMENTO"), row.getDATA_AGGIORNAMENTOField())));
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid data" );
            }
            row.setUTENTE_AGGIORNAMENTO(Utils.convertToString(ds.parse(record.get("UTENTE_AGGIORNAMENTO"), row.getUTENTE_AGGIORNAMENTOField())));
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

//update @6-5D01E60E
        boolean update() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMV_REVISIONE.GESTISCI_REVISIONE ( ?, ?, ?, ?, ?, ? ) }" );
            command.addParameter( "P_ID_DOCUMENTO", urlID, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_REVISIONE", urlREV, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) exprKey34.getObjectValue() ) ) exprKey34.setValue( "" );
            command.addParameter( "P_STATO_FUTURO", exprKey34, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postNOTE.getObjectValue() ) ) postNOTE.setValue( "" );
            command.addParameter( "P_NOTE", postNOTE, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
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

//getParameterByName @6-23FDD70B
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
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
            if ( "exprKey34".equals(name) && "expr".equals(prefix) ) {
                param = exprKey34;
            } else if ( "exprKey34".equals(name) && prefix == null ) {
                param = exprKey34;
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
            if ( "P_DESTINATARIO".equals(name) && "url".equals(prefix) ) {
                param = urlP_DESTINATARIO;
            } else if ( "P_DESTINATARIO".equals(name) && prefix == null ) {
                param = urlP_DESTINATARIO;
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

