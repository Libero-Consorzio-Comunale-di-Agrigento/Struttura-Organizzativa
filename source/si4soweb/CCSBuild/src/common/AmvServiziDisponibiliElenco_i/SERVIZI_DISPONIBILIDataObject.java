//SERVIZI_DISPONIBILI DataSource @16-C913BA80
package common.AmvServiziDisponibiliElenco_i;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End SERVIZI_DISPONIBILI DataSource

//class DataObject Header @16-82779F77
public class SERVIZI_DISPONIBILIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @16-518FCC88
    

    TextField sesUtente = new TextField(null, null);
    
    TextField sesProgetto = new TextField(null, null);
    
    TextField sesMVUTE = new TextField(null, null);
    
    LongField urlID = new LongField(null, null);
    

    private SERVIZI_DISPONIBILIRow[] rows = new SERVIZI_DISPONIBILIRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @16-C01D6653

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
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

    public void  setSesMVUTE( String param ) {
        this.sesMVUTE.setValue( param );
    }

    public void  setSesMVUTE( Object param ) {
        this.sesMVUTE.setValue( param );
    }

    public void  setSesMVUTE( Object param, Format ignore ) {
        this.sesMVUTE.setValue( param );
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

    public SERVIZI_DISPONIBILIRow[] getRows() {
        return rows;
    }

    public void setRows(SERVIZI_DISPONIBILIRow[] rows) {
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

//constructor @16-F38B66D9
    public SERVIZI_DISPONIBILIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @16-85BB4C45
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select m.descrizione||' - '||i.descrizione SERVIZIO, s.ISTANZA istanza,  "
                    + "m.MODULO modulo, 'Richiesta' RICHIESTA  "
                    + "from ad4_moduli m, ad4_servizi s,  "
                    + "ad4_istanze i   "
                    + "where s.modulo = m.modulo "
                    + "and i.istanza = s.istanza  "
                    + "and m.progetto = '{Progetto}'  "
                    + "and not exists (select 1 from ad4_diritti_accesso d where d.modulo = m.modulo "
                    + "and d.utente = nvl(AMV_UTENTE.GET_UTENTE_RICHIESTA({ID}),nvl('{MVUTE}','{Utente}')) "
                    + "and d.istanza = s.istanza "
                    + "and s.multiplo = 'N' "
                    + ") "
                    + "and not exists (select 1 from ad4_richieste_abilitazione r where r.modulo = m.modulo "
                    + "and r.utente = nvl(AMV_UTENTE.GET_UTENTE_RICHIESTA({ID}),nvl('{MVUTE}','{Utente}')) "
                    + "and r.istanza = s.istanza "
                    + "and r.stato in ('A','C') "
                    + "and s.multiplo = 'N' "
                    + ") "
                    + "and AMV_UTENTE.GET_SOGGETTO(nvl(AMV_UTENTE.GET_UTENTE_RICHIESTA({ID}),nvl('{MVUTE}','{Utente}'))) is not null" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "" );
        command.addParameter( "Progetto", sesProgetto, null );
        if ( StringUtils.isEmpty( (String) sesMVUTE.getObjectValue() ) ) sesMVUTE.setValue( "" );
        command.addParameter( "MVUTE", sesMVUTE, null );
        if ( urlID.getObjectValue() == null ) urlID.setValue( -1 );
        command.addParameter( "ID", urlID, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select m.descrizione||' - '||i.descrizione SERVIZIO, s.ISTANZA istanza,  "
+ "            m.MODULO modulo, 'Richiesta' RICHIESTA from ad4_moduli m, ad4_servizi s,  "
+ "            ad4_istanze i where s.modulo = m.modulo and i.istanza = s.istanza and m.progetto = '{Progetto}' and not exists (select 1 from ad4_diritti_accesso d where d.modulo = m.modulo and d.utente = nvl(AMV_UTENTE.GET_UTENTE_RICHIESTA({ID}),nvl('{MVUTE}','{Utente}')) and d.istanza = s.istanza and s.multiplo = 'N' ) and not exists (select 1 from ad4_richieste_abilitazione r where r.modulo = m.modulo and r.utente = nvl(AMV_UTENTE.GET_UTENTE_RICHIESTA({ID}),nvl('{MVUTE}','{Utente}')) and r.istanza = s.istanza and r.stato in ('A','C') and s.multiplo = 'N' ) and AMV_UTENTE.GET_SOGGETTO(nvl(AMV_UTENTE.GET_UTENTE_RICHIESTA({ID}),nvl('{MVUTE}','{Utente}'))) is not null ) cnt " );
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

//loadDataBind @16-54DBC8F7
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                SERVIZI_DISPONIBILIRow row = new SERVIZI_DISPONIBILIRow();
                DbRow record = (DbRow) records.nextElement();
                row.setSERVIZIO(Utils.convertToString(ds.parse(record.get("SERVIZIO"), row.getSERVIZIOField())));
                row.setRICHIESTA(Utils.convertToString(ds.parse(record.get("RICHIESTA"), row.getRICHIESTAField())));
                row.setISTANZA(Utils.convertToString(ds.parse(record.get("ISTANZA"), row.getISTANZAField())));
                row.setMODULO(Utils.convertToString(ds.parse(record.get("MODULO"), row.getMODULOField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @16-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @16-251A825B
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "Progetto".equals(name) && "ses".equals(prefix) ) {
                param = sesProgetto;
            } else if ( "Progetto".equals(name) && prefix == null ) {
                param = sesProgetto;
            }
            if ( "MVUTE".equals(name) && "ses".equals(prefix) ) {
                param = sesMVUTE;
            } else if ( "MVUTE".equals(name) && prefix == null ) {
                param = sesMVUTE;
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

//addGridDataObjectListener @16-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @16-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @16-238A81BB
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

//fireBeforeExecuteSelectEvent @16-9DA7B025
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

//fireAfterExecuteSelectEvent @16-F7E8A616
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

//class DataObject Tail @16-ED3F53A4
} // End of class DS
//End class DataObject Tail

