//AD4_PARAMETRI_RICHIESTAGrid DataSource @40-0C95D343
package amvadm.AdmRichiesta;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_PARAMETRI_RICHIESTAGrid DataSource

//class DataObject Header @40-9729A7B4
public class AD4_PARAMETRI_RICHIESTAGridDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @40-85871EBB
    

    TextField urlID = new TextField(null, null);
    

    private AD4_PARAMETRI_RICHIESTAGridRow[] rows = new AD4_PARAMETRI_RICHIESTAGridRow[100];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @40-72CC7970

    public void  setUrlID( String param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlID( Object param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlID( Object param, Format ignore ) {
        this.urlID.setValue( param );
    }

    public AD4_PARAMETRI_RICHIESTAGridRow[] getRows() {
        return rows;
    }

    public void setRows(AD4_PARAMETRI_RICHIESTAGridRow[] rows) {
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

//constructor @40-CF022527
    public AD4_PARAMETRI_RICHIESTAGridDataObject(Page page) {
        super(page);
    }
//End constructor

//load @40-6F846429
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT PARAMETRO,  "
                    + "VALORE FROM AD4_PARAMETRI_RICHIESTA "
                    + "WHERE ID_RICHIESTA = '{ID}' "
                    + "" );
        if ( StringUtils.isEmpty( (String) urlID.getObjectValue() ) ) urlID.setValue( "" );
        command.addParameter( "ID", urlID, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT PARAMETRO,  "
                                                         + "            VALORE FROM AD4_PARAMETRI_RICHIESTA WHERE ID_RICHIESTA = '{ID}'  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "ID_PARAMETRO" );
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

//loadDataBind @40-0F4ADD74
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AD4_PARAMETRI_RICHIESTAGridRow row = new AD4_PARAMETRI_RICHIESTAGridRow();
                DbRow record = (DbRow) records.nextElement();
                row.setPARAMETRO(Utils.convertToString(ds.parse(record.get("PARAMETRO"), row.getPARAMETROField())));
                row.setVALORE(Utils.convertToString(ds.parse(record.get("VALORE"), row.getVALOREField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @40-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @40-1BE048C3
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
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

//addGridDataObjectListener @40-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @40-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @40-238A81BB
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

//fireBeforeExecuteSelectEvent @40-9DA7B025
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

//fireAfterExecuteSelectEvent @40-F7E8A616
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

//class DataObject Tail @40-ED3F53A4
} // End of class DS
//End class DataObject Tail

