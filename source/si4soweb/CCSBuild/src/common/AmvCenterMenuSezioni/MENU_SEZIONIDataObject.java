//MENU_SEZIONI DataSource @79-D1F6FF6A
package common.AmvCenterMenuSezioni;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End MENU_SEZIONI DataSource

//class DataObject Header @79-D5E11789
public class MENU_SEZIONIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @79-38FF02F3
    

    TextField sesUtente = new TextField(null, null);
    
    LongField urlMVSZ = new LongField(null, null);
    
    TextField sesMVPC = new TextField(null, null);
    

    private MENU_SEZIONIRow[] rows = new MENU_SEZIONIRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @79-8C14E360

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

    public void  setUrlMVSZ( long param ) {
        this.urlMVSZ.setValue( param );
    }

    public void  setUrlMVSZ( long param, Format ignore ) throws java.text.ParseException {
        this.urlMVSZ.setValue( param );
    }

    public void  setUrlMVSZ( Object param, Format format ) throws java.text.ParseException {
        this.urlMVSZ.setValue( param, format );
    }

    public void  setUrlMVSZ( Long param ) {
        this.urlMVSZ.setValue( param );
    }

    public void  setSesMVPC( String param ) {
        this.sesMVPC.setValue( param );
    }

    public void  setSesMVPC( Object param ) {
        this.sesMVPC.setValue( param );
    }

    public void  setSesMVPC( Object param, Format ignore ) {
        this.sesMVPC.setValue( param );
    }

    public MENU_SEZIONIRow[] getRows() {
        return rows;
    }

    public void setRows(MENU_SEZIONIRow[] rows) {
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

//constructor @79-1C9378D4
    public MENU_SEZIONIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @79-60CABA72
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select AMV_SEZIONE.GET_CORPO('{Utente}',{MVSZ},'{MVPC}',2) BLOCCO  "
                    + "from dual" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( urlMVSZ.getObjectValue() == null ) urlMVSZ.setValue( 0 );
        command.addParameter( "MVSZ", urlMVSZ, null );
        if ( StringUtils.isEmpty( (String) sesMVPC.getObjectValue() ) ) sesMVPC.setValue( "" );
        command.addParameter( "MVPC", sesMVPC, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select AMV_SEZIONE.GET_CORPO('{Utente}',{MVSZ},'{MVPC}',2) BLOCCO from dual ) cnt " );
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

//loadDataBind @79-3B4DB711
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                MENU_SEZIONIRow row = new MENU_SEZIONIRow();
                DbRow record = (DbRow) records.nextElement();
                row.setMENU_SEZ(Utils.convertToString(ds.parse(record.get("BLOCCO"), row.getMENU_SEZField())));
                row.setVIS_LINK(Utils.convertToString(ds.parse(record.get("VIS_LINK"), row.getVIS_LINKField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @79-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @79-120D8934
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "MVSZ".equals(name) && "url".equals(prefix) ) {
                param = urlMVSZ;
            } else if ( "MVSZ".equals(name) && prefix == null ) {
                param = urlMVSZ;
            }
            if ( "MVPC".equals(name) && "ses".equals(prefix) ) {
                param = sesMVPC;
            } else if ( "MVPC".equals(name) && prefix == null ) {
                param = sesMVPC;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @79-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @79-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @79-238A81BB
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

//fireBeforeExecuteSelectEvent @79-9DA7B025
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

//fireAfterExecuteSelectEvent @79-F7E8A616
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

//class DataObject Tail @79-ED3F53A4
} // End of class DS
//End class DataObject Tail

