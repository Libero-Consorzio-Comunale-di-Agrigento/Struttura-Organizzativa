//AD4_DIRITTI_ACCESSO DataSource @22-F48EE529
package amvadm.AdmUtenteAccessi;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_DIRITTI_ACCESSO DataSource

//class DataObject Header @22-90563D55
public class AD4_DIRITTI_ACCESSODataObject extends DS {
//End class DataObject Header

//attributes of DataObject @22-26E6BADA
    

    TextField sesMVUTE = new TextField(null, null);
    
    TextField sesProgetto = new TextField(null, null);
    

    private AD4_DIRITTI_ACCESSORow[] rows = new AD4_DIRITTI_ACCESSORow[100];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @22-46D905D2

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

    public AD4_DIRITTI_ACCESSORow[] getRows() {
        return rows;
    }

    public void setRows(AD4_DIRITTI_ACCESSORow[] rows) {
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

//constructor @22-D9C7EB98
    public AD4_DIRITTI_ACCESSODataObject(Page page) {
        super(page);
    }
//End constructor

//load @22-B5CFAAFF
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select modu.descrizione||' - '||ista.descrizione des_servizio "
                    + ",  "
                    + "'Ultimo accesso il <b>'||nvl(to_char(diac.ultimo_accesso,'dd/mm/yyyy'),'?')||'</b> con ruolo \"'||ruol.descrizione||'\".' dsp_accesso "
                    + ", 'Registrati n.<b>'||nvl(diac.numero_accessi,'0')||'</b> accessi.' "
                    + "||decode(diac.gruppo,null,'',',<br>Accessi abilitati per appartenenza al gruppo \"'||diac.gruppo||'\".') "
                    + "||decode(diac.note,null,'','<br>('||diac.note||')') dsp_note   "
                    + "from AD4_DIRITTI_ACCESSO diac "
                    + "   , AD4_MODULI          modu "
                    + "   , AD4_ISTANZE         ista "
                    + "   , AD4_RUOLI           ruol "
                    + "where modu.modulo  = diac.modulo "
                    + "  and ista.istanza = diac.istanza "
                    + "  and ruol.ruolo   = diac.ruolo "
                    + "  and diac.utente = '{MVUTE}' "
                    + "  and modu.progetto = '{Progetto}' "
                    + "" );
        if ( StringUtils.isEmpty( (String) sesMVUTE.getObjectValue() ) ) sesMVUTE.setValue( "" );
        command.addParameter( "MVUTE", sesMVUTE, null );
        if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "" );
        command.addParameter( "Progetto", sesProgetto, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select modu.descrizione||' - '||ista.descrizione des_servizio ,  "
                                                         + "            'Ultimo accesso il <b>'||nvl(to_char(diac.ultimo_accesso,'dd/mm/yyyy'),'?')||'</b> con ruolo \"'||ruol.descrizione||'\".' dsp_accesso , 'Registrati n.<b>'||nvl(diac.numero_accessi,'0')||'</b> accessi.' ||decode(diac.gruppo,null,'',',<br>Accessi abilitati per appartenenza al gruppo \"'||diac.gruppo||'\".') ||decode(diac.note,null,'','<br>('||diac.note||')') dsp_note from AD4_DIRITTI_ACCESSO diac , AD4_MODULI modu , AD4_ISTANZE ista , AD4_RUOLI ruol where modu.modulo = diac.modulo and ista.istanza = diac.istanza and ruol.ruolo = diac.ruolo and diac.utente = '{MVUTE}' and modu.progetto = '{Progetto}'  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "diac.sequenza, modu.descrizione||' - '||ista.descrizione " );
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

//loadDataBind @22-46729E46
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AD4_DIRITTI_ACCESSORow row = new AD4_DIRITTI_ACCESSORow();
                DbRow record = (DbRow) records.nextElement();
                row.setDES_SERVIZIO(Utils.convertToString(ds.parse(record.get("DES_SERVIZIO"), row.getDES_SERVIZIOField())));
                row.setDSP_ACCESSO(Utils.convertToString(ds.parse(record.get("DSP_ACCESSO"), row.getDSP_ACCESSOField())));
                row.setDSP_NOTE(Utils.convertToString(ds.parse(record.get("DSP_NOTE"), row.getDSP_NOTEField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @22-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @22-3FDA4A15
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
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
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @22-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @22-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @22-238A81BB
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

//fireBeforeExecuteSelectEvent @22-9DA7B025
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

//fireAfterExecuteSelectEvent @22-F7E8A616
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

//class DataObject Tail @22-ED3F53A4
} // End of class DS
//End class DataObject Tail

