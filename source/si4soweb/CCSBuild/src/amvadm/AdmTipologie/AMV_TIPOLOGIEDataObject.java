//AMV_TIPOLOGIE DataSource @7-1D4F3DE8
package amvadm.AdmTipologie;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AMV_TIPOLOGIE DataSource

//class DataObject Header @7-2B563A20
public class AMV_TIPOLOGIEDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @7-D1F59C63
    

    private AMV_TIPOLOGIERow[] rows = new AMV_TIPOLOGIERow[100];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @7-47142C6B

    public AMV_TIPOLOGIERow[] getRows() {
        return rows;
    }

    public void setRows(AMV_TIPOLOGIERow[] rows) {
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

//constructor @7-7E6B7A96
    public AMV_TIPOLOGIEDataObject(Page page) {
        super(page);
    }
//End constructor

//load @7-26C59425
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT AMV_TIPOLOGIE.*, decode(zona,'A','Alta','S',  "
                    + "'Sinistra','D','Destra','C','Centro','') zona_des "
                    + "FROM AMV_TIPOLOGIE "
                    + "" );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT AMV_TIPOLOGIE.*, decode(zona,'A','Alta','S',  "
                                                         + "            'Sinistra','D','Destra','C','Centro','') zona_des FROM AMV_TIPOLOGIE  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "NOME" );
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

//loadDataBind @7-0A3C197F
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AMV_TIPOLOGIERow row = new AMV_TIPOLOGIERow();
                DbRow record = (DbRow) records.nextElement();
                row.setNOME(Utils.convertToString(ds.parse(record.get("NOME"), row.getNOMEField())));
                row.setZONA(Utils.convertToString(ds.parse(record.get("ZONA_DES"), row.getZONAField())));
                row.setSEQUENZA(Utils.convertToLong(ds.parse(record.get("SEQUENZA"), row.getSEQUENZAField())));
                row.setIMMAGINE(Utils.convertToString(ds.parse(record.get("IMMAGINE"), row.getIMMAGINEField())));
                row.setLINK(Utils.convertToString(ds.parse(record.get("LINK"), row.getLINKField())));
                row.setID(Utils.convertToString(ds.parse(record.get("ID_TIPOLOGIA"), row.getIDField())));
                row.setID_TIPOLOGIA(Utils.convertToString(ds.parse(record.get("ID_TIPOLOGIA"), row.getID_TIPOLOGIAField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @7-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @7-AE30C4C3
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @7-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @7-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @7-238A81BB
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

//fireBeforeExecuteSelectEvent @7-9DA7B025
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

//fireAfterExecuteSelectEvent @7-F7E8A616
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

//class DataObject Tail @7-ED3F53A4
} // End of class DS
//End class DataObject Tail

