//PREFERENZE DataSource @6-454E111D
package amvadm.AdmPreferenzeImpostazione;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End PREFERENZE DataSource

//class DataObject Header @6-8D3EAE1D
public class PREFERENZEDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @6-DFFFC96B
    

    TextField sesModulo = new TextField(null, null);
    
    TextField urlMVAV = new TextField(null, null);
    

    private PREFERENZERow[] rows = new PREFERENZERow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @6-0C0BE69B

    public void  setSesModulo( String param ) {
        this.sesModulo.setValue( param );
    }

    public void  setSesModulo( Object param ) {
        this.sesModulo.setValue( param );
    }

    public void  setSesModulo( Object param, Format ignore ) {
        this.sesModulo.setValue( param );
    }

    public void  setUrlMVAV( String param ) {
        this.urlMVAV.setValue( param );
    }

    public void  setUrlMVAV( Object param ) {
        this.urlMVAV.setValue( param );
    }

    public void  setUrlMVAV( Object param, Format ignore ) {
        this.urlMVAV.setValue( param );
    }

    public PREFERENZERow[] getRows() {
        return rows;
    }

    public void setRows(PREFERENZERow[] rows) {
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

//constructor @6-891EBCA4
    public PREFERENZEDataObject(Page page) {
        super(page);
    }
//End constructor

//load @6-6483DE00
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT stringa "
                    + ",  "
                    + "AMVWEB.GET_PREFERENZA(stringa,0,decode(nvl('{MVAV}',0),0,'','{Modulo}')) VALORE "
                    + ", max(commento) commento "
                    + ",  "
                    + "decode(AMVWEB.IS_PREFERENZA(stringa,decode(nvl('{MVAV}',0),0,'','{Modulo}')),1,'*','') IMPOSTATA "
                    + "from REGISTRO  "
                    + "where stringa >= '0' "
                    + "and (chiave = 'PRODUCTS/AMV' or chiave = 'PRODUCTS/'||'{Modulo}')  "
                    + "group by stringa "
                    + "" );
        if ( StringUtils.isEmpty( (String) sesModulo.getObjectValue() ) ) sesModulo.setValue( "" );
        command.addParameter( "Modulo", sesModulo, null );
        if ( StringUtils.isEmpty( (String) urlMVAV.getObjectValue() ) ) urlMVAV.setValue( "" );
        command.addParameter( "MVAV", urlMVAV, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT stringa ,  "
                                                         + "            AMVWEB.GET_PREFERENZA(stringa,0,decode(nvl('{MVAV}',0),0,'','{Modulo}')) VALORE , max(commento) commento ,  "
                                                         + "            decode(AMVWEB.IS_PREFERENZA(stringa,decode(nvl('{MVAV}',0),0,'','{Modulo}')),1,'*','') IMPOSTATA from REGISTRO where stringa >= '0' and (chiave = 'PRODUCTS/AMV' or chiave = 'PRODUCTS/'||'{Modulo}') group by stringa  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "stringa" );
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

//loadDataBind @6-2237ACDD
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                PREFERENZERow row = new PREFERENZERow();
                DbRow record = (DbRow) records.nextElement();
                row.setSTRINGA(Utils.convertToString(ds.parse(record.get("STRINGA"), row.getSTRINGAField())));
                row.setIMPOSTATA(Utils.convertToString(ds.parse(record.get("IMPOSTATA"), row.getIMPOSTATAField())));
                row.setVALORE(Utils.convertToString(ds.parse(record.get("VALORE"), row.getVALOREField())));
                row.setCOMMENTO(Utils.convertToString(ds.parse(record.get("COMMENTO"), row.getCOMMENTOField())));
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

//getParameterByName @6-47680A55
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Modulo".equals(name) && "ses".equals(prefix) ) {
                param = sesModulo;
            } else if ( "Modulo".equals(name) && prefix == null ) {
                param = sesModulo;
            }
            if ( "MVAV".equals(name) && "url".equals(prefix) ) {
                param = urlMVAV;
            } else if ( "MVAV".equals(name) && prefix == null ) {
                param = urlMVAV;
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

