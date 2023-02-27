//AD4_UTENTI DataSource @6-FD22AA28
package common.AmvUtenteRecapito;

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

//attributes of DataObject @6-F090A2C0
    

    TextField sesUtente = new TextField(null, null);
    
    TextField sesMVUTE = new TextField(null, null);
    
    DoubleField urlP_COMUNE = new DoubleField(null, null);
    
    DoubleField urlP_PROVINCIA = new DoubleField(null, null);
    
    TextField urlP_CAP = new TextField(null, null);
    
    TextField urlP_VIA = new TextField(null, null);
    
    TextField urlP_INDIRIZZO = new TextField(null, null);
    
    TextField urlP_NUM = new TextField(null, null);
    
    TextField postINDIRIZZO_WEB = new TextField(null, null);
    
    TextField postTELEFONO = new TextField(null, null);
    
    TextField postFAX = new TextField(null, null);
    

    private AD4_UTENTIRow row = new AD4_UTENTIRow();

//End attributes of DataObject

//properties of DataObject @6-10E8D57F

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

    public void  setUrlP_COMUNE( double param ) {
        this.urlP_COMUNE.setValue( param );
    }

    public void  setUrlP_COMUNE( double param, Format ignore ) throws java.text.ParseException {
        this.urlP_COMUNE.setValue( param );
    }

    public void  setUrlP_COMUNE( Object param, Format format ) throws java.text.ParseException {
        this.urlP_COMUNE.setValue( param, format );
    }

    public void  setUrlP_COMUNE( Double param ) {
        this.urlP_COMUNE.setValue( param );
    }

    public void  setUrlP_PROVINCIA( double param ) {
        this.urlP_PROVINCIA.setValue( param );
    }

    public void  setUrlP_PROVINCIA( double param, Format ignore ) throws java.text.ParseException {
        this.urlP_PROVINCIA.setValue( param );
    }

    public void  setUrlP_PROVINCIA( Object param, Format format ) throws java.text.ParseException {
        this.urlP_PROVINCIA.setValue( param, format );
    }

    public void  setUrlP_PROVINCIA( Double param ) {
        this.urlP_PROVINCIA.setValue( param );
    }

    public void  setUrlP_CAP( String param ) {
        this.urlP_CAP.setValue( param );
    }

    public void  setUrlP_CAP( Object param ) {
        this.urlP_CAP.setValue( param );
    }

    public void  setUrlP_CAP( Object param, Format ignore ) {
        this.urlP_CAP.setValue( param );
    }

    public void  setUrlP_VIA( String param ) {
        this.urlP_VIA.setValue( param );
    }

    public void  setUrlP_VIA( Object param ) {
        this.urlP_VIA.setValue( param );
    }

    public void  setUrlP_VIA( Object param, Format ignore ) {
        this.urlP_VIA.setValue( param );
    }

    public void  setUrlP_INDIRIZZO( String param ) {
        this.urlP_INDIRIZZO.setValue( param );
    }

    public void  setUrlP_INDIRIZZO( Object param ) {
        this.urlP_INDIRIZZO.setValue( param );
    }

    public void  setUrlP_INDIRIZZO( Object param, Format ignore ) {
        this.urlP_INDIRIZZO.setValue( param );
    }

    public void  setUrlP_NUM( String param ) {
        this.urlP_NUM.setValue( param );
    }

    public void  setUrlP_NUM( Object param ) {
        this.urlP_NUM.setValue( param );
    }

    public void  setUrlP_NUM( Object param, Format ignore ) {
        this.urlP_NUM.setValue( param );
    }

    public void  setPostINDIRIZZO_WEB( String param ) {
        this.postINDIRIZZO_WEB.setValue( param );
    }

    public void  setPostINDIRIZZO_WEB( Object param ) {
        this.postINDIRIZZO_WEB.setValue( param );
    }

    public void  setPostINDIRIZZO_WEB( Object param, Format ignore ) {
        this.postINDIRIZZO_WEB.setValue( param );
    }

    public void  setPostTELEFONO( String param ) {
        this.postTELEFONO.setValue( param );
    }

    public void  setPostTELEFONO( Object param ) {
        this.postTELEFONO.setValue( param );
    }

    public void  setPostTELEFONO( Object param, Format ignore ) {
        this.postTELEFONO.setValue( param );
    }

    public void  setPostFAX( String param ) {
        this.postFAX.setValue( param );
    }

    public void  setPostFAX( Object param ) {
        this.postFAX.setValue( param );
    }

    public void  setPostFAX( Object param, Format ignore ) {
        this.postFAX.setValue( param );
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

//load @6-FEF9A926
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT AD4_SOGGETTO.GET_NOME(s.SOGGETTO,'Y') NOME, "
                    + "AD4_SOGGETTO.GET_INDIRIZZO_WEB(s.SOGGETTO) INDIRIZZO_WEB "
                    + ", AD4_SOGGETTO.GET_TELEFONO(s.SOGGETTO) TELEFONO "
                    + ",  "
                    + "AD4_SOGGETTO.GET_FAX(s.SOGGETTO) FAX "
                    + "FROM AD4_UTENTI u,  "
                    + "AD4_UTENTI_SOGGETTI s  "
                    + "WHERE u.UTENTE = nvl('{MVUTE}','{Utente}') AND s.utente = u.utente" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
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

//loadDataBind @6-4D26D106
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setNOMINATIVO(Utils.convertToString(ds.parse(record.get("NOME"), row.getNOMINATIVOField())));
            row.setINDIRIZZO_WEB(Utils.convertToString(ds.parse(record.get("INDIRIZZO_WEB"), row.getINDIRIZZO_WEBField())));
            row.setTELEFONO(Utils.convertToString(ds.parse(record.get("TELEFONO"), row.getTELEFONOField())));
            row.setFAX(Utils.convertToString(ds.parse(record.get("FAX"), row.getFAXField())));
        }
