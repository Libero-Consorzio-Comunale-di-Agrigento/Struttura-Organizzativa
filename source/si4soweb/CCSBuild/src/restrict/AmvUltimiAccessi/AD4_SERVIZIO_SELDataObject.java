//AD4_SERVIZIO_SEL DataSource @23-E380C8EC
package restrict.AmvUltimiAccessi;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_SERVIZIO_SEL DataSource

//class DataObject Header @23-2591D038
public class AD4_SERVIZIO_SELDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @23-FEA7DB7C
    

    TextField urlDES_ACCESSO = new TextField(null, null);
    
    TextField urlDES_SERVIZIO = new TextField(null, null);
    

    private AD4_SERVIZIO_SELRow[] rows = new AD4_SERVIZIO_SELRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @23-8CA4E30D

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

//constructor @23-2DE9DDD8
    public AD4_SERVIZIO_SELDataObject(Page page) {
        super(page);
    }
//End constructor

//load @23-63C2AF96
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT '{DES_ACCESSO}' DES_ACCESSO,  "
                    + "'{DES_SERVIZIO}' DES_SERVIZIO "
                    + "FROM dual "
                    + "WHERE '{DES_ACCESSO}' is not null" );
        if ( StringUtils.isEmpty( (String) urlDES_ACCESSO.getObjectValue() ) ) urlDES_ACCESSO.setValue( "" );
        command.addParameter( "DES_ACCESSO", urlDES_ACCESSO, null );
        if ( StringUtils.isEmpty( (String) urlDES_SERVIZIO.getObjectValue() ) ) urlDES_SERVIZIO.setValue( "" );
        command.addParameter( "DES_SERVIZIO", urlDES_SERVIZIO, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT '{DES_ACCESSO}' DES_ACCESSO,  "
                                                         + "            '{DES_SERVIZIO}' DES_SERVIZIO FROM dual WHERE '{DES_ACCESSO}' is not null ) cnt " );
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

//loadDataBind @23-4DB0AAD2
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AD4_SERVIZIO_SELRow row = new AD4_SERVIZIO_SELRow();
                DbRow record = (DbRow) records.nextElement();
                row.setDES_ACCESSO(Utils.convertToString(ds.parse(record.get("DES_ACCESSO"), row.getDES_ACCESSOField())));
                row.setDES_SERVIZIO(Utils.convertToString(ds.parse(record.get("DES_SERVIZIO"), row.getDES_SERVIZIOField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @23-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @23-8475CA0A
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
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
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @23-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @23-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @23-238A81BB
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

//fireBeforeExecuteSelectEvent @23-9DA7B025
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

//fireAfterExecuteSelectEvent @23-F7E8A616
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

//class DataObject Tail @23-ED3F53A4
} // End of class DS
//End class DataObject Tail

