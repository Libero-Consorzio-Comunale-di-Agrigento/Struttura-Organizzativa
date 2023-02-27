//TITLEGrid DataSource @31-454E111D
package amvadm.AdmPreferenzeImpostazione;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End TITLEGrid DataSource

//class DataObject Header @31-9EFF7082
public class TITLEGridDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @31-150FFA41
    

    LongField urlMVAV = new LongField(null, null);
    
    TextField sesModulo = new TextField(null, null);
    

    private TITLEGridRow[] rows = new TITLEGridRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @31-C9AE6C50

    public void  setUrlMVAV( long param ) {
        this.urlMVAV.setValue( param );
    }

    public void  setUrlMVAV( long param, Format ignore ) throws java.text.ParseException {
        this.urlMVAV.setValue( param );
    }

    public void  setUrlMVAV( Object param, Format format ) throws java.text.ParseException {
        this.urlMVAV.setValue( param, format );
    }

    public void  setUrlMVAV( Long param ) {
        this.urlMVAV.setValue( param );
    }

    public void  setSesModulo( String param ) {
        this.sesModulo.setValue( param );
    }

    public void  setSesModulo( Object param ) {
        this.sesModulo.setValue( param );
    }

    public void  setSesModulo( Object param, Format ignore ) {
        this.sesModulo.setValue( param );
    }

    public TITLEGridRow[] getRows() {
        return rows;
    }

    public void setRows(TITLEGridRow[] rows) {
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

//constructor @31-4627693B
    public TITLEGridDataObject(Page page) {
        super(page);
    }
//End constructor

//load @31-E5FCEE48
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT  "
                    + "decode({MVAV},1, 'Modulo '||descrizione, 'Portale') titolo "
                    + ",  "
                    + "decode({MVAV},1, 'Modulo ', 'Portale') livello "
                    + "FROM ad4_moduli where modulo = '{Modulo}'" );
        if ( urlMVAV.getObjectValue() == null ) urlMVAV.setValue( 0 );
        command.addParameter( "MVAV", urlMVAV, null );
        if ( StringUtils.isEmpty( (String) sesModulo.getObjectValue() ) ) sesModulo.setValue( "" );
        command.addParameter( "Modulo", sesModulo, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT decode({MVAV},1, 'Modulo '||descrizione, 'Portale') titolo ,  "
+ "            decode({MVAV},1, 'Modulo ',  "
+ "            'Portale') livello FROM ad4_moduli where modulo = '{Modulo}' ) cnt " );
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

//loadDataBind @31-67E145A0
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                TITLEGridRow row = new TITLEGridRow();
                DbRow record = (DbRow) records.nextElement();
                row.setTITOLO(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getTITOLOField())));
                row.setLIVELLO(Utils.convertToString(ds.parse(record.get("LIVELLO"), row.getLIVELLOField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @31-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @31-6089C2D3
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "MVAV".equals(name) && "url".equals(prefix) ) {
                param = urlMVAV;
            } else if ( "MVAV".equals(name) && prefix == null ) {
                param = urlMVAV;
            }
            if ( "Modulo".equals(name) && "ses".equals(prefix) ) {
                param = sesModulo;
            } else if ( "Modulo".equals(name) && prefix == null ) {
                param = sesModulo;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @31-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @31-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @31-238A81BB
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

//fireBeforeExecuteSelectEvent @31-9DA7B025
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

//fireAfterExecuteSelectEvent @31-F7E8A616
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

//class DataObject Tail @31-ED3F53A4
} // End of class DS
//End class DataObject Tail

