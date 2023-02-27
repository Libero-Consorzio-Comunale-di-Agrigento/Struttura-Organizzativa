//AD4_SEZIONE_SEL DataSource @10-E33A715F
package amvadm.AdmContenutiElenco;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_SEZIONE_SEL DataSource

//class DataObject Header @10-D45627AF
public class AD4_SEZIONE_SELDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @10-C98AB66F
    

    LongField urlSZ = new LongField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    

    private AD4_SEZIONE_SELRow[] rows = new AD4_SEZIONE_SELRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @10-A5CD8AD7

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

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

    public AD4_SEZIONE_SELRow[] getRows() {
        return rows;
    }

    public void setRows(AD4_SEZIONE_SELRow[] rows) {
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

//constructor @10-047D20B2
    public AD4_SEZIONE_SELDataObject(Page page) {
        super(page);
    }
//End constructor

//load @10-5E3C8C41
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT nome "
                    + "        ,  "
                    + "'<a class=\"AFCDataLink\" alt=\"Ricerca contenuti\" href=\"../common/AmvDocumentiRicerca.do?MVPD=0\"><i>Ricerca...&nbsp;</i></a>' ricerca "
                    + ",  "
                    + "decode(amv_utente.get_diritto_documenti('{Utente}') "
                    + "        , null, '' "
                    + "        ,  "
                    + "'R' , '' "
                    + "        ,  "
                    + "'<a class=\"AFCDataLink\" alt=\"Crea nuovo documento\" href=\"../amvadm/AdmDocumento.do?MVSZ='||{SZ}||'\"><i>Nuovo&nbsp;documento...&nbsp;</i></a>') nuova_pagina  "
                    + "FROM amv_sezioni "
                    + "WHERE id_sezione = {SZ}" );
        if ( urlSZ.getObjectValue() == null ) urlSZ.setValue( 0 );
        command.addParameter( "SZ", urlSZ, null );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT nome ,  "
                                                         + "            '<a class=\"AFCDataLink\" alt=\"Ricerca contenuti\" href=\"../common/AmvDocumentiRicerca.do?MVPD=0\"><i>Ricerca...&nbsp;</i></a>' ricerca , decode(amv_utente.get_diritto_documenti('{Utente}') , null, '' , 'R' , '' , '<a class=\"AFCDataLink\" alt=\"Crea nuovo documento\" href=\"../amvadm/AdmDocumento.do?MVSZ='||{SZ}||'\"><i>Nuovo&nbsp;documento...&nbsp;</i></a>') nuova_pagina FROM amv_sezioni WHERE id_sezione = {SZ} ) cnt " );
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

//loadDataBind @10-9F241927
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AD4_SEZIONE_SELRow row = new AD4_SEZIONE_SELRow();
                DbRow record = (DbRow) records.nextElement();
                row.setNOME_SEZIONE(Utils.convertToString(ds.parse(record.get("NOME"), row.getNOME_SEZIONEField())));
                row.setRICERCA(Utils.convertToString(ds.parse(record.get("RICERCA"), row.getRICERCAField())));
                row.setNUOVA_PAGINA(Utils.convertToString(ds.parse(record.get("NUOVA_PAGINA"), row.getNUOVA_PAGINAField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @10-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @10-BD354621
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "SZ".equals(name) && "url".equals(prefix) ) {
                param = urlSZ;
            } else if ( "SZ".equals(name) && prefix == null ) {
                param = urlSZ;
            }
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @10-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @10-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @10-238A81BB
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

//fireBeforeExecuteSelectEvent @10-9DA7B025
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

//fireAfterExecuteSelectEvent @10-F7E8A616
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

//class DataObject Tail @10-ED3F53A4
} // End of class DS
//End class DataObject Tail

