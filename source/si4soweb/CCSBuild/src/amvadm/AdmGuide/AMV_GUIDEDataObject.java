//AMV_GUIDE DataSource @5-0B1961D6
package amvadm.AdmGuide;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AMV_GUIDE DataSource

//class DataObject Header @5-9E2EB2E1
public class AMV_GUIDEDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @5-CB013657
    

    TextField urlID = new TextField(null, null);
    
    TextField sesId = new TextField(null, null);
    
    TextField sesMVCONTEXT = new TextField(null, null);
    

    private AMV_GUIDERow[] rows = new AMV_GUIDERow[100];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @5-C83B6962

    public void  setUrlID( String param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlID( Object param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlID( Object param, Format ignore ) {
        this.urlID.setValue( param );
    }

    public void  setSesId( String param ) {
        this.sesId.setValue( param );
    }

    public void  setSesId( Object param ) {
        this.sesId.setValue( param );
    }

    public void  setSesId( Object param, Format ignore ) {
        this.sesId.setValue( param );
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

    public AMV_GUIDERow[] getRows() {
        return rows;
    }

    public void setRows(AMV_GUIDERow[] rows) {
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

//constructor @5-0C39BBBD
    public AMV_GUIDEDataObject(Page page) {
        super(page);
    }
//End constructor

//load @5-A97DF68C
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT AMV_GUIDE.GUIDA "
                    + ", AMV_GUIDE.TITOLO "
                    + ", AMV_GUIDE.SEQUENZA "
                    + ",  "
                    + "v.TITOLO VOCE_RIF "
                    + ",  "
                    + "AMV_MENU.GET_LINK_STRINGA(v.stringa,v.modulo)||decode(upper(alias),'WEB','',decode(instr(AMV_MENU.GET_LINK_STRINGA(v.stringa,v.modulo),'?'),0,'?','&')||'MVAV='||alias) URL_RIF "
                    + ", 'Modifica' Modifica  "
                    + "FROM AMV_GUIDE, AMV_VOCI v "
                    + "WHERE AMV_GUIDE.GUIDA = nvl('{ID}','{Id}') "
                    + "AND v.VOCE = AMV_GUIDE.VOCE_MENU "
                    + "" );
        if ( StringUtils.isEmpty( (String) urlID.getObjectValue() ) ) urlID.setValue( "" );
        command.addParameter( "ID", urlID, null );
        if ( StringUtils.isEmpty( (String) sesId.getObjectValue() ) ) sesId.setValue( "" );
        command.addParameter( "Id", sesId, null );
        if ( StringUtils.isEmpty( (String) sesMVCONTEXT.getObjectValue() ) ) sesMVCONTEXT.setValue( "" );
        command.addParameter( "MVCONTEXT", sesMVCONTEXT, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT AMV_GUIDE.GUIDA , AMV_GUIDE.TITOLO , AMV_GUIDE.SEQUENZA ,  "
                                                         + "            v.TITOLO VOCE_RIF ,  "
                                                         + "            AMV_MENU.GET_LINK_STRINGA(v.stringa,v.modulo)||decode(upper(alias),'WEB','',decode(instr(AMV_MENU.GET_LINK_STRINGA(v.stringa,v.modulo),'?'),0,'?','&')||'MVAV='||alias) URL_RIF , 'Modifica' Modifica FROM AMV_GUIDE, AMV_VOCI v WHERE AMV_GUIDE.GUIDA = nvl('{ID}','{Id}') AND v.VOCE = AMV_GUIDE.VOCE_MENU  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "AMV_GUIDE.SEQUENZA" );
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

//loadDataBind @5-D90FD061
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AMV_GUIDERow row = new AMV_GUIDERow();
                DbRow record = (DbRow) records.nextElement();
                row.setTITOLO(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getTITOLOField())));
                row.setSEQUENZA(Utils.convertToString(ds.parse(record.get("SEQUENZA"), row.getSEQUENZAField())));
                row.setVOCE_RIF(Utils.convertToString(ds.parse(record.get("VOCE_RIF"), row.getVOCE_RIFField())));
                row.setURL_RIF(Utils.convertToString(ds.parse(record.get("URL_RIF"), row.getURL_RIFField())));
                row.setModifica(Utils.convertToString(ds.parse(record.get("MODIFICA"), row.getModificaField())));
                row.setGuida(Utils.convertToString(ds.parse(record.get("GUIDA"), row.getGuidaField())));
                row.setGUIDA(Utils.convertToString(ds.parse(record.get("GUIDA"), row.getGUIDAField())));
                row.setSeq(Utils.convertToString(ds.parse(record.get("SEQUENZA"), row.getSeqField())));
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

//getParameterByName @5-A154D685
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "ID".equals(name) && "url".equals(prefix) ) {
                param = urlID;
            } else if ( "ID".equals(name) && prefix == null ) {
                param = urlID;
            }
            if ( "Id".equals(name) && "ses".equals(prefix) ) {
                param = sesId;
            } else if ( "Id".equals(name) && prefix == null ) {
                param = sesId;
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

