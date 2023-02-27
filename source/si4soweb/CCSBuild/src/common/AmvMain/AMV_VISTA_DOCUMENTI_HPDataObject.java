//AMV_VISTA_DOCUMENTI_HP DataSource @10-F293EB25
package common.AmvMain;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AMV_VISTA_DOCUMENTI_HP DataSource

//class DataObject Header @10-F452B8F3
public class AMV_VISTA_DOCUMENTI_HPDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @10-9FF0E1CF
    

    TextField sesUtente = new TextField(null, null);
    

    private AMV_VISTA_DOCUMENTI_HPRow[] rows = new AMV_VISTA_DOCUMENTI_HPRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @10-5C875B33

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

    public AMV_VISTA_DOCUMENTI_HPRow[] getRows() {
        return rows;
    }

    public void setRows(AMV_VISTA_DOCUMENTI_HPRow[] rows) {
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

//constructor @10-AADAF98A
    public AMV_VISTA_DOCUMENTI_HPDataObject(Page page) {
        super(page);
    }
//End constructor

//load @10-D98254C0
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT AMV_DOCUMENTO.CREA_LINK_DOCUMENTO(ID_DOCUMENTO, LINK, TITOLO) TITOLO "
                    + ",  "
                    + "decode(TIPO_TESTO,'Testo',TESTO,'') testo_txt "
                    + ",  "
                    + "decode(TIPO_TESTO,'HTML',TESTO,'') testo_html "
                    + ", DATA_ULTIMA_MODIFICA "
                    + ",  "
                    + "id_documento ID   "
                    + "FROM AMV_VISTA_DOCUMENTI "
                    + "WHERE importanza ='HP' "
                    + "and UTENTE = '{Utente}' "
                    + "and STATO in ('U','R') "
                    + "and AMV_DOCUMENTO.DOCUMENTO_DATA_CHK(ID_DOCUMENTO)=1 "
                    + "and AMV_DOCUMENTO.GET_DIRITTO_DOC('{Utente}',id_documento) is not null "
                    + "" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "OLIVIERI" );
        command.addParameter( "Utente", sesUtente, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT AMV_DOCUMENTO.CREA_LINK_DOCUMENTO(ID_DOCUMENTO, LINK, TITOLO) TITOLO ,  "
                                                         + "            decode(TIPO_TESTO,'Testo',TESTO,'') testo_txt ,  "
                                                         + "            decode(TIPO_TESTO,'HTML',TESTO,'') testo_html , DATA_ULTIMA_MODIFICA ,  "
                                                         + "            id_documento ID FROM AMV_VISTA_DOCUMENTI WHERE importanza ='HP' and UTENTE = '{Utente}' and STATO in ('U','R') and AMV_DOCUMENTO.DOCUMENTO_DATA_CHK(ID_DOCUMENTO)=1 and AMV_DOCUMENTO.GET_DIRITTO_DOC('{Utente}',id_documento) is not null  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "sequenza, INIZIO_PUBBLICAZIONE desc, DATA_ULTIMA_MODIFICA desc" );
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

//loadDataBind @10-0422B9F9
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AMV_VISTA_DOCUMENTI_HPRow row = new AMV_VISTA_DOCUMENTI_HPRow();
                DbRow record = (DbRow) records.nextElement();
                row.setTITOLO(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getTITOLOField())));
                row.setTESTO(Utils.convertToString(ds.parse(record.get("TESTO_TXT"), row.getTESTOField())));
                row.setTESTO_HTML(Utils.convertToString(ds.parse(record.get("TESTO_HTML"), row.getTESTO_HTMLField())));
                try {
                    row.setDATA(Utils.convertToDate(ds.parse(record.get("DATA_ULTIMA_MODIFICA"), row.getDATAField())));
                } catch ( java.text.ParseException pe ) {
                    model.addError( "Invalid data" );
                }
                row.setID(Utils.convertToString(ds.parse(record.get("ID"), row.getIDField())));
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

//getParameterByName @10-041216E8
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
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

