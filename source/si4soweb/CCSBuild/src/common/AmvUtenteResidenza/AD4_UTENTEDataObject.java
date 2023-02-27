//AD4_UTENTE DataSource @6-5066C6F1
package common.AmvUtenteResidenza;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_UTENTE DataSource

//class DataObject Header @6-6F70C966
public class AD4_UTENTEDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @6-B16C037A
    

    TextField sesUtente = new TextField(null, null);
    
    TextField sesMVUTE = new TextField(null, null);
    
    DoubleField postCOMUNE = new DoubleField(null, null);
    
    DoubleField postPROVINCIA = new DoubleField(null, null);
    
    TextField postCAP = new TextField(null, null);
    
    TextField postVIA = new TextField(null, null);
    
    TextField postINDIRIZZO = new TextField(null, null);
    
    TextField postNUM = new TextField(null, null);
    
    TextField urlP_INDIRIZZO_WEB = new TextField(null, null);
    
    TextField urlP_TELEFONO = new TextField(null, null);
    
    TextField urlP_FAX = new TextField(null, null);
    
    TextField postMVPAGES = new TextField(null, null);
    
    TextField urlMVPAGES = new TextField(null, null);
    

    private AD4_UTENTERow row = new AD4_UTENTERow();

//End attributes of DataObject