//End loadDataBind

//End of load @6-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//update @6-22BE33E6
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
            command.addParameter( "P_COMUNE", urlP_COMUNE, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_PROVINCIA", urlP_PROVINCIA, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) urlP_CAP.getObjectValue() ) ) urlP_CAP.setValue( "" );
            command.addParameter( "P_CAP", urlP_CAP, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) urlP_VIA.getObjectValue() ) ) urlP_VIA.setValue( "" );
            command.addParameter( "P_VIA", urlP_VIA, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) urlP_INDIRIZZO.getObjectValue() ) ) urlP_INDIRIZZO.setValue( "" );
            command.addParameter( "P_INDIRIZZO", urlP_INDIRIZZO, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) urlP_NUM.getObjectValue() ) ) urlP_NUM.setValue( "" );
            command.addParameter( "P_NUM", urlP_NUM, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postINDIRIZZO_WEB.getObjectValue() ) ) postINDIRIZZO_WEB.setValue( "" );
            command.addParameter( "P_INDIRIZZO_WEB", postINDIRIZZO_WEB, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postTELEFONO.getObjectValue() ) ) postTELEFONO.setValue( "" );
            command.addParameter( "P_TELEFONO", postTELEFONO, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postFAX.getObjectValue() ) ) postFAX.setValue( "" );
            command.addParameter( "P_FAX", postFAX, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );

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

//getParameterByName @6-22F4ADA9
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
            if ( "P_COMUNE".equals(name) && "url".equals(prefix) ) {
                param = urlP_COMUNE;
            } else if ( "P_COMUNE".equals(name) && prefix == null ) {
                param = urlP_COMUNE;
            }
            if ( "P_PROVINCIA".equals(name) && "url".equals(prefix) ) {
                param = urlP_PROVINCIA;
            } else if ( "P_PROVINCIA".equals(name) && prefix == null ) {
                param = urlP_PROVINCIA;
            }
            if ( "P_CAP".equals(name) && "url".equals(prefix) ) {
                param = urlP_CAP;
            } else if ( "P_CAP".equals(name) && prefix == null ) {
                param = urlP_CAP;
            }
            if ( "P_VIA".equals(name) && "url".equals(prefix) ) {
                param = urlP_VIA;
            } else if ( "P_VIA".equals(name) && prefix == null ) {
                param = urlP_VIA;
            }
            if ( "P_INDIRIZZO".equals(name) && "url".equals(prefix) ) {
                param = urlP_INDIRIZZO;
            } else if ( "P_INDIRIZZO".equals(name) && prefix == null ) {
                param = urlP_INDIRIZZO;
            }
            if ( "P_NUM".equals(name) && "url".equals(prefix) ) {
                param = urlP_NUM;
            } else if ( "P_NUM".equals(name) && prefix == null ) {
                param = urlP_NUM;
            }
            if ( "INDIRIZZO_WEB".equals(name) && "post".equals(prefix) ) {
                param = postINDIRIZZO_WEB;
            } else if ( "INDIRIZZO_WEB".equals(name) && prefix == null ) {
                param = postINDIRIZZO_WEB;
            }
            if ( "TELEFONO".equals(name) && "post".equals(prefix) ) {
                param = postTELEFONO;
            } else if ( "TELEFONO".equals(name) && prefix == null ) {
                param = postTELEFONO;
            }
            if ( "FAX".equals(name) && "post".equals(prefix) ) {
                param = postFAX;
            } else if ( "FAX".equals(name) && prefix == null ) {
                param = postFAX;
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

