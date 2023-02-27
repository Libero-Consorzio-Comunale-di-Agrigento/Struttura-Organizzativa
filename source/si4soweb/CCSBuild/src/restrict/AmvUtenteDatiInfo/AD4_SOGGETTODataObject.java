//AD4_SOGGETTO DataSource @52-88B44306
package restrict.AmvUtenteDatiInfo;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_SOGGETTO DataSource

//class DataObject Header @52-255A1D66
public class AD4_SOGGETTODataObject extends DS {
//End class DataObject Header

//attributes of DataObject @52-1C07A33D
    

    TextField sesUtente = new TextField(null, null);
    
    TextField postCOGNOME = new TextField(null, null);
    
    TextField postNOME = new TextField(null, null);
    
    TextField postSESSO = new TextField(null, null);
    
    DoubleField postCOMUNE_NASCITA = new DoubleField(null, null);
    
    DoubleField postPROVINCIA_NASCITA = new DoubleField(null, null);
    
    TextField postDATA_NASCITA = new TextField(null, null);
    
    TextField postCODICE_FISCALE = new TextField(null, null);
    

    private AD4_SOGGETTORow row = new AD4_SOGGETTORow();

//End attributes of DataObject

//properties of DataObject @52-B932022A

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

    public void  setPostCOGNOME( String param ) {
        this.postCOGNOME.setValue( param );
    }

    public void  setPostCOGNOME( Object param ) {
        this.postCOGNOME.setValue( param );
    }

    public void  setPostCOGNOME( Object param, Format ignore ) {
        this.postCOGNOME.setValue( param );
    }

    public void  setPostNOME( String param ) {
        this.postNOME.setValue( param );
    }

    public void  setPostNOME( Object param ) {
        this.postNOME.setValue( param );
    }

    public void  setPostNOME( Object param, Format ignore ) {
        this.postNOME.setValue( param );
    }

    public void  setPostSESSO( String param ) {
        this.postSESSO.setValue( param );
    }

    public void  setPostSESSO( Object param ) {
        this.postSESSO.setValue( param );
    }

    public void  setPostSESSO( Object param, Format ignore ) {
        this.postSESSO.setValue( param );
    }

    public void  setPostCOMUNE_NASCITA( double param ) {
        this.postCOMUNE_NASCITA.setValue( param );
    }

    public void  setPostCOMUNE_NASCITA( double param, Format ignore ) throws java.text.ParseException {
        this.postCOMUNE_NASCITA.setValue( param );
    }

    public void  setPostCOMUNE_NASCITA( Object param, Format format ) throws java.text.ParseException {
        this.postCOMUNE_NASCITA.setValue( param, format );
    }

    public void  setPostCOMUNE_NASCITA( Double param ) {
        this.postCOMUNE_NASCITA.setValue( param );
    }

    public void  setPostPROVINCIA_NASCITA( double param ) {
        this.postPROVINCIA_NASCITA.setValue( param );
    }

    public void  setPostPROVINCIA_NASCITA( double param, Format ignore ) throws java.text.ParseException {
        this.postPROVINCIA_NASCITA.setValue( param );
    }

    public void  setPostPROVINCIA_NASCITA( Object param, Format format ) throws java.text.ParseException {
        this.postPROVINCIA_NASCITA.setValue( param, format );
    }

    public void  setPostPROVINCIA_NASCITA( Double param ) {
        this.postPROVINCIA_NASCITA.setValue( param );
    }

    public void  setPostDATA_NASCITA( String param ) {
        this.postDATA_NASCITA.setValue( param );
    }

    public void  setPostDATA_NASCITA( Object param ) {
        this.postDATA_NASCITA.setValue( param );
    }

    public void  setPostDATA_NASCITA( Object param, Format ignore ) {
        this.postDATA_NASCITA.setValue( param );
    }

    public void  setPostCODICE_FISCALE( String param ) {
        this.postCODICE_FISCALE.setValue( param );
    }

    public void  setPostCODICE_FISCALE( Object param ) {
        this.postCODICE_FISCALE.setValue( param );
    }

    public void  setPostCODICE_FISCALE( Object param, Format ignore ) {
        this.postCODICE_FISCALE.setValue( param );
    }

    public AD4_SOGGETTORow getRow() {
        return row;
    }

    public void setRow( AD4_SOGGETTORow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @52-F3495049
    public AD4_SOGGETTODataObject(Page page) {
        super(page);
    }
//End constructor

//load @52-DD1C9E67
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select * from AD4_UTENTI_SOGGETTI "
                    + "where utente = '{Utente}'" );
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

//loadDataBind @52-2E45A34B
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setCOGNOME(Utils.convertToString(ds.parse(record.get("UTENTE"), row.getCOGNOMEField())));
            row.setNOME(Utils.convertToString(ds.parse(record.get("SOGGETTO"), row.getNOMEField())));
        }
//End loadDataBind

