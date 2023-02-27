//SERVIZI_ABILITATI DataSource @10-02ADAFC3
package common.AmvServiziAbilitatiElenco_i;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End SERVIZI_ABILITATI DataSource

//class DataObject Header @10-C97B5003
public class SERVIZI_ABILITATIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @10-48CB0044
    

    TextField sesUtente = new TextField(null, null);
    
    TextField sesMVUTE = new TextField(null, null);
    
    TextField sesProgetto = new TextField(null, null);
    
    LongField urlID = new LongField(null, null);
    

    private SERVIZI_ABILITATIRow[] rows = new SERVIZI_ABILITATIRow[10];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @10-0D6CB5CE

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

    public void  setSesProgetto( String param ) {
        this.sesProgetto.setValue( param );
    }

    public void  setSesProgetto( Object param ) {
        this.sesProgetto.setValue( param );
    }

    public void  setSesProgetto( Object param, Format ignore ) {
        this.sesProgetto.setValue( param );
    }

    public void  setUrlID( long param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlID( long param, Format ignore ) throws java.text.ParseException {
        this.urlID.setValue( param );
    }

    public void  setUrlID( Object param, Format format ) throws java.text.ParseException {
        this.urlID.setValue( param, format );
    }

    public void  setUrlID( Long param ) {
        this.urlID.setValue( param );
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

//constructor @10-6927C7D2
    public SERVIZI_ABILITATIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @10-3D9FC612
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select 'n.'||r.id_richiesta||' del '||max(r.data) DATA "
                    + ",  "
                    + "m.descrizione||' - '||i.descrizione SERVIZIO "
                    + ", max(r.tipo_notifica||' '||r.indirizzo_notifica) NOTIFICA "
                    + ",  "
                    + "max(AMV_UTENTE.GET_PARAMETRO_RICHIESTA(r.id_richiesta,'RS_AZIENDA')) AZIENDA   "
                    + "from ad4_moduli m, ad4_richieste_abilitazione r, ad4_istanze i, ad4_diritti_accesso d  "
                    + "where m.modulo = d.modulo "
                    + "and m.progetto = '{Progetto}' "
                    + "and i.istanza = d.istanza "
                    + "and d.utente = nvl(AMV_UTENTE.GET_UTENTE_RICHIESTA({ID}),nvl('{MVUTE}','{Utente}')) "
                    + "and nvl(r.stato,'A') = 'A' "
                    + "and d.modulo = r.modulo (+) "
                    + "and d.utente = r.utente (+) "
                    + "and d.istanza = r.istanza (+)  "
                    + "GROUP BY m.descrizione, i.descrizione, r.id_richiesta "
                    + "" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( StringUtils.isEmpty( (String) sesMVUTE.getObjectValue() ) ) sesMVUTE.setValue( "" );
        command.addParameter( "MVUTE", sesMVUTE, null );
        if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "" );
        command.addParameter( "Progetto", sesProgetto, null );
        if ( urlID.getObjectValue() == null ) urlID.setValue( -1 );
        command.addParameter( "ID", urlID, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select 'n.'||r.id_richiesta||' del '||max(r.data) DATA ,  "
                                                         + "            m.descrizione||' - '||i.descrizione SERVIZIO ,  "
                                                         + "            max(r.tipo_notifica||' '||r.indirizzo_notifica) NOTIFICA ,  "
                                                         + "            max(AMV_UTENTE.GET_PARAMETRO_RICHIESTA(r.id_richiesta,'RS_AZIENDA')) AZIENDA from ad4_moduli m,  "
                                                         + "            ad4_richieste_abilitazione r, ad4_istanze i,  "
                                                         + "            ad4_diritti_accesso d where m.modulo = d.modulo and m.progetto = '{Progetto}' and i.istanza = d.istanza and d.utente = nvl(AMV_UTENTE.GET_UTENTE_RICHIESTA({ID}),nvl('{MVUTE}','{Utente}')) and nvl(r.stato,'A') = 'A' and d.modulo = r.modulo (+) and d.utente = r.utente (+) and d.istanza = r.istanza (+) GROUP BY m.descrizione, i.descrizione, r.id_richiesta  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "DATA desc" );
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

//loadDataBind @10-409E148C
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                SERVIZI_ABILITATIRow row = new SERVIZI_ABILITATIRow();
                DbRow record = (DbRow) records.nextElement();
                row.setDATA(Utils.convertToString(ds.parse(record.get("DATA"), row.getDATAField())));
                row.setSERVIZIO(Utils.convertToString(ds.parse(record.get("SERVIZIO"), row.getSERVIZIOField())));
                row.setNOTIFICA(Utils.convertToString(ds.parse(record.get("NOTIFICA"), row.getNOTIFICAField())));
                row.setAZIENDA(Utils.convertToString(ds.parse(record.get("AZIENDA"), row.getAZIENDAField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @10-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @10-FC286AF6
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
            if ( "Progetto".equals(name) && "ses".equals(prefix) ) {
                param = sesProgetto;
            } else if ( "Progetto".equals(name) && prefix == null ) {
                param = sesProgetto;
            }
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

//addGridDataObjectListener @10-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @10-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @10-238A81BB
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

//fireBeforeExecuteSelectEvent @10-9DA7B025
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

//fireAfterExecuteSelectEvent @10-F7E8A616
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

//class DataObject Tail @10-ED3F53A4
} // End of class DS
//End class DataObject Tail

