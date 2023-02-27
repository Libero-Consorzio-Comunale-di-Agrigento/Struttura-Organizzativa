//AccessiDettaglio DataSource @14-E380C8EC
package restrict.AmvUltimiAccessi;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AccessiDettaglio DataSource

//class DataObject Header @14-0F756870
public class AccessiDettaglioDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @14-D7FC5162
    

    TextField sesUtente = new TextField(null, null);
    
    TextField urlDES_ACCESSO = new TextField(null, null);
    
    TextField urlDES_SERVIZIO = new TextField(null, null);
    
    TextField sesProgetto = new TextField(null, null);
    

    private AccessiDettaglioRow[] rows = new AccessiDettaglioRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @14-B865F424

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

    public void  setUrlDES_ACCESSO( String param ) {
        this.urlDES_ACCESSO.setValue( param );
    }

    public void  setUrlDES_ACCESSO( Object param ) {
        this.urlDES_ACCESSO.setValue( param );
    }

    public void  setUrlDES_ACCESSO( Object param, Format ignore ) {
        this.urlDES_ACCESSO.setValue( param );
    }

    public void  setUrlDES_SERVIZIO( String param ) {
        this.urlDES_SERVIZIO.setValue( param );
    }

    public void  setUrlDES_SERVIZIO( Object param ) {
        this.urlDES_SERVIZIO.setValue( param );
    }

    public void  setUrlDES_SERVIZIO( Object param, Format ignore ) {
        this.urlDES_SERVIZIO.setValue( param );
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

    public AccessiDettaglioRow[] getRows() {
        return rows;
    }

    public void setRows(AccessiDettaglioRow[] rows) {
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

//constructor @14-8DB9C08E
    public AccessiDettaglioDataObject(Page page) {
        super(page);
    }
//End constructor

//load @14-8A20220A
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select 'n.'||acce.ACCE_ID DES_ACCESSO "
                    + ", to_char(acce.DATA,'HH24:mi.ss') DES_ORA "
                    + ",  "
                    + "decode(LOG "
                    + ",'WPW','Autenticazione fallita' "
                    + ",'ON','Login al servizio' "
                    + ",'OFF','Login al servizio' "
                    + ",'OUT','Logout dal servizio' "
                    + ",'ABT','Interruzione per errore applicazione' "
                    + ",'Accesso a risorsa web') "
                    + "||' ['||'Sessione '||acce.SESSION_ID||']' "
                    + "||decode(acce.NOTE,null,'',' ('||amv_menu.get_titolo_pagina('{Progetto}',acce.NOTE)||')') DSP_SESSIONE   "
                    + "from AD4_ACCESSI acce "
                    + "   , AD4_MODULI  modu "
                    + "   , AD4_ISTANZE ista "
                    + "where acce.utente = '{Utente}' "
                    + "  and acce.data >= to_date('{DES_ACCESSO}','dd/mm/yyyy') "
                    + "  and trunc(acce.data) = to_date('{DES_ACCESSO}','dd/mm/yyyy') "
                    + "  and modu.DESCRIZIONE||' - '||ista.DESCRIZIONE = '{DES_SERVIZIO}' "
                    + "  and modu.modulo = acce.modulo "
                    + "  and modu.progetto = '{Progetto}' "
                    + "  and ista.istanza = acce.istanza "
                    + "" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( StringUtils.isEmpty( (String) urlDES_ACCESSO.getObjectValue() ) ) urlDES_ACCESSO.setValue( "" );
        command.addParameter( "DES_ACCESSO", urlDES_ACCESSO, null );
        if ( StringUtils.isEmpty( (String) urlDES_SERVIZIO.getObjectValue() ) ) urlDES_SERVIZIO.setValue( "" );
        command.addParameter( "DES_SERVIZIO", urlDES_SERVIZIO, null );
        if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "" );
        command.addParameter( "Progetto", sesProgetto, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select 'n.'||acce.ACCE_ID DES_ACCESSO , to_char(acce.DATA,'HH24:mi.ss') DES_ORA ,  "
                                                         + "            decode(LOG ,'WPW','Autenticazione fallita' ,'ON','Login al servizio' ,'OFF','Login al servizio' ,'OUT','Logout dal servizio' ,'ABT','Interruzione per errore applicazione' ,'Accesso a risorsa web') ||' ['||'Sessione '||acce.SESSION_ID||']' ||decode(acce.NOTE,null,'',' ('||amv_menu.get_titolo_pagina('{Progetto}',acce.NOTE)||')') DSP_SESSIONE from AD4_ACCESSI acce , AD4_MODULI modu , AD4_ISTANZE ista where acce.utente = '{Utente}' and acce.data >= to_date('{DES_ACCESSO}','dd/mm/yyyy') and trunc(acce.data) = to_date('{DES_ACCESSO}','dd/mm/yyyy') and modu.DESCRIZIONE||' - '||ista.DESCRIZIONE = '{DES_SERVIZIO}' and modu.modulo = acce.modulo and modu.progetto = '{Progetto}' and ista.istanza = acce.istanza  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "acce_id desc" );
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

//loadDataBind @14-8D767985
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AccessiDettaglioRow row = new AccessiDettaglioRow();
                DbRow record = (DbRow) records.nextElement();
                row.setDES_ACCESSO(Utils.convertToString(ds.parse(record.get("DES_ACCESSO"), row.getDES_ACCESSOField())));
                row.setDES_ORA(Utils.convertToString(ds.parse(record.get("DES_ORA"), row.getDES_ORAField())));
                row.setDSP_SESSIONE(Utils.convertToString(ds.parse(record.get("DSP_SESSIONE"), row.getDSP_SESSIONEField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @14-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @14-32989D87
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "DES_ACCESSO".equals(name) && "url".equals(prefix) ) {
                param = urlDES_ACCESSO;
            } else if ( "DES_ACCESSO".equals(name) && prefix == null ) {
                param = urlDES_ACCESSO;
            }
            if ( "DES_SERVIZIO".equals(name) && "url".equals(prefix) ) {
                param = urlDES_SERVIZIO;
            } else if ( "DES_SERVIZIO".equals(name) && prefix == null ) {
                param = urlDES_SERVIZIO;
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

//addGridDataObjectListener @14-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @14-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @14-238A81BB
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

//fireBeforeExecuteSelectEvent @14-9DA7B025
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

//fireAfterExecuteSelectEvent @14-F7E8A616
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

//class DataObject Tail @14-ED3F53A4
} // End of class DS
//End class DataObject Tail

