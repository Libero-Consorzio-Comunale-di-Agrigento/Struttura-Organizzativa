//NAVIGATORE DataSource @2-7C2723D3
package common.AmvNavigatore;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End NAVIGATORE DataSource

//class DataObject Header @2-C23E6A20
public class NAVIGATOREDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @2-8850D6F4
    

    LongField urlMVSZ = new LongField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    TextField sesModulo = new TextField(null, null);
    
    TextField sesMVVC = new TextField(null, null);
    
    TextField sesMVL1 = new TextField(null, null);
    
    TextField sesMVL2 = new TextField(null, null);
    
    TextField sesMVL3 = new TextField(null, null);
    
    TextField urlMVTD = new TextField(null, null);
    
    TextField sesMVCONTEXT = new TextField(null, null);
    

    private NAVIGATORERow[] rows = new NAVIGATORERow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @2-3BC89B3B

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

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
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

    public void  setSesMVVC( String param ) {
        this.sesMVVC.setValue( param );
    }

    public void  setSesMVVC( Object param ) {
        this.sesMVVC.setValue( param );
    }

    public void  setSesMVVC( Object param, Format ignore ) {
        this.sesMVVC.setValue( param );
    }

    public void  setSesMVL1( String param ) {
        this.sesMVL1.setValue( param );
    }

    public void  setSesMVL1( Object param ) {
        this.sesMVL1.setValue( param );
    }

    public void  setSesMVL1( Object param, Format ignore ) {
        this.sesMVL1.setValue( param );
    }

    public void  setSesMVL2( String param ) {
        this.sesMVL2.setValue( param );
    }

    public void  setSesMVL2( Object param ) {
        this.sesMVL2.setValue( param );
    }

    public void  setSesMVL2( Object param, Format ignore ) {
        this.sesMVL2.setValue( param );
    }

    public void  setSesMVL3( String param ) {
        this.sesMVL3.setValue( param );
    }

    public void  setSesMVL3( Object param ) {
        this.sesMVL3.setValue( param );
    }

    public void  setSesMVL3( Object param, Format ignore ) {
        this.sesMVL3.setValue( param );
    }

    public void  setUrlMVTD( String param ) {
        this.urlMVTD.setValue( param );
    }

    public void  setUrlMVTD( Object param ) {
        this.urlMVTD.setValue( param );
    }

    public void  setUrlMVTD( Object param, Format ignore ) {
        this.urlMVTD.setValue( param );
    }

    public void  setSesMVCONTEXT( String param ) {
        this.sesMVCONTEXT.setValue( param );
    }

    public void  setSesMVCONTEXT( Object param ) {
        this.sesMVCONTEXT.setValue( param );
    }

    public void  setSesMVCONTEXT( Object param, Format ignore ) {
        this.sesMVCONTEXT.setValue( param );
    }

    public NAVIGATORERow[] getRows() {
        return rows;
    }

    public void setRows(NAVIGATORERow[] rows) {
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

//constructor @2-0DDCBB48
    public NAVIGATOREDataObject(Page page) {
        super(page);
    }
//End constructor

//load @2-0CD6644D
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select AMV_SEZIONE.GET_NAVIGATORE({MVSZ},'{Utente}','{Modulo}') NAVIGATORE_SEZIONI "
                    + ",  "
                    + "AMV_MENU.GET_NAVIGATORE('{MVVC}','{MVL1}','{MVL2}','{MVL3}','{MVTD}','{MVCONTEXT}') NAVIGATORE_MENU "
                    + " FROM AD4_MODULI "
                    + "WHERE MODULO = '{Modulo}'" );
        if ( urlMVSZ.getObjectValue() == null ) urlMVSZ.setValue( 0 );
        command.addParameter( "MVSZ", urlMVSZ, null );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( StringUtils.isEmpty( (String) sesModulo.getObjectValue() ) ) sesModulo.setValue( "" );
        command.addParameter( "Modulo", sesModulo, null );
        if ( StringUtils.isEmpty( (String) sesMVVC.getObjectValue() ) ) sesMVVC.setValue( "" );
        command.addParameter( "MVVC", sesMVVC, null );
        if ( StringUtils.isEmpty( (String) sesMVL1.getObjectValue() ) ) sesMVL1.setValue( "" );
        command.addParameter( "MVL1", sesMVL1, null );
        if ( StringUtils.isEmpty( (String) sesMVL2.getObjectValue() ) ) sesMVL2.setValue( "" );
        command.addParameter( "MVL2", sesMVL2, null );
        if ( StringUtils.isEmpty( (String) sesMVL3.getObjectValue() ) ) sesMVL3.setValue( "" );
        command.addParameter( "MVL3", sesMVL3, null );
        if ( StringUtils.isEmpty( (String) urlMVTD.getObjectValue() ) ) urlMVTD.setValue( "" );
        command.addParameter( "MVTD", urlMVTD, null );
        if ( StringUtils.isEmpty( (String) sesMVCONTEXT.getObjectValue() ) ) sesMVCONTEXT.setValue( "" );
        command.addParameter( "MVCONTEXT", sesMVCONTEXT, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select AMV_SEZIONE.GET_NAVIGATORE({MVSZ},'{Utente}','{Modulo}') NAVIGATORE_SEZIONI ,  "
                                                         + "            AMV_MENU.GET_NAVIGATORE('{MVVC}','{MVL1}','{MVL2}','{MVL3}','{MVTD}','{MVCONTEXT}') NAVIGATORE_MENU FROM AD4_MODULI WHERE MODULO = '{Modulo}' ) cnt " );
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

