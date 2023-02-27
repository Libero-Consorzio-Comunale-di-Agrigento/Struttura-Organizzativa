//AD4_UTENTE DataSource @6-88B44306
package restrict.AmvUtenteDatiInfo;

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

//attributes of DataObject @6-BC8C7556
    

    TextField sesUtente = new TextField(null, null);
    
    TextField urlMVID = new TextField(null, null);
    
    TextField urlMVID2 = new TextField(null, null);
    

    private AD4_UTENTERow row = new AD4_UTENTERow();

//End attributes of DataObject

//properties of DataObject @6-739AEA0D

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

    public void  setUrlMVID( String param ) {
        this.urlMVID.setValue( param );
    }

    public void  setUrlMVID( Object param ) {
        this.urlMVID.setValue( param );
    }

    public void  setUrlMVID( Object param, Format ignore ) {
        this.urlMVID.setValue( param );
    }

    public void  setUrlMVID2( String param ) {
        this.urlMVID2.setValue( param );
    }

    public void  setUrlMVID2( Object param ) {
        this.urlMVID2.setValue( param );
    }

    public void  setUrlMVID2( Object param, Format ignore ) {
        this.urlMVID2.setValue( param );
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

//load @6-1A625EA6
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
                    + "'../restrict/AmvUtenteDatiInfo.do?MVID='||'{MVID}'||'*MVID2='||'{MVID2}' MVPAGES "
                    + "FROM AD4_UTENTI u, AD4_UTENTI_SOGGETTI s  "
                    + "WHERE u.UTENTE = '{Utente}' AND s.utente = u.utente" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( StringUtils.isEmpty( (String) urlMVID.getObjectValue() ) ) urlMVID.setValue( "" );
        command.addParameter( "MVID", urlMVID, null );
        if ( StringUtils.isEmpty( (String) urlMVID2.getObjectValue() ) ) urlMVID2.setValue( "" );
        command.addParameter( "MVID2", urlMVID2, null );
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

//loadDataBind @6-22789023
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
            row.setMVPAGES(Utils.convertToString(ds.parse(record.get("MVPAGES"), row.getMVPAGESField())));
        }
//End loadDataBind

//End of load @6-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @6-418FEA6F
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "MVID".equals(name) && "url".equals(prefix) ) {
                param = urlMVID;
            } else if ( "MVID".equals(name) && prefix == null ) {
                param = urlMVID;
            }
            if ( "MVID2".equals(name) && "url".equals(prefix) ) {
                param = urlMVID2;
            } else if ( "MVID2".equals(name) && prefix == null ) {
                param = urlMVID2;
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

