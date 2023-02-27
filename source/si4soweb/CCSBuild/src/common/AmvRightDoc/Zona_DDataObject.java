//Zona_D DataSource @34-09BDFFAF
package common.AmvRightDoc;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End Zona_D DataSource

//class DataObject Header @34-D08AC488
public class Zona_DDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @34-2374C6EC
    

    TextField sesUtente = new TextField(null, null);
    
    LongField urlMVSZ = new LongField(null, null);
    

    private Zona_DRow[] rows = new Zona_DRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @34-D21E3CA3

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

    public Zona_DRow[] getRows() {
        return rows;
    }

    public void setRows(Zona_DRow[] rows) {
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

//constructor @34-6C638FAE
    public Zona_DDataObject(Page page) {
        super(page);
    }
//End constructor

//load @34-6EF39668
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select AMV_DOCUMENTO.GET_BLOCCO_TIPOLOGIA( '{Utente}', id_tipologia ,  "
                    + "{MVSZ}) blocco "
                    + "from amv_tipologie "
                    + "where zona  = 'D' "
                    + "" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( urlMVSZ.getObjectValue() == null ) urlMVSZ.setValue( 0 );
        command.addParameter( "MVSZ", urlMVSZ, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select AMV_DOCUMENTO.GET_BLOCCO_TIPOLOGIA( '{Utente}', id_tipologia ,  "
                                                         + "            {MVSZ}) blocco from amv_tipologie where zona = 'D'  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "sequenza " );
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

//loadDataBind @34-5F632245
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                Zona_DRow row = new Zona_DRow();
                DbRow record = (DbRow) records.nextElement();
                row.setZONA_D(Utils.convertToString(ds.parse(record.get("BLOCCO"), row.getZONA_DField())));
                row.setVIS_LINK(Utils.convertToString(ds.parse(record.get("VIS_LINK"), row.getVIS_LINKField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @34-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @34-0813D835
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

//addGridDataObjectListener @34-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @34-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @34-238A81BB
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

//fireBeforeExecuteSelectEvent @34-9DA7B025
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

//fireAfterExecuteSelectEvent @34-F7E8A616
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

//class DataObject Tail @34-ED3F53A4
} // End of class DS
//End class DataObject Tail

