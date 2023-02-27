//SERVIZI_RICHIESTI DataSource @6-E5108078
package restrict.AmvServizi;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End SERVIZI_RICHIESTI DataSource

//class DataObject Header @6-C26E60CC
public class SERVIZI_RICHIESTIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @6-B4D0F91B
    

    TextField sesMVUTE = new TextField(null, null);
    TextField sesUtente = new TextField(null, null);

    private SERVIZI_RICHIESTIRow[] rows = new SERVIZI_RICHIESTIRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @6-9145878E

    public void  setSesMVUTE( String param ) {
        this.sesMVUTE.setValue( param );
    }

    public void  setSesMVUTE( Object param ) {
        this.sesMVUTE.setValue( param );
    }

    public void  setSesMVUTE( Object param, Format ignore ) {
        this.sesMVUTE.setValue( param );
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

    public SERVIZI_RICHIESTIRow[] getRows() {
        return rows;
    }

    public void setRows(SERVIZI_RICHIESTIRow[] rows) {
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

//constructor @6-4D9A9BB0
    public SERVIZI_RICHIESTIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @6-9438662B
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select m.descrizione SERVIZIO,r.data DATA,  "
                    + "r.tipo_notifica||decode(r.indirizzo_notifica,null,null,' a ')||r.indirizzo_notifica NOTIFICA,  "
                    + "AMV_UTENTE.GET_PARAMETRO_RICHIESTA(r.id_richiesta,'RS_AZIENDA') AZIENDA   from ad4_moduli m,  "
                    + "ad4_richieste_abilitazione r where r.modulo = m.modulo "
                    + "and r.utente = nvl('{MVUTE}','{Utente}') "
                    + "and r.stato = 'C' " );
        if ( StringUtils.isEmpty( (String) sesMVUTE.getObjectValue() ) ) sesMVUTE.setValue( "" );
        command.addParameter( "MVUTE", sesMVUTE, null );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select m.descrizione SERVIZIO,r.data DATA,  "
                                                         + "            r.tipo_notifica||decode(r.indirizzo_notifica,null,null,' a ')||r.indirizzo_notifica NOTIFICA,  "
                                                         + "            AMV_UTENTE.GET_PARAMETRO_RICHIESTA(r.id_richiesta,'RS_AZIENDA') AZIENDA from ad4_moduli m, ad4_richieste_abilitazione r where r.modulo = m.modulo and r.utente = nvl('{MVUTE}','{Utente}') and r.stato = 'C'  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "r.data" );
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

//loadDataBind @6-275BAA87
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                SERVIZI_RICHIESTIRow row = new SERVIZI_RICHIESTIRow();
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

//End of load @6-F7C3107A
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        ds.closeConnection();
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @6-7DC497C9
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "MVUTE".equals(name) && "ses".equals(prefix) ) {
                param = sesMVUTE;
            } else if ( "MVUTE".equals(name) && prefix == null ) {
                param = sesMVUTE;
            }
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

//addGridDataObjectListener @6-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @6-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @6-238A81BB
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

//fireBeforeExecuteSelectEvent @6-9DA7B025
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

//fireAfterExecuteSelectEvent @6-F7E8A616
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

//class DataObject Tail @6-ED3F53A4
} // End of class DS
//End class DataObject Tail

