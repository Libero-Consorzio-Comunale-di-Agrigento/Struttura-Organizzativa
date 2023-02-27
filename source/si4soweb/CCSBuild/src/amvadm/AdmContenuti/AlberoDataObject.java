//Albero DataSource @6-8EA039AA
package amvadm.AdmContenuti;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End Albero DataSource

//class DataObject Header @6-E06D07DB
public class AlberoDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @6-57D128AC
    

    TextField sesUtente = new TextField(null, null);
    
    LongField urlSZ = new LongField(null, null);
    
    TextField sesMVPC = new TextField(null, null);
    

    private AlberoRow[] rows = new AlberoRow[300];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @6-B2F381B7

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

    public void  setUrlSZ( long param ) {
        this.urlSZ.setValue( param );
    }

    public void  setUrlSZ( long param, Format ignore ) throws java.text.ParseException {
        this.urlSZ.setValue( param );
    }

    public void  setUrlSZ( Object param, Format format ) throws java.text.ParseException {
        this.urlSZ.setValue( param, format );
    }

    public void  setUrlSZ( Long param ) {
        this.urlSZ.setValue( param );
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

    public AlberoRow[] getRows() {
        return rows;
    }

    public void setRows(AlberoRow[] rows) {
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

//constructor @6-834318E1
    public AlberoDataObject(Page page) {
        super(page);
    }
//End constructor

//load @6-36B2F272
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select amv_sezione.GET_ALBERO_SEZIONI({SZ},0,0,0,'','{Utente}','{MVPC}') TABELLA  "
                    + "FROM DUAL" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( urlSZ.getObjectValue() == null ) urlSZ.setValue( 0 );
        command.addParameter( "SZ", urlSZ, null );
        if ( StringUtils.isEmpty( (String) sesMVPC.getObjectValue() ) ) sesMVPC.setValue( "" );
        command.addParameter( "MVPC", sesMVPC, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select amv_sezione.GET_ALBERO_SEZIONI({SZ},0,0,0,'','{Utente}','{MVPC}') TABELLA FROM DUAL ) cnt " );
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

//loadDataBind @6-58860F34
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AlberoRow row = new AlberoRow();
                DbRow record = (DbRow) records.nextElement();
                row.setMENU(Utils.convertToString(ds.parse(record.get("TABELLA"), row.getMENUField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @6-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @6-733AA2ED
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "SZ".equals(name) && "url".equals(prefix) ) {
                param = urlSZ;
            } else if ( "SZ".equals(name) && prefix == null ) {
                param = urlSZ;
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

//addGridDataObjectListener @6-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @6-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @6-238A81BB
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

//fireBeforeExecuteSelectEvent @6-9DA7B025
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

//fireAfterExecuteSelectEvent @6-F7E8A616
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

//class DataObject Tail @6-ED3F53A4
} // End of class DS
//End class DataObject Tail

