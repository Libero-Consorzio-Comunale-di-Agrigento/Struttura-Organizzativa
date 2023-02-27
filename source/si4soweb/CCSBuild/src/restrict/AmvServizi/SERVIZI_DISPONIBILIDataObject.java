//SERVIZI_DISPONIBILI DataSource @17-E5108078
package restrict.AmvServizi;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End SERVIZI_DISPONIBILI DataSource

//class DataObject Header @17-82779F77
public class SERVIZI_DISPONIBILIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @17-21C21E03
    

    TextField sesUtente = new TextField(null, null);
    TextField sesProgetto = new TextField(null, null);

    private SERVIZI_DISPONIBILIRow[] rows = new SERVIZI_DISPONIBILIRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @17-598BEAF6

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

//constructor @17-F38B66D9
    public SERVIZI_DISPONIBILIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @17-78EF1E7B
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select m.descrizione SERVIZIO,  "
                    + "'<form name='||chr(34)||m.MODULO||'Form'||chr(34)||' action='||chr(34)||'../common/AmvRegistrazioneConferma.do'||chr(34)||' method='||chr(34)||'post'||chr(34)||'> "
                    + "<input type='||chr(34)||'hidden'||chr(34)||' name='||chr(34)||'ISTANZA'||chr(34)||' value='||chr(34)||s.ISTANZA||chr(34)||'> "
                    + "<input type='||chr(34)||'hidden'||chr(34)||' name='||chr(34)||'MODULO'||chr(34)||' value='||chr(34)||m.MODULO||chr(34)||'> "
                    + "<input class='||chr(34)||'AFCButton'||chr(34)||' type='||chr(34)||'submit'||chr(34)||' valign='||chr(34)||'center'||chr(34)||' value='||chr(34)||'Richiesta'||chr(34)||' name='||chr(34)||'Richiesta'||chr(34)||'></form>' RICHIESTA  "
                    + "from ad4_moduli m, ad4_servizi s   "
                    + "where s.modulo = m.modulo  "
                    + "and m.progetto = '{Progetto}'  "
                    + "and not exists (select 1 from ad4_diritti_accesso d where d.modulo = m.modulo "
                    + "and d.utente = '{Utente}' "
                    + "and d.istanza = s.istanza "
                    + ") "
                    + "and not exists (select 1 from ad4_richieste_abilitazione r where r.modulo = m.modulo "
                    + "and r.utente = '{Utente}' "
                    + "and r.istanza = s.istanza "
                    + "and r.stato in ('A','C') "
                    + ")" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "" );
        command.addParameter( "Progetto", sesProgetto, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select m.descrizione SERVIZIO,  "
                                                         + "            '<form name='||chr(34)||m.MODULO||'Form'||chr(34)||' action='||chr(34)||'../common/AmvRegistrazioneConferma.do'||chr(34)||' method='||chr(34)||'post'||chr(34)||'> <input type='||chr(34)||'hidden'||chr(34)||' name='||chr(34)||'ISTANZA'||chr(34)||' value='||chr(34)||s.ISTANZA||chr(34)||'> <input type='||chr(34)||'hidden'||chr(34)||' name='||chr(34)||'MODULO'||chr(34)||' value='||chr(34)||m.MODULO||chr(34)||'> <input class='||chr(34)||'AFCButton'||chr(34)||' type='||chr(34)||'submit'||chr(34)||' valign='||chr(34)||'center'||chr(34)||' value='||chr(34)||'Richiesta'||chr(34)||' name='||chr(34)||'Richiesta'||chr(34)||'></form>' RICHIESTA from ad4_moduli m, ad4_servizi s where s.modulo = m.modulo and m.progetto = '{Progetto}' and not exists (select 1 from ad4_diritti_accesso d where d.modulo = m.modulo and d.utente = '{Utente}' and d.istanza = s.istanza ) and not exists (select 1 from ad4_richieste_abilitazione r where r.modulo = m.modulo and r.utente = '{Utente}' and r.istanza = s.istanza and r.stato in ('A','C') ) ) cnt " );
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

//loadDataBind @17-6CA9F906
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                SERVIZI_DISPONIBILIRow row = new SERVIZI_DISPONIBILIRow();
                DbRow record = (DbRow) records.nextElement();
                row.setSERVIZIO(Utils.convertToString(ds.parse(record.get("SERVIZIO"), row.getSERVIZIOField())));
                row.setRICHIESTA(Utils.convertToString(ds.parse(record.get("RICHIESTA"), row.getRICHIESTAField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @17-F7C3107A
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        ds.closeConnection();
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @17-3D603852
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
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @17-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @17-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @17-238A81BB
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

//fireBeforeExecuteSelectEvent @17-9DA7B025
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

//fireAfterExecuteSelectEvent @17-F7E8A616
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

//class DataObject Tail @17-ED3F53A4
} // End of class DS
//End class DataObject Tail