//properties of DataObject @6-ACA6E283

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesMVUTE( String param ) {
        this.sesMVUTE.setValue( param );
    }

    public void  setSesMVUTE( Object param ) {
        this.sesMVUTE.setValue( param );
    }

    public void  setSesMVUTE( Object param, Format ignore ) {
        this.sesMVUTE.setValue( param );
    }

    public void  setPostCOMUNE( double param ) {
        this.postCOMUNE.setValue( param );
    }

    public void  setPostCOMUNE( double param, Format ignore ) throws java.text.ParseException {
        this.postCOMUNE.setValue( param );
    }

    public void  setPostCOMUNE( Object param, Format format ) throws java.text.ParseException {
        this.postCOMUNE.setValue( param, format );
    }

    public void  setPostCOMUNE( Double param ) {
        this.postCOMUNE.setValue( param );
    }

    public void  setPostPROVINCIA( double param ) {
        this.postPROVINCIA.setValue( param );
    }

    public void  setPostPROVINCIA( double param, Format ignore ) throws java.text.ParseException {
        this.postPROVINCIA.setValue( param );
    }

    public void  setPostPROVINCIA( Object param, Format format ) throws java.text.ParseException {
        this.postPROVINCIA.setValue( param, format );
    }

    public void  setPostPROVINCIA( Double param ) {
        this.postPROVINCIA.setValue( param );
    }

    public void  setPostCAP( String param ) {
        this.postCAP.setValue( param );
    }

    public void  setPostCAP( Object param ) {
        this.postCAP.setValue( param );
    }

    public void  setPostCAP( Object param, Format ignore ) {
        this.postCAP.setValue( param );
    }

    public void  setPostVIA( String param ) {
        this.postVIA.setValue( param );
    }

    public void  setPostVIA( Object param ) {
        this.postVIA.setValue( param );
    }

    public void  setPostVIA( Object param, Format ignore ) {
        this.postVIA.setValue( param );
    }

    public void  setPostINDIRIZZO( String param ) {
        this.postINDIRIZZO.setValue( param );
    }

    public void  setPostINDIRIZZO( Object param ) {
        this.postINDIRIZZO.setValue( param );
    }

    public void  setPostINDIRIZZO( Object param, Format ignore ) {
        this.postINDIRIZZO.setValue( param );
    }

    public void  setPostNUM( String param ) {
        this.postNUM.setValue( param );
    }

    public void  setPostNUM( Object param ) {
        this.postNUM.setValue( param );
    }

    public void  setPostNUM( Object param, Format ignore ) {
        this.postNUM.setValue( param );
    }

    public void  setUrlP_INDIRIZZO_WEB( String param ) {
        this.urlP_INDIRIZZO_WEB.setValue( param );
    }

    public void  setUrlP_INDIRIZZO_WEB( Object param ) {
        this.urlP_INDIRIZZO_WEB.setValue( param );
    }

    public void  setUrlP_INDIRIZZO_WEB( Object param, Format ignore ) {
        this.urlP_INDIRIZZO_WEB.setValue( param );
    }

    public void  setUrlP_TELEFONO( String param ) {
        this.urlP_TELEFONO.setValue( param );
    }

    public void  setUrlP_TELEFONO( Object param ) {
        this.urlP_TELEFONO.setValue( param );
    }

    public void  setUrlP_TELEFONO( Object param, Format ignore ) {
        this.urlP_TELEFONO.setValue( param );
    }

    public void  setUrlP_FAX( String param ) {
        this.urlP_FAX.setValue( param );
    }

    public void  setUrlP_FAX( Object param ) {
        this.urlP_FAX.setValue( param );
    }

    public void  setUrlP_FAX( Object param, Format ignore ) {
        this.urlP_FAX.setValue( param );
    }

    public void  setPostMVPAGES( String param ) {
        this.postMVPAGES.setValue( param );
    }

    public void  setPostMVPAGES( Object param ) {
        this.postMVPAGES.setValue( param );
    }

    public void  setPostMVPAGES( Object param, Format ignore ) {
        this.postMVPAGES.setValue( param );
    }

    public void  setUrlMVPAGES( String param ) {
        this.urlMVPAGES.setValue( param );
    }

    public void  setUrlMVPAGES( Object param ) {
        this.urlMVPAGES.setValue( param );
    }

    public void  setUrlMVPAGES( Object param, Format ignore ) {
        this.urlMVPAGES.setValue( param );
    }

    public AD4_UTENTERow getRow() {
        return row;
    }

    public void setRow( AD4_UTENTERow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @6-F9C29682
    public AD4_UTENTEDataObject(Page page) {
        super(page);
    }
//End constructor

//load @6-70294919
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT AD4_SOGGETTO.GET_NOME(s.SOGGETTO,'Y') NOME "
                    + ",  "
                    + "AD4_SOGGETTO.GET_SESSO(s.SOGGETTO) SESSO "
                    + ", AD4_SOGGETTO.GET_DATA_NASCITA(s.SOGGETTO) DATA_NASCITA "
                    + ",  "
                    + "AD4_SOGGETTO.GET_DES_COMUNE_NAS(s.SOGGETTO) DES_COMUNE_NAS "
                    + ",  "
                    + "AD4_SOGGETTO.GET_DES_PROVINCIA_NAS(s.SOGGETTO) DES_PROVINCIA_NAS "
                    + ",  "
                    + "AD4_SOGGETTO.GET_CODICE_FISCALE(s.SOGGETTO) CODICE_FISCALE "
                    + ",  "
                    + "AD4_SOGGETTO.GET_INDIRIZZO_COMPLETO(s.SOGGETTO) INDIRIZZO_COMPLETO "
                    + ", AD4_SOGGETTO.GET_INDIRIZZO_WEB(s.SOGGETTO) INDIRIZZO_WEB "
                    + ",  "
                    + "AD4_SOGGETTO.GET_TELEFONO(s.SOGGETTO) TELEFONO "
                    + ", AD4_SOGGETTO.GET_FAX(s.SOGGETTO) FAX "
                    + ",  "
                    + "nvl('{MVPAGESURL}','{MVPAGES}') MVPAGES "
                    + "FROM AD4_UTENTI u,  "
                    + "AD4_UTENTI_SOGGETTI s  "
                    + "WHERE u.UTENTE = nvl('{MVUTE}','{Utente}') AND s.utente = u.utente" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( StringUtils.isEmpty( (String) sesMVUTE.getObjectValue() ) ) sesMVUTE.setValue( "" );
        command.addParameter( "MVUTE", sesMVUTE, null );
        if ( StringUtils.isEmpty( (String) postMVPAGES.getObjectValue() ) ) postMVPAGES.setValue( "" );
        command.addParameter( "MVPAGES", postMVPAGES, null );
        if ( StringUtils.isEmpty( (String) urlMVPAGES.getObjectValue() ) ) urlMVPAGES.setValue( "" );
        command.addParameter( "MVPAGESURL", urlMVPAGES, null );
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

//loadDataBind @6-A0D56A3E
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setNOMINATIVO(Utils.convertToString(ds.parse(record.get("NOME"), row.getNOMINATIVOField())));
            row.setINDIRIZZO_COMPLETO(Utils.convertToString(ds.parse(record.get("INDIRIZZO_COMPLETO"), row.getINDIRIZZO_COMPLETOField())));
            row.setMVPAGES(Utils.convertToString(ds.parse(record.get("MVPAGES"), row.getMVPAGESField())));
        }
