//AD4_RICHIESTE_SERVIZIO DataSource @123-2786B8F7
package amvadm.AdmRichieste;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_RICHIESTE_SERVIZIO DataSource

//class DataObject Header @123-607F61E8
public class AD4_RICHIESTE_SERVIZIODataObject extends DS {
//End class DataObject Header

//attributes of DataObject @123-B7369CDF
    

    TextField urlSTATO = new TextField(null, null);
    
    LongField sesGroupID = new LongField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    TextField urlMOD = new TextField(null, null);
    
    TextField urlIST = new TextField(null, null);
    

    private AD4_RICHIESTE_SERVIZIORow[] rows = new AD4_RICHIESTE_SERVIZIORow[100];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @123-47363D26

    public void  setUrlSTATO( String param ) {
        this.urlSTATO.setValue( param );
    }

    public void  setUrlSTATO( Object param ) {
        this.urlSTATO.setValue( param );
    }

    public void  setUrlSTATO( Object param, Format ignore ) {
        this.urlSTATO.setValue( param );
    }

    public void  setSesGroupID( long param ) {
        this.sesGroupID.setValue( param );
    }

    public void  setSesGroupID( long param, Format ignore ) throws java.text.ParseException {
        this.sesGroupID.setValue( param );
    }

    public void  setSesGroupID( Object param, Format format ) throws java.text.ParseException {
        this.sesGroupID.setValue( param, format );
    }

