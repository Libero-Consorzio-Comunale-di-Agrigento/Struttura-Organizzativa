//AMV_VOCI DataSource @41-0B1961D6
package amvadm.AdmGuide;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AMV_VOCI DataSource

//class DataObject Header @41-FCB23CE1
public class AMV_VOCIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @41-475B067F
    

    TextField sesId = new TextField(null, null);
    

    private AMV_VOCIRow[] rows = new AMV_VOCIRow[10];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @41-98882BF9

    public void  setSesId( String param ) {
        this.sesId.setValue( param );
    }

    public void  setSesId( Object param ) {
        this.sesId.setValue( param );
    }

    public void  setSesId( Object param, Format ignore ) {
        this.sesId.setValue( param );
    }

    public AMV_VOCIRow[] getRows() {
        return rows;
    }

    public void setRows(AMV_VOCIRow[] rows) {
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

//constructor @41-9EB60D19
    public AMV_VOCIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @41-60609415
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT TITOLO "
                    + " FROM AMV_VOCI WHERE VOCE ='{Id}'" );
        if ( StringUtils.isEmpty( (String) sesId.getObjectValue() ) ) sesId.setValue( "" );
        command.addParameter( "Id", sesId, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT TITOLO FROM AMV_VOCI WHERE VOCE ='{Id}' ) cnt " );
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

//loadDataBind @41-08B01B81
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AMV_VOCIRow row = new AMV_VOCIRow();
                DbRow record = (DbRow) records.nextElement();
                row.setTITOLO_VOCE(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getTITOLO_VOCEField())));
                row.setVIS_LINK(Utils.convertToString(ds.parse(record.get("VIS_LINK"), row.getVIS_LINKField())));
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

//getParameterByName @41-A6FF8F21
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Id".equals(name) && "ses".equals(prefix) ) {
                param = sesId;
            } else if ( "Id".equals(name) && prefix == null ) {
                param = sesId;
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

