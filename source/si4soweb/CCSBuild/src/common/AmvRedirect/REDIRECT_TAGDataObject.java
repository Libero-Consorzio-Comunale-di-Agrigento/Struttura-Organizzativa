//REDIRECT_TAG DataSource @2-609774BC
package common.AmvRedirect;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End REDIRECT_TAG DataSource

//class DataObject Header @2-8B375DBF
public class REDIRECT_TAGDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @2-02E66196
    

    TextField postMVPAGETYPE = new TextField(null, null);
    
    TextField postMVPAGES = new TextField(null, null);
    
    LongField postMVPAGEINDEX = new LongField(null, null);
    
    TextField urlMVPAGETYPE = new TextField(null, null);
    
    TextField urlMVPAGES = new TextField(null, null);
    
    LongField urlMVPAGEINDEXURL = new LongField(null, null);
    
    TextField sesMVPP = new TextField(null, null);
    

    private REDIRECT_TAGRow[] rows = new REDIRECT_TAGRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @2-9784BC2B

    public void  setPostMVPAGETYPE( String param ) {
        this.postMVPAGETYPE.setValue( param );
    }

    public void  setPostMVPAGETYPE( Object param ) {
        this.postMVPAGETYPE.setValue( param );
    }

    public void  setPostMVPAGETYPE( Object param, Format ignore ) {
        this.postMVPAGETYPE.setValue( param );
    }

    public void  setPostMVPAGES( String param ) {
        this.postMVPAGES.setValue( param );
    }

    public void  setPostMVPAGES( Object param ) {
        this.postMVPAGES.setValue( param );
    }

    public void  setPostMVPAGES( Object param, Format ignore ) {
        this.postMVPAGES.setValue( param );
    }

    public void  setPostMVPAGEINDEX( long param ) {
        this.postMVPAGEINDEX.setValue( param );
    }

    public void  setPostMVPAGEINDEX( long param, Format ignore ) throws java.text.ParseException {
        this.postMVPAGEINDEX.setValue( param );
    }

    public void  setPostMVPAGEINDEX( Object param, Format format ) throws java.text.ParseException {
        this.postMVPAGEINDEX.setValue( param, format );
    }

    public void  setPostMVPAGEINDEX( Long param ) {
        this.postMVPAGEINDEX.setValue( param );
    }

    public void  setUrlMVPAGETYPE( String param ) {
        this.urlMVPAGETYPE.setValue( param );
    }

    public void  setUrlMVPAGETYPE( Object param ) {
        this.urlMVPAGETYPE.setValue( param );
    }

    public void  setUrlMVPAGETYPE( Object param, Format ignore ) {
        this.urlMVPAGETYPE.setValue( param );
    }

    public void  setUrlMVPAGES( String param ) {
        this.urlMVPAGES.setValue( param );
    }

    public void  setUrlMVPAGES( Object param ) {
        this.urlMVPAGES.setValue( param );
    }

    public void  setUrlMVPAGES( Object param, Format ignore ) {
        this.urlMVPAGES.setValue( param );
    }

    public void  setUrlMVPAGEINDEXURL( long param ) {
        this.urlMVPAGEINDEXURL.setValue( param );
    }

    public void  setUrlMVPAGEINDEXURL( long param, Format ignore ) throws java.text.ParseException {
        this.urlMVPAGEINDEXURL.setValue( param );
    }

    public void  setUrlMVPAGEINDEXURL( Object param, Format format ) throws java.text.ParseException {
        this.urlMVPAGEINDEXURL.setValue( param, format );
    }

    public void  setUrlMVPAGEINDEXURL( Long param ) {
        this.urlMVPAGEINDEXURL.setValue( param );
    }

    public void  setSesMVPP( String param ) {
        this.sesMVPP.setValue( param );
    }

    public void  setSesMVPP( Object param ) {
        this.sesMVPP.setValue( param );
    }

    public void  setSesMVPP( Object param, Format ignore ) {
        this.sesMVPP.setValue( param );
    }

    public REDIRECT_TAGRow[] getRows() {
        return rows;
    }

    public void setRows(REDIRECT_TAGRow[] rows) {
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

//constructor @2-511CE675
    public REDIRECT_TAGDataObject(Page page) {
        super(page);
    }
//End constructor

//load @2-0928E326
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select AMV_MENU.GET_PAGE(nvl('{MVPAGETYPE}','{MVPAGETYPEURL}'),nvl(nvl('{MVPAGES}','{MVPAGESURL}'),'{MVPP}'),nvl({MVPAGEINDEX},{MVPAGEINDEXURL})) redirect "
                    + "from dual" );
        if ( StringUtils.isEmpty( (String) postMVPAGETYPE.getObjectValue() ) ) postMVPAGETYPE.setValue( "P" );
        command.addParameter( "MVPAGETYPE", postMVPAGETYPE, null );
        if ( StringUtils.isEmpty( (String) postMVPAGES.getObjectValue() ) ) postMVPAGES.setValue( "" );
        command.addParameter( "MVPAGES", postMVPAGES, null );
        if ( postMVPAGEINDEX.getObjectValue() == null ) postMVPAGEINDEX.setValue( 0 );
        command.addParameter( "MVPAGEINDEX", postMVPAGEINDEX, null );
        if ( StringUtils.isEmpty( (String) urlMVPAGETYPE.getObjectValue() ) ) urlMVPAGETYPE.setValue( "P" );
        command.addParameter( "MVPAGETYPEURL", urlMVPAGETYPE, null );
        if ( StringUtils.isEmpty( (String) urlMVPAGES.getObjectValue() ) ) urlMVPAGES.setValue( "" );
        command.addParameter( "MVPAGESURL", urlMVPAGES, null );
        if ( urlMVPAGEINDEXURL.getObjectValue() == null ) urlMVPAGEINDEXURL.setValue( 0 );
        command.addParameter( "MVPAGEINDEXURL", urlMVPAGEINDEXURL, null );
        if ( StringUtils.isEmpty( (String) sesMVPP.getObjectValue() ) ) sesMVPP.setValue( "" );
        command.addParameter( "MVPP", sesMVPP, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select AMV_MENU.GET_PAGE(nvl('{MVPAGETYPE}','{MVPAGETYPEURL}'),nvl(nvl('{MVPAGES}','{MVPAGESURL}'),'{MVPP}'),nvl({MVPAGEINDEX},{MVPAGEINDEXURL})) redirect from dual ) cnt " );
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