//End of load @52-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//insert @52-E36FEB6C
        boolean insert() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ ? = call AMV_UTENTE.CREA_SOGGETTO ( ?, ?, ?, ?, ?, ?, ?, ? ) }" );
            command.addParameter( "RETURN_VALUE", null, java.sql.Types.DOUBLE, 0, SPParameter.OUTPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
            command.addParameter( "P_UTENTE", sesUtente, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postCOGNOME.getObjectValue() ) ) postCOGNOME.setValue( "" );
            command.addParameter( "P_COGNOME", postCOGNOME, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postNOME.getObjectValue() ) ) postNOME.setValue( "" );
            command.addParameter( "P_NOME", postNOME, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postSESSO.getObjectValue() ) ) postSESSO.setValue( "" );
            command.addParameter( "P_SESSO", postSESSO, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_COMUNE_NAS", postCOMUNE_NASCITA, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            command.addParameter( "P_PROVINCIA_NAS", postPROVINCIA_NASCITA, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postDATA_NASCITA.getObjectValue() ) ) postDATA_NASCITA.setValue( "" );
            command.addParameter( "P_DATA_NASCITA", postDATA_NASCITA, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postCODICE_FISCALE.getObjectValue() ) ) postCODICE_FISCALE.setValue( "" );
            command.addParameter( "P_CODICE_FISCALE", postCODICE_FISCALE, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );

            fireBeforeBuildInsertEvent( new DataObjectEvent(command) );

//End insert

//insertDataBound @52-BC781F8A
            fireBeforeExecuteInsertEvent( new DataObjectEvent(command) );

            if ( ! ds.hasErrors() ) {
                command.executeUpdate();
            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteInsertEvent( new DataObjectEvent(command) );

//End insertDataBound

//End of insert @52-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of insert

//update @52-9183C187
        boolean update() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            command.setSql( "null" );

            fireBeforeBuildUpdateEvent( new DataObjectEvent(command) );


//End update

//updateDataBound @52-0130DCE2
            fireBeforeExecuteUpdateEvent( new DataObjectEvent(command) );

            if ( ! ds.hasErrors() ) {
                command.executeUpdate();
            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteUpdateEvent( new DataObjectEvent(command) );

//End updateDataBound

//End of update @52-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of update

//getParameterByName @52-3AF36E0C
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "COGNOME".equals(name) && "post".equals(prefix) ) {
                param = postCOGNOME;
            } else if ( "COGNOME".equals(name) && prefix == null ) {
                param = postCOGNOME;
            }
            if ( "NOME".equals(name) && "post".equals(prefix) ) {
                param = postNOME;
            } else if ( "NOME".equals(name) && prefix == null ) {
                param = postNOME;
            }
            if ( "SESSO".equals(name) && "post".equals(prefix) ) {
                param = postSESSO;
            } else if ( "SESSO".equals(name) && prefix == null ) {
                param = postSESSO;
            }
            if ( "COMUNE_NASCITA".equals(name) && "post".equals(prefix) ) {
                param = postCOMUNE_NASCITA;
            } else if ( "COMUNE_NASCITA".equals(name) && prefix == null ) {
                param = postCOMUNE_NASCITA;
            }
            if ( "PROVINCIA_NASCITA".equals(name) && "post".equals(prefix) ) {
                param = postPROVINCIA_NASCITA;
            } else if ( "PROVINCIA_NASCITA".equals(name) && prefix == null ) {
                param = postPROVINCIA_NASCITA;
            }
            if ( "DATA_NASCITA".equals(name) && "post".equals(prefix) ) {
                param = postDATA_NASCITA;
            } else if ( "DATA_NASCITA".equals(name) && prefix == null ) {
                param = postDATA_NASCITA;
            }
            if ( "CODICE_FISCALE".equals(name) && "post".equals(prefix) ) {
                param = postCODICE_FISCALE;
            } else if ( "CODICE_FISCALE".equals(name) && prefix == null ) {
                param = postCODICE_FISCALE;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addRecordDataObjectListener @52-47141785
    public synchronized void addRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.addElement(l);
    }
//End addRecordDataObjectListener

//removeRecordDataObjectListener @52-A1ABC1F4
    public synchronized void removeRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeRecordDataObjectListener

//fireBeforeBuildSelectEvent @52-305A023C
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

//fireBeforeExecuteSelectEvent @52-D00ACF95
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

//fireAfterExecuteSelectEvent @52-3BAD39CE
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

//fireBeforeBuildInsertEvent @52-FBA08B71
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

//fireBeforeExecuteInsertEvent @52-47AFA6A5
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

//fireAfterExecuteInsertEvent @52-E9CE95AE
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

//fireBeforeBuildSelectEvent @52-2405BE8B
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

//fireBeforeExecuteSelectEvent @52-E9DFF86B
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

//fireAfterExecuteSelectEvent @52-580A2987
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

//fireBeforeBuildSelectEvent @52-D021D0EA
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

//fireBeforeExecuteDeleteEvent @52-DD540FBB
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

//fireAfterExecuteDeleteEvent @52-2A6E2049
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

//class DataObject Tail @52-ED3F53A4
} // End of class DS
//End class DataObject Tail

