//MESSAGGIO_RICHIESTA DataSource @7-2F1DFDE4
package common.AmvRegistrazioneFine;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End MESSAGGIO_RICHIESTA DataSource

//class DataObject Header @7-4CAF4BA9
public class MESSAGGIO_RICHIESTADataObject extends DS {
//End class DataObject Header

//attributes of DataObject @7-48A00B05
    

    LongField sesMVRIC = new LongField(null, null);
    

    private MESSAGGIO_RICHIESTARow[] rows = new MESSAGGIO_RICHIESTARow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @7-5CC1028D

    public void  setSesMVRIC( long param ) {
        this.sesMVRIC.setValue( param );
    }

    public void  setSesMVRIC( long param, Format ignore ) throws java.text.ParseException {
        this.sesMVRIC.setValue( param );
    }

    public void  setSesMVRIC( Object param, Format format ) throws java.text.ParseException {
        this.sesMVRIC.setValue( param, format );
    }

    public void  setSesMVRIC( Long param ) {
        this.sesMVRIC.setValue( param );
    }

    public MESSAGGIO_RICHIESTARow[] getRows() {
        return rows;
    }

    public void setRows(MESSAGGIO_RICHIESTARow[] rows) {
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

//constructor @7-5C5E2BB2
    public MESSAGGIO_RICHIESTADataObject(Page page) {
        super(page);
    }
//End constructor

//load @7-D38BEC0F
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT AMV_UTENTE.GET_MESSAGGIO_RICHIESTA({MVRIC}) msg FROM DUAL" );
        if ( sesMVRIC.getObjectValue() == null ) sesMVRIC.setValue( 0 );
        command.addParameter( "MVRIC", sesMVRIC, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT AMV_UTENTE.GET_MESSAGGIO_RICHIESTA({MVRIC}) msg FROM DUAL ) cnt " );
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

//loadDataBind @7-BAC326DA
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                MESSAGGIO_RICHIESTARow row = new MESSAGGIO_RICHIESTARow();
                DbRow record = (DbRow) records.nextElement();
                row.setMSG(Utils.convertToString(ds.parse(record.get("MSG"), row.getMSGField())));
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

//getParameterByName @7-6D0EF8D7
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "MVRIC".equals(name) && "ses".equals(prefix) ) {
                param = sesMVRIC;
            } else if ( "MVRIC".equals(name) && prefix == null ) {
                param = sesMVRIC;
            }
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

