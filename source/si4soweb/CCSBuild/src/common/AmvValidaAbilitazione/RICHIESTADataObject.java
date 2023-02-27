//RICHIESTA DataSource @22-E8690D14
package common.AmvValidaAbilitazione;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End RICHIESTA DataSource

//class DataObject Header @22-F7F983A6
public class RICHIESTADataObject extends DS {
//End class DataObject Header

//attributes of DataObject @22-C0BE9DA8
    

    TextField sesMVRIC = new TextField(null, null);
    
    TextField sesMVPWD = new TextField(null, null);
    

    private RICHIESTARow[] rows = new RICHIESTARow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @22-73949C0C

    public void  setSesMVRIC( String param ) {
        this.sesMVRIC.setValue( param );
    }

    public void  setSesMVRIC( Object param ) {
        this.sesMVRIC.setValue( param );
    }

    public void  setSesMVRIC( Object param, Format ignore ) {
        this.sesMVRIC.setValue( param );
    }

    public void  setSesMVPWD( String param ) {
        this.sesMVPWD.setValue( param );
    }

    public void  setSesMVPWD( Object param ) {
        this.sesMVPWD.setValue( param );
    }

    public void  setSesMVPWD( Object param, Format ignore ) {
        this.sesMVPWD.setValue( param );
    }

    public RICHIESTARow[] getRows() {
        return rows;
    }

    public void setRows(RICHIESTARow[] rows) {
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

//constructor @22-F11FA6F8
    public RICHIESTADataObject(Page page) {
        super(page);
    }
//End constructor

//load @22-6FD937D7
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT decode('{MVPWD}',null,'<strong>'||AD4_SOGGETTO.GET_NOME(s.SOGGETTO,'Y')||'</strong>','Registrazione al servizio per l''utente <strong>'||u.NOMINATIVO||' </strong>.') NOMINATIVO "
                    + ",  "
                    + "m.DESCRIZIONE||' - '||i.DESCRIZIONE SERVIZIO "
                    + "FROM AD4_UTENTI u, AD4_UTENTI_SOGGETTI s, AD4_MODULI m, AD4_ISTANZE i,  "
                    + "AD4_RICHIESTE_ABILITAZIONE r "
                    + "WHERE u.UTENTE = r.utente "
                    + "AND s.utente = u.utente "
                    + "AND m.modulo = r.modulo "
                    + "AND i.istanza = r.istanza "
                    + "AND r.id_richiesta = {MVRIC}" );
        if ( StringUtils.isEmpty( (String) sesMVRIC.getObjectValue() ) ) sesMVRIC.setValue( "" );
        command.addParameter( "MVRIC", sesMVRIC, null );
        if ( StringUtils.isEmpty( (String) sesMVPWD.getObjectValue() ) ) sesMVPWD.setValue( "" );
        command.addParameter( "MVPWD", sesMVPWD, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT decode('{MVPWD}',null,'<strong>'||AD4_SOGGETTO.GET_NOME(s.SOGGETTO,'Y')||'</strong>','Registrazione al servizio per l''utente <strong>'||u.NOMINATIVO||' </strong>.') NOMINATIVO ,  "
                                                         + "            m.DESCRIZIONE||' - '||i.DESCRIZIONE SERVIZIO FROM AD4_UTENTI u, AD4_UTENTI_SOGGETTI s, AD4_MODULI m,  "
                                                         + "            AD4_ISTANZE i,  "
                                                         + "            AD4_RICHIESTE_ABILITAZIONE r WHERE u.UTENTE = r.utente AND s.utente = u.utente AND m.modulo = r.modulo AND i.istanza = r.istanza AND r.id_richiesta = {MVRIC} ) cnt " );
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

//loadDataBind @22-A282F0EF
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                RICHIESTARow row = new RICHIESTARow();
                DbRow record = (DbRow) records.nextElement();
                row.setNOMINATIVO(Utils.convertToString(ds.parse(record.get("NOMINATIVO"), row.getNOMINATIVOField())));
                row.setSERVIZIO(Utils.convertToString(ds.parse(record.get("SERVIZIO"), row.getSERVIZIOField())));
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

//getParameterByName @22-426AC47A
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "MVRIC".equals(name) && "ses".equals(prefix) ) {
                param = sesMVRIC;
            } else if ( "MVRIC".equals(name) && prefix == null ) {
                param = sesMVRIC;
            }
            if ( "MVPWD".equals(name) && "ses".equals(prefix) ) {
                param = sesMVPWD;
            } else if ( "MVPWD".equals(name) && prefix == null ) {
                param = sesMVPWD;
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

