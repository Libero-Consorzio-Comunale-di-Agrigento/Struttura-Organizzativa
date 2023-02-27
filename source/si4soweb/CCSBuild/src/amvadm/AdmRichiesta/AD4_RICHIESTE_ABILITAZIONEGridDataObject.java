//AD4_RICHIESTE_ABILITAZIONEGrid DataSource @30-0C95D343
package amvadm.AdmRichiesta;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_RICHIESTE_ABILITAZIONEGrid DataSource

//class DataObject Header @30-55711267
public class AD4_RICHIESTE_ABILITAZIONEGridDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @30-97819BD1
    

    TextField urlID = new TextField(null, null);
    

    private AD4_RICHIESTE_ABILITAZIONEGridRow[] rows = new AD4_RICHIESTE_ABILITAZIONEGridRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @30-26F861B4

    public void  setUrlID( String param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlID( Object param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlID( Object param, Format ignore ) {
        this.urlID.setValue( param );
    }

    public AD4_RICHIESTE_ABILITAZIONEGridRow[] getRows() {
        return rows;
    }

    public void setRows(AD4_RICHIESTE_ABILITAZIONEGridRow[] rows) {
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

//constructor @30-676A398D
    public AD4_RICHIESTE_ABILITAZIONEGridDataObject(Page page) {
        super(page);
    }
//End constructor

//load @30-AB8F4820
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT m.descrizione||' - '||i.descrizione servizio "
                    + ", u.nominativo richiedente "
                    + ",  "
                    + "u.utente "
                    + ", 'n.'||r.id_richiesta||' del '||to_char(r.data,'dd/mm/yyyy') data "
                    + ",  "
                    + "decode(r.stato,'C','In attesa di approvazione (Dati convalidati)','F',  "
                    + "'In attesa di revisione (Dati non corretti)','A','Approvata','R','Respinta') stato "
                    + ",  "
                    + "r.stato COD_STATO "
                    + ", decode(r.notificata,'S','SI','N',  "
                    + "'NO','F','Notifica fallita') notificata "
                    + ", r.notificata COD_NOTIFICATA "
                    + ", r.tipo_notifica tipo_notifica "
                    + ",  "
                    + "r.indirizzo_notifica indirizzo_notifica "
                    + " FROM ad4_richieste_abilitazione r,  "
                    + "ad4_istanze i, ad4_moduli m,  "
                    + "ad4_utenti u "
                    + "WHERE r.modulo = m.modulo "
                    + "AND r.istanza = i.istanza "
                    + "AND r.utente = u.utente "
                    + "AND r.id_richiesta = '{ID}'" );
        if ( StringUtils.isEmpty( (String) urlID.getObjectValue() ) ) urlID.setValue( "" );
        command.addParameter( "ID", urlID, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT m.descrizione||' - '||i.descrizione servizio , u.nominativo richiedente ,  "
                                                         + "            u.utente ,  "
                                                         + "            'n.'||r.id_richiesta||' del '||to_char(r.data,'dd/mm/yyyy') data ,  "
                                                         + "            decode(r.stato,'C','In attesa di approvazione (Dati convalidati)','F',  "
                                                         + "            'In attesa di revisione (Dati non corretti)','A','Approvata','R','Respinta') stato , r.stato COD_STATO ,  "
                                                         + "            decode(r.notificata,'S','SI','N', 'NO','F','Notifica fallita') notificata ,  "
                                                         + "            r.notificata COD_NOTIFICATA , r.tipo_notifica tipo_notifica ,  "
                                                         + "            r.indirizzo_notifica indirizzo_notifica FROM ad4_richieste_abilitazione r,  "
                                                         + "            ad4_istanze i, ad4_moduli m,  "
                                                         + "            ad4_utenti u WHERE r.modulo = m.modulo AND r.istanza = i.istanza AND r.utente = u.utente AND r.id_richiesta = '{ID}' ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
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

//loadDataBind @30-15B9AE94
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AD4_RICHIESTE_ABILITAZIONEGridRow row = new AD4_RICHIESTE_ABILITAZIONEGridRow();
                DbRow record = (DbRow) records.nextElement();
                row.setDATA(Utils.convertToString(ds.parse(record.get("DATA"), row.getDATAField())));
                row.setSERVIZIO(Utils.convertToString(ds.parse(record.get("SERVIZIO"), row.getSERVIZIOField())));
                row.setRICHIEDENTE(Utils.convertToString(ds.parse(record.get("RICHIEDENTE"), row.getRICHIEDENTEField())));
                row.setUTENTE(Utils.convertToString(ds.parse(record.get("UTENTE"), row.getUTENTEField())));
                row.setSTATO(Utils.convertToString(ds.parse(record.get("STATO"), row.getSTATOField())));
                row.setCOD_STATO(Utils.convertToString(ds.parse(record.get("COD_STATO"), row.getCOD_STATOField())));
                row.setNOTIFICATA(Utils.convertToString(ds.parse(record.get("NOTIFICATA"), row.getNOTIFICATAField())));
                row.setCOD_NOTIFICATA(Utils.convertToString(ds.parse(record.get("COD_NOTIFICATA"), row.getCOD_NOTIFICATAField())));
                row.setTIPO_NOTIFICA(Utils.convertToString(ds.parse(record.get("TIPO_NOTIFICA"), row.getTIPO_NOTIFICAField())));
                row.setINDIRIZZO_NOTIFICA(Utils.convertToString(ds.parse(record.get("INDIRIZZO_NOTIFICA"), row.getINDIRIZZO_NOTIFICAField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @30-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @30-1BE048C3
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "ID".equals(name) && "url".equals(prefix) ) {
                param = urlID;
            } else if ( "ID".equals(name) && prefix == null ) {
                param = urlID;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @30-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @30-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @30-238A81BB
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

//fireBeforeExecuteSelectEvent @30-9DA7B025
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

//fireAfterExecuteSelectEvent @30-F7E8A616
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

//class DataObject Tail @30-ED3F53A4
} // End of class DS
//End class DataObject Tail

