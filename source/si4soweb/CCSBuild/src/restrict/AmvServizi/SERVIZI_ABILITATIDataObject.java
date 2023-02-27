//SERVIZI_ABILITATI DataSource @12-E5108078
package restrict.AmvServizi;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End SERVIZI_ABILITATI DataSource

//class DataObject Header @12-C97B5003
public class SERVIZI_ABILITATIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @12-2D712443
    

    TextField sesUtente = new TextField(null, null);

    private SERVIZI_ABILITATIRow[] rows = new SERVIZI_ABILITATIRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @12-8DC970CC

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

    public SERVIZI_ABILITATIRow[] getRows() {
        return rows;
    }

    public void setRows(SERVIZI_ABILITATIRow[] rows) {
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

//constructor @12-6927C7D2
    public SERVIZI_ABILITATIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @12-E870F19B
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select m.descrizione SERVIZIO, max(r.data) DATA,  "
                    + "max(r.tipo_notifica||decode(r.indirizzo_notifica,null,null,' a ')||r.indirizzo_notifica) NOTIFICA,  "
                    + "max(AMV_UTENTE.GET_PARAMETRO_RICHIESTA(r.id_richiesta,'RS_AZIENDA')) AZIENDA   "
                    + "from ad4_moduli m, ad4_richieste_abilitazione r, ad4_diritti_accesso d  "
                    + "where m.modulo = d.modulo "
                    + "and d.utente = '{Utente}' "
                    + "and nvl(r.stato,'A') = 'A' "
                    + "and d.modulo = r.modulo (+) "
                    + "and d.utente = r.utente (+) "
                    + "and d.istanza = r.istanza (+)  "
                    + "GROUP BY descrizione" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select m.descrizione SERVIZIO, max(r.data) DATA,  "
                                                         + "            max(r.tipo_notifica||decode(r.indirizzo_notifica,null,null,' a ')||r.indirizzo_notifica) NOTIFICA,  "
                                                         + "            max(AMV_UTENTE.GET_PARAMETRO_RICHIESTA(r.id_richiesta,'RS_AZIENDA')) AZIENDA from ad4_moduli m, ad4_richieste_abilitazione r, ad4_diritti_accesso d where m.modulo = d.modulo and d.utente = '{Utente}' and nvl(r.stato,'A') = 'A' and d.modulo = r.modulo (+) and d.utente = r.utente (+) and d.istanza = r.istanza (+) GROUP BY descrizione ) cnt " );
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

//loadDataBind @12-17E9C585
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                SERVIZI_ABILITATIRow row = new SERVIZI_ABILITATIRow();
                DbRow record = (DbRow) records.nextElement();
                row.setSERVIZIO(Utils.convertToString(ds.parse(record.get("SERVIZIO"), row.getSERVIZIOField())));
                try {
                    row.setDATA(Utils.convertToDate(ds.parse(record.get("DATA"), row.getDATAField())));
                } catch ( java.text.ParseException pe ) {
                    model.addError( "Invalid data" );
                }
                row.setNOTIFICA(Utils.convertToString(ds.parse(record.get("NOTIFICA"), row.getNOTIFICAField())));
                row.setAZIENDA(Utils.convertToString(ds.parse(record.get("AZIENDA"), row.getAZIENDAField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @12-F7C3107A
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        ds.closeConnection();
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @12-041216E8
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @12-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @12-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @12-238A81BB
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

//fireBeforeExecuteSelectEvent @12-9DA7B025
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

//fireAfterExecuteSelectEvent @12-F7E8A616
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

//class DataObject Tail @12-ED3F53A4
} // End of class DS
//End class DataObject Tail

