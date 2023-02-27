//SEZIONI_S DataSource @72-22541CFB
package common.AmvLeftSezione;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End SEZIONI_S DataSource

//class DataObject Header @72-A86FF175
public class SEZIONI_SDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @72-1E7332EC
    

    TextField sesUtente = new TextField(null, null);
    
    LongField urlMVSZ = new LongField(null, null);
    

    private SEZIONI_SRow[] rows = new SEZIONI_SRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @72-BF702B68

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

    public SEZIONI_SRow[] getRows() {
        return rows;
    }

    public void setRows(SEZIONI_SRow[] rows) {
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

//constructor @72-9B0A608D
    public SEZIONI_SDataObject(Page page) {
        super(page);
    }
//End constructor

//load @72-461BDE28
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select AMV_SEZIONE.GET_BLOCCO({MVSZ}) BLOCCO from dual " );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( urlMVSZ.getObjectValue() == null ) urlMVSZ.setValue( 0 );
        command.addParameter( "MVSZ", urlMVSZ, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select AMV_SEZIONE.GET_BLOCCO({MVSZ}) BLOCCO from dual  ) cnt " );
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

//loadDataBind @72-430D5475
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                SEZIONI_SRow row = new SEZIONI_SRow();
                DbRow record = (DbRow) records.nextElement();
                row.setBLOCCO(Utils.convertToString(ds.parse(record.get("BLOCCO"), row.getBLOCCOField())));
                row.setVIS_LINK(Utils.convertToString(ds.parse(record.get("VIS_LINK"), row.getVIS_LINKField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @72-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @72-0813D835
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
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @72-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @72-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @72-238A81BB
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

//fireBeforeExecuteSelectEvent @72-9DA7B025
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

//fireAfterExecuteSelectEvent @72-F7E8A616
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

//class DataObject Tail @72-ED3F53A4
} // End of class DS
//End class DataObject Tail

