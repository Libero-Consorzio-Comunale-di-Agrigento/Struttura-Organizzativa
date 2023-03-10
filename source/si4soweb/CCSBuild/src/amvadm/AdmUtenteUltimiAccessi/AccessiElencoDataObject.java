//AccessiElenco DataSource @6-BA422FBF
package amvadm.AdmUtenteUltimiAccessi;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AccessiElenco DataSource

//class DataObject Header @6-2A771434
public class AccessiElencoDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @6-9F6F6BE0
    

    TextField sesMVUTE = new TextField(null, null);
    

    private AccessiElencoRow[] rows = new AccessiElencoRow[10];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @6-CD2144F0

    public void  setSesMVUTE( String param ) {
        this.sesMVUTE.setValue( param );
    }

    public void  setSesMVUTE( Object param ) {
        this.sesMVUTE.setValue( param );
    }

    public void  setSesMVUTE( Object param, Format ignore ) {
        this.sesMVUTE.setValue( param );
    }

    public AccessiElencoRow[] getRows() {
        return rows;
    }

    public void setRows(AccessiElencoRow[] rows) {
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

//constructor @6-0AF7C6F3
    public AccessiElencoDataObject(Page page) {
        super(page);
    }
//End constructor

//load @6-15736F6F
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select to_char(trunc(acce.DATA),'dd/mm/yyyy') DES_ACCESSO "
                    + ",  "
                    + "modu.DESCRIZIONE||' - '||ista.DESCRIZIONE DES_SERVIZIO "
                    + "from AD4_ACCESSI acce "
                    + "   ,  "
                    + "AD4_MODULI  modu "
                    + "   ,  "
                    + "AD4_ISTANZE ista "
                    + "where acce.utente = '{MVUTE}' "
                    + "  and modu.modulo = acce.modulo "
                    + "  and ista.istanza = acce.istanza "
                    + "group by trunc(acce.DATA),  "
                    + "modu.DESCRIZIONE,ista.DESCRIZIONE "
                    + "" );
        if ( StringUtils.isEmpty( (String) sesMVUTE.getObjectValue() ) ) sesMVUTE.setValue( "" );
        command.addParameter( "MVUTE", sesMVUTE, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select to_char(trunc(acce.DATA),'dd/mm/yyyy') DES_ACCESSO ,  "
                                                         + "            modu.DESCRIZIONE||' - '||ista.DESCRIZIONE DES_SERVIZIO from AD4_ACCESSI acce ,  "
                                                         + "            AD4_MODULI modu ,  "
                                                         + "            AD4_ISTANZE ista where acce.utente = '{MVUTE}' and modu.modulo = acce.modulo and ista.istanza = acce.istanza group by trunc(acce.DATA), modu.DESCRIZIONE,ista.DESCRIZIONE  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "trunc(acce.DATA) desc, modu.descrizione, ista.descrizione" );
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

//loadDataBind @6-756F95F8
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AccessiElencoRow row = new AccessiElencoRow();
                DbRow record = (DbRow) records.nextElement();
                row.setDES_ACCESSO(Utils.convertToString(ds.parse(record.get("DES_ACCESSO"), row.getDES_ACCESSOField())));
                row.setDES_SERVIZIO(Utils.convertToString(ds.parse(record.get("DES_SERVIZIO"), row.getDES_SERVIZIOField())));
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

//getParameterByName @6-004CC2DF
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "MVUTE".equals(name) && "ses".equals(prefix) ) {
                param = sesMVUTE;
            } else if ( "MVUTE".equals(name) && prefix == null ) {
                param = sesMVUTE;
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

