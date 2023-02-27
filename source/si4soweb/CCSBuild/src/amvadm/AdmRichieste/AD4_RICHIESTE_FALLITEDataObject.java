//AD4_RICHIESTE_FALLITE DataSource @106-2786B8F7
package amvadm.AdmRichieste;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_RICHIESTE_FALLITE DataSource

//class DataObject Header @106-EFB0E53C
public class AD4_RICHIESTE_FALLITEDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @106-28ADE194
    

    private AD4_RICHIESTE_FALLITERow[] rows = new AD4_RICHIESTE_FALLITERow[100];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @106-19B524D4

    public AD4_RICHIESTE_FALLITERow[] getRows() {
        return rows;
    }

    public void setRows(AD4_RICHIESTE_FALLITERow[] rows) {
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

//constructor @106-2BEA823E
    public AD4_RICHIESTE_FALLITEDataObject(Page page) {
        super(page);
    }
//End constructor

//load @106-1B43E50C
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT m.descrizione||' - '||i.descrizione servizio, l.descrizione livello,  "
                    + "r.modulo, r.istanza,  "
                    + "count(r.id_richiesta) totale_richieste FROM ad4_richieste_abilitazione r, ad4_istanze i, ad4_moduli m, ad4_livelli_sicurezza l,  "
                    + "ad4_servizi s "
                    + "WHERE r.modulo = m.modulo "
                    + "AND r.istanza = i.istanza "
                    + "AND s.istanza = r.istanza "
                    + "AND s.modulo = r.modulo "
                    + "AND s.livello = l.livello (+) "
                    + "AND r.stato = 'F' "
                    + "GROUP BY r.modulo, r.istanza, m.descrizione, i.descrizione, l.descrizione "
                    + "" );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT m.descrizione||' - '||i.descrizione servizio, l.descrizione livello,  "
                                                         + "            r.modulo, r.istanza,  "
                                                         + "            count(r.id_richiesta) totale_richieste FROM ad4_richieste_abilitazione r, ad4_istanze i, ad4_moduli m,  "
                                                         + "            ad4_livelli_sicurezza l,  "
                                                         + "            ad4_servizi s WHERE r.modulo = m.modulo AND r.istanza = i.istanza AND s.istanza = r.istanza AND s.modulo = r.modulo AND s.livello = l.livello (+) AND r.stato = 'F' GROUP BY r.modulo, r.istanza, m.descrizione, i.descrizione, l.descrizione  ) cnt " );
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

//End load

//loadDataBind @106-F5EE3A4C
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AD4_RICHIESTE_FALLITERow row = new AD4_RICHIESTE_FALLITERow();
                DbRow record = (DbRow) records.nextElement();
                row.setSERVIZIO(Utils.convertToString(ds.parse(record.get("SERVIZIO"), row.getSERVIZIOField())));
                row.setLIVELLO(Utils.convertToString(ds.parse(record.get("LIVELLO"), row.getLIVELLOField())));
                row.setTOTALE_RICHIESTE(Utils.convertToString(ds.parse(record.get("TOTALE_RICHIESTE"), row.getTOTALE_RICHIESTEField())));
                row.setMOD(Utils.convertToString(ds.parse(record.get("MODULO"), row.getMODField())));
                row.setMODULO(Utils.convertToString(ds.parse(record.get("MODULO"), row.getMODULOField())));
                row.setIST(Utils.convertToString(ds.parse(record.get("ISTANZA"), row.getISTField())));
                row.setISTANZA(Utils.convertToString(ds.parse(record.get("ISTANZA"), row.getISTANZAField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @106-F7C3107A
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        ds.closeConnection();
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @106-AE30C4C3
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @106-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @106-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @106-238A81BB
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

//fireBeforeExecuteSelectEvent @106-9DA7B025
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

//fireAfterExecuteSelectEvent @106-F7E8A616
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

//class DataObject Tail @106-ED3F53A4
} // End of class DS
//End class DataObject Tail