//End loadDataBind

//End of load @6-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//update @6-7684C6E7
        boolean update() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMV_UTENTE.AGGIORNA ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ) }" );
            if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
            command.addParameter( "P_UTENTE", sesUtente, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) sesMVUTE.getObjectValue() ) ) sesMVUTE.setValue( "" );
            command.addParameter( "P_NUOVO_UTENTE", sesMVUTE, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_COMUNE", postCOMUNE, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_PROVINCIA", postPROVINCIA, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postCAP.getObjectValue() ) ) postCAP.setValue( "" );
            command.addParameter( "P_CAP", postCAP, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postVIA.getObjectValue() ) ) postVIA.setValue( "" );
            command.addParameter( "P_VIA", postVIA, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postINDIRIZZO.getObjectValue() ) ) postINDIRIZZO.setValue( "" );
            command.addParameter( "P_INDIRIZZO", postINDIRIZZO, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postNUM.getObjectValue() ) ) postNUM.setValue( "" );
            command.addParameter( "P_NUM", postNUM, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) urlP_INDIRIZZO_WEB.getObjectValue() ) ) urlP_INDIRIZZO_WEB.setValue( "" );
            command.addParameter( "P_INDIRIZZO_WEB", urlP_INDIRIZZO_WEB, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) urlP_TELEFONO.getObjectValue() ) ) urlP_TELEFONO.setValue( "" );
            command.addParameter( "P_TELEFONO", urlP_TELEFONO, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) urlP_FAX.getObjectValue() ) ) urlP_FAX.setValue( "" );
            command.addParameter( "P_FAX", urlP_FAX, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );

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

//getParameterByName @6-D14ACB98
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "MVUTE".equals(name) && "ses".equals(prefix) ) {
                param = sesMVUTE;
            } else if ( "MVUTE".equals(name) && prefix == null ) {
                param = sesMVUTE;
            }
            if ( "COMUNE".equals(name) && "post".equals(prefix) ) {
                param = postCOMUNE;
            } else if ( "COMUNE".equals(name) && prefix == null ) {
                param = postCOMUNE;
            }
            if ( "PROVINCIA".equals(name) && "post".equals(prefix) ) {
                param = postPROVINCIA;
            } else if ( "PROVINCIA".equals(name) && prefix == null ) {
                param = postPROVINCIA;
            }
            if ( "CAP".equals(name) && "post".equals(prefix) ) {
                param = postCAP;
            } else if ( "CAP".equals(name) && prefix == null ) {
                param = postCAP;
            }
            if ( "VIA".equals(name) && "post".equals(prefix) ) {
                param = postVIA;
            } else if ( "VIA".equals(name) && prefix == null ) {
                param = postVIA;
            }
            if ( "INDIRIZZO".equals(name) && "post".equals(prefix) ) {
                param = postINDIRIZZO;
            } else if ( "INDIRIZZO".equals(name) && prefix == null ) {
                param = postINDIRIZZO;
            }
            if ( "NUM".equals(name) && "post".equals(prefix) ) {
                param = postNUM;
            } else if ( "NUM".equals(name) && prefix == null ) {
                param = postNUM;
            }
            if ( "P_INDIRIZZO_WEB".equals(name) && "url".equals(prefix) ) {
                param = urlP_INDIRIZZO_WEB;
            } else if ( "P_INDIRIZZO_WEB".equals(name) && prefix == null ) {
                param = urlP_INDIRIZZO_WEB;
            }
            if ( "P_TELEFONO".equals(name) && "url".equals(prefix) ) {
                param = urlP_TELEFONO;
            } else if ( "P_TELEFONO".equals(name) && prefix == null ) {
                param = urlP_TELEFONO;
            }
            if ( "P_FAX".equals(name) && "url".equals(prefix) ) {
                param = urlP_FAX;
            } else if ( "P_FAX".equals(name) && prefix == null ) {
                param = urlP_FAX;
            }
            if ( "MVPAGES".equals(name) && "post".equals(prefix) ) {
                param = postMVPAGES;
            } else if ( "MVPAGES".equals(name) && prefix == null ) {
                param = postMVPAGES;
            }
            if ( "MVPAGES".equals(name) && "url".equals(prefix) ) {
                param = urlMVPAGES;
            } else if ( "MVPAGES".equals(name) && prefix == null ) {
                param = urlMVPAGES;
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

