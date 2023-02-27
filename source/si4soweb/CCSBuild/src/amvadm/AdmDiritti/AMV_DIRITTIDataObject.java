//AMV_DIRITTI DataSource @5-27D2FD44
package amvadm.AdmDiritti;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AMV_DIRITTI DataSource

//class DataObject Header @5-358C4BCD
public class AMV_DIRITTIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @5-25BF6C53
    

    TextField urlS_GRUPPO = new TextField(null, null);
    
    TextField urlS_AREA = new TextField(null, null);
    

    private AMV_DIRITTIRow[] rows = new AMV_DIRITTIRow[100];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @5-A0CDAE54

    public void  setUrlS_GRUPPO( String param ) {
        this.urlS_GRUPPO.setValue( param );
    }

    public void  setUrlS_GRUPPO( Object param ) {
        this.urlS_GRUPPO.setValue( param );
    }

    public void  setUrlS_GRUPPO( Object param, Format ignore ) {
        this.urlS_GRUPPO.setValue( param );
    }

    public void  setUrlS_AREA( String param ) {
        this.urlS_AREA.setValue( param );
    }

    public void  setUrlS_AREA( Object param ) {
        this.urlS_AREA.setValue( param );
    }

    public void  setUrlS_AREA( Object param, Format ignore ) {
        this.urlS_AREA.setValue( param );
    }

    public AMV_DIRITTIRow[] getRows() {
        return rows;
    }

    public void setRows(AMV_DIRITTIRow[] rows) {
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

//constructor @5-094BB49F
    public AMV_DIRITTIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @5-E34C1398
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT DISTINCT AMV_DIRITTI.ID_DIRITTO "
                    + ", 'Area : '||AMV_AREE.NOME HEADER_AREA "
                    + ",  "
                    + "nvl(AMV_TIPOLOGIE.NOME,' ') NOME_TIPOLOGIA "
                    + ", nvl(AD4_UTENTI.NOMINATIVO,  "
                    + "'(Tutti)') gruppo "
                    + ", decode(AMV_DIRITTI.ACCESSO,'R','Lettura','C','Redazione','U',  "
                    + "'Aggiornamento','V',  "
                    + "'Verifica','A','Approvazione') ACCESSO "
                    + ",'Modifica' EDIT "
                    + " FROM AMV_DIRITTI, AMV_AREE,  "
                    + "AD4_UTENTI,AMV_TIPOLOGIE "
                    + "WHERE nvl(AD4_UTENTI.TIPO_UTENTE,'G') ='G' "
                    + "AND nvl(AMV_DIRITTI.GRUPPO,' ') = nvl('{s_GRUPPO}',nvl(AMV_DIRITTI.GRUPPO,' ')) "
                    + "AND AMV_DIRITTI.ID_AREA = nvl('{s_AREA}',AMV_DIRITTI.ID_AREA) "
                    + "AND AMV_DIRITTI.GRUPPO = AD4_UTENTI.UTENTE (+) "
                    + "AND AMV_DIRITTI.ID_AREA = AMV_AREE.ID_AREA "
                    + "AND AMV_DIRITTI.ID_TIPOLOGIA= AMV_TIPOLOGIE.ID_TIPOLOGIA(+) " );
        if ( StringUtils.isEmpty( (String) urlS_GRUPPO.getObjectValue() ) ) urlS_GRUPPO.setValue( "" );
        command.addParameter( "s_GRUPPO", urlS_GRUPPO, null );
        if ( StringUtils.isEmpty( (String) urlS_AREA.getObjectValue() ) ) urlS_AREA.setValue( "" );
        command.addParameter( "s_AREA", urlS_AREA, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT DISTINCT AMV_DIRITTI.ID_DIRITTO , 'Area : '||AMV_AREE.NOME HEADER_AREA ,  "
                                                         + "            nvl(AMV_TIPOLOGIE.NOME,' ') NOME_TIPOLOGIA ,  "
                                                         + "            nvl(AD4_UTENTI.NOMINATIVO, '(Tutti)') gruppo ,  "
                                                         + "            decode(AMV_DIRITTI.ACCESSO,'R','Lettura','C','Redazione','U', 'Aggiornamento','V',  "
                                                         + "            'Verifica','A','Approvazione') ACCESSO ,'Modifica' EDIT FROM AMV_DIRITTI, AMV_AREE,  "
                                                         + "            AD4_UTENTI,AMV_TIPOLOGIE WHERE nvl(AD4_UTENTI.TIPO_UTENTE,'G') ='G' AND nvl(AMV_DIRITTI.GRUPPO,' ') = nvl('{s_GRUPPO}',nvl(AMV_DIRITTI.GRUPPO,' ')) AND AMV_DIRITTI.ID_AREA = nvl('{s_AREA}',AMV_DIRITTI.ID_AREA) AND AMV_DIRITTI.GRUPPO = AD4_UTENTI.UTENTE (+) AND AMV_DIRITTI.ID_AREA = AMV_AREE.ID_AREA AND AMV_DIRITTI.ID_TIPOLOGIA= AMV_TIPOLOGIE.ID_TIPOLOGIA(+)  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "2,3,4" );
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

//loadDataBind @5-7E57AEF2
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AMV_DIRITTIRow row = new AMV_DIRITTIRow();
                DbRow record = (DbRow) records.nextElement();
                row.setHEADER_AREA(Utils.convertToString(ds.parse(record.get("HEADER_AREA"), row.getHEADER_AREAField())));
                row.setGRUPPO(Utils.convertToString(ds.parse(record.get("GRUPPO"), row.getGRUPPOField())));
                row.setNOME_TIPOLOGIA(Utils.convertToString(ds.parse(record.get("NOME_TIPOLOGIA"), row.getNOME_TIPOLOGIAField())));
                row.setACCESSO(Utils.convertToString(ds.parse(record.get("ACCESSO"), row.getACCESSOField())));
                row.setEdit(Utils.convertToString(ds.parse(record.get("EDIT"), row.getEditField())));
                row.setID(Utils.convertToString(ds.parse(record.get("ID_DIRITTO"), row.getIDField())));
                row.setID_DIRITTO(Utils.convertToString(ds.parse(record.get("ID_DIRITTO"), row.getID_DIRITTOField())));
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

//getParameterByName @5-4AA9FAEE
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "s_GRUPPO".equals(name) && "url".equals(prefix) ) {
                param = urlS_GRUPPO;
            } else if ( "s_GRUPPO".equals(name) && prefix == null ) {
                param = urlS_GRUPPO;
            }
            if ( "s_AREA".equals(name) && "url".equals(prefix) ) {
                param = urlS_AREA;
            } else if ( "s_AREA".equals(name) && prefix == null ) {
                param = urlS_AREA;
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