//loadDataBind @2-FA5227F3
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                REDIRECT_TAGRow row = new REDIRECT_TAGRow();
                DbRow record = (DbRow) records.nextElement();
                row.setRedirection(Utils.convertToString(ds.parse(record.get("REDIRECT"), row.getRedirectionField())));
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

//getParameterByName @2-CB004C52
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "MVPAGETYPE".equals(name) && "post".equals(prefix) ) {
                param = postMVPAGETYPE;
            } else if ( "MVPAGETYPE".equals(name) && prefix == null ) {
                param = postMVPAGETYPE;
            }
            if ( "MVPAGES".equals(name) && "post".equals(prefix) ) {
                param = postMVPAGES;
            } else if ( "MVPAGES".equals(name) && prefix == null ) {
                param = postMVPAGES;
            }
            if ( "MVPAGEINDEX".equals(name) && "post".equals(prefix) ) {
                param = postMVPAGEINDEX;
            } else if ( "MVPAGEINDEX".equals(name) && prefix == null ) {
                param = postMVPAGEINDEX;
            }
            if ( "MVPAGETYPE".equals(name) && "url".equals(prefix) ) {
                param = urlMVPAGETYPE;
            } else if ( "MVPAGETYPE".equals(name) && prefix == null ) {
                param = urlMVPAGETYPE;
            }
            if ( "MVPAGES".equals(name) && "url".equals(prefix) ) {
                param = urlMVPAGES;
            } else if ( "MVPAGES".equals(name) && prefix == null ) {
                param = urlMVPAGES;
            }
            if ( "MVPAGEINDEXURL".equals(name) && "url".equals(prefix) ) {
                param = urlMVPAGEINDEXURL;
            } else if ( "MVPAGEINDEXURL".equals(name) && prefix == null ) {
                param = urlMVPAGEINDEXURL;
            }
            if ( "MVPP".equals(name) && "ses".equals(prefix) ) {
                param = sesMVPP;
            } else if ( "MVPP".equals(name) && prefix == null ) {
                param = sesMVPP;
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