//loadDataBind @2-1B46EC0F
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                NAVIGATORERow row = new NAVIGATORERow();
                DbRow record = (DbRow) records.nextElement();
                row.setNAVIGATORE_SEZIONI(Utils.convertToString(ds.parse(record.get("NAVIGATORE_SEZIONI"), row.getNAVIGATORE_SEZIONIField())));
                row.setVIS_LINK(Utils.convertToString(ds.parse(record.get("VIS_LINK"), row.getVIS_LINKField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @2-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @2-600C7AED
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "MVSZ".equals(name) && "url".equals(prefix) ) {
                param = urlMVSZ;
            } else if ( "MVSZ".equals(name) && prefix == null ) {
                param = urlMVSZ;
            }
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "Modulo".equals(name) && "ses".equals(prefix) ) {
                param = sesModulo;
            } else if ( "Modulo".equals(name) && prefix == null ) {
                param = sesModulo;
            }
            if ( "MVVC".equals(name) && "ses".equals(prefix) ) {
                param = sesMVVC;
            } else if ( "MVVC".equals(name) && prefix == null ) {
                param = sesMVVC;
            }
            if ( "MVL1".equals(name) && "ses".equals(prefix) ) {
                param = sesMVL1;
            } else if ( "MVL1".equals(name) && prefix == null ) {
                param = sesMVL1;
            }
            if ( "MVL2".equals(name) && "ses".equals(prefix) ) {
                param = sesMVL2;
            } else if ( "MVL2".equals(name) && prefix == null ) {
                param = sesMVL2;
            }
            if ( "MVL3".equals(name) && "ses".equals(prefix) ) {
                param = sesMVL3;
            } else if ( "MVL3".equals(name) && prefix == null ) {
                param = sesMVL3;
            }
            if ( "MVTD".equals(name) && "url".equals(prefix) ) {
                param = urlMVTD;
            } else if ( "MVTD".equals(name) && prefix == null ) {
                param = urlMVTD;
            }
            if ( "MVCONTEXT".equals(name) && "ses".equals(prefix) ) {
                param = sesMVCONTEXT;
            } else if ( "MVCONTEXT".equals(name) && prefix == null ) {
                param = sesMVCONTEXT;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @2-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @2-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @2-238A81BB
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

//fireBeforeExecuteSelectEvent @2-9DA7B025
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

//fireAfterExecuteSelectEvent @2-F7E8A616
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

//class DataObject Tail @2-ED3F53A4
} // End of class DS
//End class DataObject Tail

