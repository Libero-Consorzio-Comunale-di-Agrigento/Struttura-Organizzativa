//AD4_SERVIZIO_SEL DataSource @98-2786B8F7
package amvadm.AdmRichieste;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_SERVIZIO_SEL DataSource

//class DataObject Header @98-2591D038
public class AD4_SERVIZIO_SELDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @98-A1095F9D
    

    TextField urlMOD = new TextField(null, null);
    TextField urlIST = new TextField(null, null);

    private AD4_SERVIZIO_SELRow[] rows = new AD4_SERVIZIO_SELRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @98-A9AF9110

    public void  setUrlMOD( String param ) {
        this.urlMOD.setValue( param );
    }

    public void  setUrlMOD( Object param ) {
        this.urlMOD.setValue( param );
    }

    public void  setUrlMOD( Object param, Format ignore ) {
        this.urlMOD.setValue( param );
    }

    public void  setUrlIST( String param ) {
        this.urlIST.setValue( param );
    }

    public void  setUrlIST( Object param ) {
        this.urlIST.setValue( param );
    }

    public void  setUrlIST( Object param, Format ignore ) {
        this.urlIST.setValue( param );
    }

    public AD4_SERVIZIO_SELRow[] getRows() {
        return rows;
    }

    public void setRows(AD4_SERVIZIO_SELRow[] rows) {
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

//constructor @98-2DE9DDD8
    public AD4_SERVIZIO_SELDataObject(Page page) {
        super(page);
    }
//End constructor

//load @98-E47FE995
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT m.descrizione||' - '||i.descrizione servizio FROM ad4_servizi s,  "
                    + "ad4_moduli m,  "
                    + "ad4_istanze i "
                    + "WHERE m.modulo = s.modulo "
                    + "AND i.istanza = s.istanza "
                    + "AND s.modulo = '{MOD}'  "
                    + "AND s.istanza = '{IST}' " );
        if ( StringUtils.isEmpty( (String) urlMOD.getObjectValue() ) ) urlMOD.setValue( "" );
        command.addParameter( "MOD", urlMOD, null );
        if ( StringUtils.isEmpty( (String) urlIST.getObjectValue() ) ) urlIST.setValue( "" );
        command.addParameter( "IST", urlIST, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT m.descrizione||' - '||i.descrizione servizio FROM ad4_servizi s,  "
                                                         + "            ad4_moduli m,  "
                                                         + "            ad4_istanze i WHERE m.modulo = s.modulo AND i.istanza = s.istanza AND s.modulo = '{MOD}' AND s.istanza = '{IST}'  ) cnt " );
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

//loadDataBind @98-7C5DA6DD
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AD4_SERVIZIO_SELRow row = new AD4_SERVIZIO_SELRow();
                DbRow record = (DbRow) records.nextElement();
                row.setSERVIZIO(Utils.convertToString(ds.parse(record.get("SERVIZIO"), row.getSERVIZIOField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @98-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @98-013E8E61
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "MOD".equals(name) && "url".equals(prefix) ) {
                param = urlMOD;
            } else if ( "MOD".equals(name) && prefix == null ) {
                param = urlMOD;
            }
            if ( "IST".equals(name) && "url".equals(prefix) ) {
                param = urlIST;
            } else if ( "IST".equals(name) && prefix == null ) {
                param = urlIST;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @98-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @98-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @98-238A81BB
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

//fireBeforeExecuteSelectEvent @98-9DA7B025
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

//fireAfterExecuteSelectEvent @98-F7E8A616
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

//class DataObject Tail @98-ED3F53A4
} // End of class DS
//End class DataObject Tail

