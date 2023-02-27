//AccessiDettaglio DataSource @41-2CFBD18F
package amvadm.AdmAccessi;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AccessiDettaglio DataSource

//class DataObject Header @41-0F756870
public class AccessiDettaglioDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @41-B2EE5D1A
    

    TextField urlSM = new TextField(null, null);
    
    TextField urlDAL = new TextField(null, null);
    
    TextField urlAL = new TextField(null, null);
    
    TextField sesIstanza = new TextField(null, null);
    

    private AccessiDettaglioRow[] rows = new AccessiDettaglioRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @41-B5A7AB64

    public void  setUrlSM( String param ) {
        this.urlSM.setValue( param );
    }

    public void  setUrlSM( Object param ) {
        this.urlSM.setValue( param );
    }

    public void  setUrlSM( Object param, Format ignore ) {
        this.urlSM.setValue( param );
    }

    public void  setUrlDAL( String param ) {
        this.urlDAL.setValue( param );
    }

    public void  setUrlDAL( Object param ) {
        this.urlDAL.setValue( param );
    }

    public void  setUrlDAL( Object param, Format ignore ) {
        this.urlDAL.setValue( param );
    }

    public void  setUrlAL( String param ) {
        this.urlAL.setValue( param );
    }

    public void  setUrlAL( Object param ) {
        this.urlAL.setValue( param );
    }

    public void  setUrlAL( Object param, Format ignore ) {
        this.urlAL.setValue( param );
    }

    public void  setSesIstanza( String param ) {
        this.sesIstanza.setValue( param );
    }

    public void  setSesIstanza( Object param ) {
        this.sesIstanza.setValue( param );
    }

    public void  setSesIstanza( Object param, Format ignore ) {
        this.sesIstanza.setValue( param );
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

//constructor @41-8DB9C08E
    public AccessiDettaglioDataObject(Page page) {
        super(page);
    }
//End constructor

//load @41-392871A7
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select u.nominativo "
                    + ", u.utente "
                    + ", min(a.DATA) data_accesso "
                    + ",  "
                    + "decode(LOG "
                    + ",'WPW','Autenticazione fallita' "
                    + ",'ON','Login al servizio' "
                    + ",'OFF','Login al servizio (sessione chiusa da utente)' "
                    + ",'OUT','Logout dal servizio' "
                    + ",'ABT','Interruzione per errore applicazione' "
                    + ",'Accesso a risorsa web') "
                    + "||' ['||'Sessione '||a.SESSION_ID||']' sessione "
                    + "from AD4_ACCESSI a "
                    + "   , AD4_UTENTI u "
                    + "   , AD4_MODULI m "
                    + "where a.utente = u.utente "
                    + "  and a.data >= decode('{DAL}',null,a.data,to_date('{DAL}'||' 00:00:00','dd/mm/yyyy hh24:mi:ss')) "
                    + "  and a.data <= decode('{AL}',null,a.data,to_date('{AL}'||' 23:59:59','dd/mm/yyyy hh24:mi:ss')) "
                    + "  and a.istanza in ('{Istanza}','SI4AU') "
                    + "  and a.modulo = m.modulo "
                    + "  and a.modulo in('{SM}','SI4AU') "
                    + "  and (   a.modulo = '{SM}' "
                    + "      or  exists (select 1  "
                    + "                    from AD4_DIRITTI_ACCESSO "
                    + "	           where a.modulo = 'SI4AU' "
                    + "                     and utente = u.utente "
                    + "                     and istanza = '{Istanza}' "
                    + "                     and modulo = '{SM}' "
                    + "		 ) "
                    + "      ) "
                    + "group by u.utente, u.nominativo, a.SESSION_ID, a.log, trunc(a.data) "
                    + "" );
        if ( StringUtils.isEmpty( (String) urlSM.getObjectValue() ) ) urlSM.setValue( "" );
        command.addParameter( "SM", urlSM, null );
        if ( StringUtils.isEmpty( (String) urlDAL.getObjectValue() ) ) urlDAL.setValue( "" );
        command.addParameter( "DAL", urlDAL, null );
        if ( StringUtils.isEmpty( (String) urlAL.getObjectValue() ) ) urlAL.setValue( "" );
        command.addParameter( "AL", urlAL, null );
        if ( StringUtils.isEmpty( (String) sesIstanza.getObjectValue() ) ) sesIstanza.setValue( "" );
        command.addParameter( "Istanza", sesIstanza, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select u.nominativo , u.utente , min(a.DATA) data_accesso ,  "
                                                         + "            decode(LOG ,'WPW','Autenticazione fallita' ,'ON','Login al servizio' ,'OFF','Login al servizio (sessione chiusa da utente)' ,'OUT','Logout dal servizio' ,'ABT','Interruzione per errore applicazione' ,'Accesso a risorsa web') ||' ['||'Sessione '||a.SESSION_ID||']' sessione from AD4_ACCESSI a , AD4_UTENTI u , AD4_MODULI m where a.utente = u.utente and a.data >= decode('{DAL}',null,a.data,to_date('{DAL}'||' 00:00:00','dd/mm/yyyy hh24:mi:ss')) and a.data <= decode('{AL}',null,a.data,to_date('{AL}'||' 23:59:59','dd/mm/yyyy hh24:mi:ss')) and a.istanza in ('{Istanza}','SI4AU') and a.modulo = m.modulo and a.modulo in('{SM}','SI4AU') and ( a.modulo = '{SM}' or exists (select 1 from AD4_DIRITTI_ACCESSO 	 where a.modulo = 'SI4AU' and utente = u.utente and istanza = '{Istanza}' and modulo = '{SM}' 		 ) ) group by u.utente, u.nominativo, a.SESSION_ID, a.log, trunc(a.data)  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "data_accesso desc, u.nominativo, a.SESSION_ID" );
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

//loadDataBind @41-25ED523C
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AccessiDettaglioRow row = new AccessiDettaglioRow();
                DbRow record = (DbRow) records.nextElement();
                try {
                    row.setDATA_ACCESSO(Utils.convertToDate(ds.parse(record.get("DATA_ACCESSO"), row.getDATA_ACCESSOField())));
                } catch ( java.text.ParseException pe ) {
                    model.addError( "Invalid data" );
                }
                row.setNOMINATIVO(Utils.convertToString(ds.parse(record.get("NOMINATIVO"), row.getNOMINATIVOField())));
                row.setSESSIONE(Utils.convertToString(ds.parse(record.get("SESSIONE"), row.getSESSIONEField())));
                row.setIDUTE(Utils.convertToString(ds.parse(record.get("UTENTE"), row.getIDUTEField())));
                row.setUTENTE(Utils.convertToString(ds.parse(record.get("UTENTE"), row.getUTENTEField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @41-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @41-081E854A
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "SM".equals(name) && "url".equals(prefix) ) {
                param = urlSM;
            } else if ( "SM".equals(name) && prefix == null ) {
                param = urlSM;
            }
            if ( "DAL".equals(name) && "url".equals(prefix) ) {
                param = urlDAL;
            } else if ( "DAL".equals(name) && prefix == null ) {
                param = urlDAL;
            }
            if ( "AL".equals(name) && "url".equals(prefix) ) {
                param = urlAL;
            } else if ( "AL".equals(name) && prefix == null ) {
                param = urlAL;
            }
            if ( "Istanza".equals(name) && "ses".equals(prefix) ) {
                param = sesIstanza;
            } else if ( "Istanza".equals(name) && prefix == null ) {
                param = sesIstanza;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @41-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @41-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @41-238A81BB
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

//fireBeforeExecuteSelectEvent @41-9DA7B025
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

//fireAfterExecuteSelectEvent @41-F7E8A616
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

//class DataObject Tail @41-ED3F53A4
} // End of class DS
//End class DataObject Tail