    public void  setSesGroupID( Long param ) {
        this.sesGroupID.setValue( param );
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

    public void  setUrlMOD( String param ) {
        this.urlMOD.setValue( param );
    }

    public void  setUrlMOD( Object param ) {
        this.urlMOD.setValue( param );
    }

    public void  setUrlMOD( Object param, Format ignore ) {
        this.urlMOD.setValue( param );
    }

    public void  setUrlIST( String param ) {
        this.urlIST.setValue( param );
    }

    public void  setUrlIST( Object param ) {
        this.urlIST.setValue( param );
    }

    public void  setUrlIST( Object param, Format ignore ) {
        this.urlIST.setValue( param );
    }

    public AD4_RICHIESTE_SERVIZIORow[] getRows() {
        return rows;
    }

    public void setRows(AD4_RICHIESTE_SERVIZIORow[] rows) {
        this.rows = rows;
    }

    public void setPageNum( int pageNum ) {
        this.pageNum = pageNum;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize( int pageSize ) {
        this.pageSize = pageSize;
    }

//End properties of DataObject

//constructor @123-4275BE45
    public AD4_RICHIESTE_SERVIZIODataObject(Page page) {
        super(page);
    }
//End constructor

//load @123-0123929B
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT r.id_richiesta id "
                    + ",  "
                    + "'n.'||r.id_richiesta||' del '||to_char(r.data,'dd/mm/yyyy') DATA "
                    + ", u.nominativo autore "
                    + ", m.descrizione||'-'||r.istanza servizio "
                    + ",  "
                    + "p.valore azienda "
                    + ",  "
                    + "decode(ad4_soggetto.get_indirizzo_web(s.SOGGETTO,'Y'),null,'','&nbsp;('||ad4_soggetto.get_indirizzo_web(s.SOGGETTO)||')') indirizzo_web "
                    + ",  "
                    + "decode(r.notificata,'S','(Notifica avvenuta)','F','(Notifica fallita)','') notificata "
                    + ",  "
                    + "r.tipo_notifica||' '||r.indirizzo_notifica indirizzo_notifica "
                    + ",  "
                    + "decode('{STATO}','C','Approva','F','Approva','') APPROVA "
                    + ",  "
                    + "decode('{STATO}','C','Respingi','F','Respingi','') RESPINGI "
                    + ",  "
                    + "decode('{STATO}','A',decode(r.notificata,'S','','Notifica'),'') NOTIFICA "
                    + ",  "
                    + "serv.abilitazione abilitazione "
                    + "FROM ad4_richieste_abilitazione r "
                    + ", ad4_utenti u "
                    + ", ad4_utenti_soggetti s "
                    + ", ad4_moduli m "
                    + ",  "
                    + "ad4_parametri_richiesta p "
                    + ", ad4_ruoli ru "
                    + ", ad4_diritti_accesso d "
                    + ",  "
                    + "ad4_servizi serv  "
                    + "WHERE ru.ruolo = d.ruolo "
                    + "AND nvl(ru.profilo,-1) = nvl({GroupID},-1) "
                    + "AND d.utente = '{Utente}' "
                    + "AND d.modulo = r.modulo "
                    + "AND d.istanza = r.istanza "
                    + "AND u.utente = r.utente "
                    + "AND serv.modulo = r.modulo "
                    + "AND serv.istanza = r.istanza "
                    + "AND s.utente (+) = u.utente  "
                    + "AND m.modulo = r.modulo "
                    + "AND r.id_richiesta = p.id_richiesta (+) "
                    + "AND p.parametro (+) = 'RS_AZIENDA' "
                    + "AND r.stato = '{STATO}' "
                    + "AND r.modulo = '{MOD}' "
                    + "AND r.istanza = '{IST}' "
                    + "" );
        if ( StringUtils.isEmpty( (String) urlSTATO.getObjectValue() ) ) urlSTATO.setValue( "" );
        command.addParameter( "STATO", urlSTATO, null );
        if ( sesGroupID.getObjectValue() == null ) sesGroupID.setValue( -1 );
        command.addParameter( "GroupID", sesGroupID, null );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( StringUtils.isEmpty( (String) urlMOD.getObjectValue() ) ) urlMOD.setValue( "" );
        command.addParameter( "MOD", urlMOD, null );
        if ( StringUtils.isEmpty( (String) urlIST.getObjectValue() ) ) urlIST.setValue( "" );
        command.addParameter( "IST", urlIST, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT r.id_richiesta id ,  "
                                                         + "            'n.'||r.id_richiesta||' del '||to_char(r.data,'dd/mm/yyyy') DATA , u.nominativo autore ,  "
                                                         + "            m.descrizione||'-'||r.istanza servizio , p.valore azienda ,  "
                                                         + "            decode(ad4_soggetto.get_indirizzo_web(s.SOGGETTO,'Y'),null,'','&nbsp;('||ad4_soggetto.get_indirizzo_web(s.SOGGETTO)||')') indirizzo_web , decode(r.notificata,'S','(Notifica avvenuta)','F','(Notifica fallita)','') notificata , r.tipo_notifica||' '||r.indirizzo_notifica indirizzo_notifica , decode('{STATO}','C','Approva','F','Approva','') APPROVA , decode('{STATO}','C','Respingi','F','Respingi','') RESPINGI , decode('{STATO}','A',decode(r.notificata,'S','','Notifica'),'') NOTIFICA , serv.abilitazione abilitazione FROM ad4_richieste_abilitazione r , ad4_utenti u , ad4_utenti_soggetti s , ad4_moduli m , ad4_parametri_richiesta p , ad4_ruoli ru , ad4_diritti_accesso d , ad4_servizi serv WHERE ru.ruolo = d.ruolo AND nvl(ru.profilo,-1) = nvl({GroupID},-1) AND d.utente = '{Utente}' AND d.modulo = r.modulo AND d.istanza = r.istanza AND u.utente = r.utente AND serv.modulo = r.modulo AND serv.istanza = r.istanza AND s.utente (+) = u.utente AND m.modulo = r.modulo AND r.id_richiesta = p.id_richiesta (+) AND p.parametro (+) = 'RS_AZIENDA' AND r.stato = '{STATO}' AND r.modulo = '{MOD}' AND r.istanza = '{IST}'  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "r.data DESC" );
        }
        command.setStartPos( ( pageNum - 1 ) * pageSize + 1 );
        command.setFetchSize( pageSize );

        fireBeforeBuildSelectEvent( new DataObjectEvent(command) );


        fireBeforeExecuteSelectEvent( new DataObjectEvent(command) );

        if ( ! StringUtils.isEmpty( command.getCountSql() ) ) {
            if ( ! ds.hasErrors() ) {
                amountOfRows = command.count();
                CCLogger.getInstance().debug(command.toString());
            }
        }
        Enumeration records = null;
        if ( ! ds.hasErrors() ) {
            records = command.getRows();
        }

        CCLogger.getInstance().debug(command.toString());

        fireAfterExecuteSelectEvent( new DataObjectEvent(command) );

        ds.closeConnection();
//End load

//loadDataBind @123-7E486197
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AD4_RICHIESTE_SERVIZIORow row = new AD4_RICHIESTE_SERVIZIORow();
                DbRow record = (DbRow) records.nextElement();
                row.setDATA(Utils.convertToString(ds.parse(record.get("DATA"), row.getDATAField())));
                row.setAUTORE(Utils.convertToString(ds.parse(record.get("AUTORE"), row.getAUTOREField())));
                row.setINDIRIZZO_WEB(Utils.convertToString(ds.parse(record.get("INDIRIZZO_WEB"), row.getINDIRIZZO_WEBField())));
                row.setINDIRIZZO_NOTIFICA(Utils.convertToString(ds.parse(record.get("INDIRIZZO_NOTIFICA"), row.getINDIRIZZO_NOTIFICAField())));
                row.setNOTIFICATA(Utils.convertToString(ds.parse(record.get("NOTIFICATA"), row.getNOTIFICATAField())));
                row.setAZIENDA(Utils.convertToString(ds.parse(record.get("AZIENDA"), row.getAZIENDAField())));
                row.setAPPROVA(Utils.convertToString(ds.parse(record.get("APPROVA"), row.getAPPROVAField())));
                row.setRESPINGI(Utils.convertToString(ds.parse(record.get("RESPINGI"), row.getRESPINGIField())));
                row.setNOTIFICA(Utils.convertToString(ds.parse(record.get("NOTIFICA"), row.getNOTIFICAField())));
                row.setID(Utils.convertToString(ds.parse(record.get("ID"), row.getIDField())));
                row.setAB(Utils.convertToString(ds.parse(record.get("ABILITAZIONE"), row.getABField())));
                row.setABILITAZIONE(Utils.convertToString(ds.parse(record.get("ABILITAZIONE"), row.getABILITAZIONEField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @123-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @123-BF97E20E
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "STATO".equals(name) && "url".equals(prefix) ) {
                param = urlSTATO;
            } else if ( "STATO".equals(name) && prefix == null ) {
                param = urlSTATO;
            }
            if ( "GroupID".equals(name) && "ses".equals(prefix) ) {
                param = sesGroupID;
            } else if ( "GroupID".equals(name) && prefix == null ) {
                param = sesGroupID;
            }
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "MOD".equals(name) && "url".equals(prefix) ) {
                param = urlMOD;
            } else if ( "MOD".equals(name) && prefix == null ) {
                param = urlMOD;
            }
            if ( "IST".equals(name) && "url".equals(prefix) ) {
                param = urlIST;
            } else if ( "IST".equals(name) && prefix == null ) {
                param = urlIST;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @123-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @123-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @123-238A81BB
    public void fireBeforeBuildSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource(this);
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i < v.size(); i++) {
            ((DataObjectListener)v.elementAt(i)).beforeBuildSelect(e);
        }
    }
//End fireBeforeBuildSelectEvent

//fireBeforeExecuteSelectEvent @123-9DA7B025
    public void fireBeforeExecuteSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i < v.size(); i++) {
            ((DataObjectListener)v.elementAt(i)).beforeExecuteSelect(e);
        }
    }
//End fireBeforeExecuteSelectEvent

//fireAfterExecuteSelectEvent @123-F7E8A616
    public void fireAfterExecuteSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i=0; i < v.size(); i++) {
            ((DataObjectListener)v.elementAt(i)).afterExecuteSelect(e);
        }
    }
//End fireAfterExecuteSelectEvent

//class DataObject Tail @123-ED3F53A4
} // End of class DS
//End class DataObject Tail

