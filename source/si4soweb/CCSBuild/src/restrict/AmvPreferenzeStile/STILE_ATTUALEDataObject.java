//STILE_ATTUALE DataSource @7-E5DDCD43
package restrict.AmvPreferenzeStile;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End STILE_ATTUALE DataSource

//class DataObject Header @7-75AE11AE
public class STILE_ATTUALEDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @7-74FA561C
    

    TextField sesUtente = new TextField(null, null);
    TextField sesModulo = new TextField(null, null);
    TextField urlSTYLE = new TextField(null, null);

    private STILE_ATTUALERow[] rows = new STILE_ATTUALERow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @7-5E011704

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

    public void  setUrlSTYLE( String param ) {
        this.urlSTYLE.setValue( param );
    }

    public void  setUrlSTYLE( Object param ) {
        this.urlSTYLE.setValue( param );
    }

    public void  setUrlSTYLE( Object param, Format ignore ) {
        this.urlSTYLE.setValue( param );
    }

    public STILE_ATTUALERow[] getRows() {
        return rows;
    }

    public void setRows(STILE_ATTUALERow[] rows) {
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

//constructor @7-0A7D5A6A
    public STILE_ATTUALEDataObject(Page page) {
        super(page);
    }
//End constructor

//load @7-E4813684
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select nvl(AMVWEB.GET_PREFERENZA('Style', '{Modulo}',  "
                    + "'{Utente}'),'Style.css') stile_attuale "
                    + ", nvl('{STYLE}',nvl(AMVWEB.GET_PREFERENZA('Style', '{Modulo}',  "
                    + "'{Utente}'),'Style.css')) stile_scelto "
                    + ", 'STILE:Edit' ccsform,  "
                    + "'Aggiorna' buttonupdate, '3' MVID "
                    + "from dual" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( StringUtils.isEmpty( (String) sesModulo.getObjectValue() ) ) sesModulo.setValue( "" );
        command.addParameter( "Modulo", sesModulo, null );
        if ( StringUtils.isEmpty( (String) urlSTYLE.getObjectValue() ) ) urlSTYLE.setValue( "" );
        command.addParameter( "STYLE", urlSTYLE, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select nvl(AMVWEB.GET_PREFERENZA('Style', '{Modulo}',  "
                                                         + "            '{Utente}'),'Style.css') stile_attuale , nvl('{STYLE}',nvl(AMVWEB.GET_PREFERENZA('Style',  "
                                                         + "            '{Modulo}', '{Utente}'),'Style.css')) stile_scelto , 'STILE:Edit' ccsform,  "
                                                         + "            'Aggiorna' buttonupdate, '3' MVID from dual ) cnt " );
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

//loadDataBind @7-970ADBA9
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                STILE_ATTUALERow row = new STILE_ATTUALERow();
                DbRow record = (DbRow) records.nextElement();
                row.setSTILE_SCELTO(Utils.convertToString(ds.parse(record.get("STILE_SCELTO"), row.getSTILE_SCELTOField())));
                row.setSTILE(Utils.convertToString(ds.parse(record.get("STILE_ATTUALE"), row.getSTILEField())));
                row.setCcsForm(Utils.convertToString(ds.parse(record.get("CCSFORM"), row.getCcsFormField())));
                row.setCCSFORM(Utils.convertToString(ds.parse(record.get("CCSFORM"), row.getCCSFORMField())));
                row.setSTYLESHEET(Utils.convertToString(ds.parse(record.get("STILE_SCELTO"), row.getSTYLESHEETField())));
                row.setButton_Update(Utils.convertToString(ds.parse(record.get("BUTTONUPDATE"), row.getButton_UpdateField())));
                row.setBUTTONUPDATE(Utils.convertToString(ds.parse(record.get("BUTTONUPDATE"), row.getBUTTONUPDATEField())));
                row.setMVID(Utils.convertToString(ds.parse(record.get("MVID"), row.getMVIDField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @7-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @7-492FE71F
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
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
            if ( "STYLE".equals(name) && "url".equals(prefix) ) {
                param = urlSTYLE;
            } else if ( "STYLE".equals(name) && prefix == null ) {
                param = urlSTYLE;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @7-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @7-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @7-238A81BB
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

//fireBeforeExecuteSelectEvent @7-9DA7B025
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

//fireAfterExecuteSelectEvent @7-F7E8A616
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

//class DataObject Tail @7-ED3F53A4
} // End of class DS
//End class DataObject Tail

