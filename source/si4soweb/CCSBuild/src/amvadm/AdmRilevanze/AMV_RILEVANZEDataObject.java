//AMV_RILEVANZE DataSource @5-78234865
package amvadm.AdmRilevanze;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AMV_RILEVANZE DataSource

//class DataObject Header @5-8AEC2869
public class AMV_RILEVANZEDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @5-D25265E2
    

    private AMV_RILEVANZERow[] rows = new AMV_RILEVANZERow[100];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @5-19A0D3A9

    public AMV_RILEVANZERow[] getRows() {
        return rows;
    }

    public void setRows(AMV_RILEVANZERow[] rows) {
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

//constructor @5-EBF5B5BB
    public AMV_RILEVANZEDataObject(Page page) {
        super(page);
    }
//End constructor

//load @5-120EFDFF
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT ID_RILEVANZA, NOME, decode(IMPORTANZA,'HL','Estesa','HP',  "
                    + "'Estesa','Elenco')IMPORTANZA "
                    + ", decode(zona,'A','Alta','S',  "
                    + "'Sinistra','D','Destra','C','Centro','') ZONA_DES "
                    + ", SEQUENZA  "
                    + "FROM AMV_RILEVANZE "
                    + "" );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT ID_RILEVANZA, NOME, decode(IMPORTANZA,'HL','Estesa','HP',  "
                                                         + "            'Estesa','Elenco')IMPORTANZA , decode(zona,'A','Alta','S',  "
                                                         + "            'Sinistra','D','Destra','C','Centro','') ZONA_DES , SEQUENZA FROM AMV_RILEVANZE  ) cnt " );
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

//loadDataBind @5-A00F9E6E
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AMV_RILEVANZERow row = new AMV_RILEVANZERow();
                DbRow record = (DbRow) records.nextElement();
                row.setNOME(Utils.convertToString(ds.parse(record.get("NOME"), row.getNOMEField())));
                row.setIMPORTANZA(Utils.convertToString(ds.parse(record.get("IMPORTANZA"), row.getIMPORTANZAField())));
                row.setZONA(Utils.convertToString(ds.parse(record.get("ZONA_DES"), row.getZONAField())));
                row.setSEQUENZA(Utils.convertToLong(ds.parse(record.get("SEQUENZA"), row.getSEQUENZAField())));
                row.setID(Utils.convertToString(ds.parse(record.get("ID_RILEVANZA"), row.getIDField())));
                row.setID_RILEVANZA(Utils.convertToString(ds.parse(record.get("ID_RILEVANZA"), row.getID_RILEVANZAField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @5-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @5-AE30C4C3
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @5-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @5-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @5-238A81BB
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

//fireBeforeExecuteSelectEvent @5-9DA7B025
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

//fireAfterExecuteSelectEvent @5-F7E8A616
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

//class DataObject Tail @5-ED3F53A4
} // End of class DS
//End class DataObject Tail

