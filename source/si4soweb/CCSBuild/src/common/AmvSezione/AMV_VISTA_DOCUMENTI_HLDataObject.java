//AMV_VISTA_DOCUMENTI_HL DataSource @20-32018EB8
package common.AmvSezione;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AMV_VISTA_DOCUMENTI_HL DataSource

//class DataObject Header @20-88BDA7D2
public class AMV_VISTA_DOCUMENTI_HLDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @20-F4DD7B09
    

    TextField sesUtente = new TextField(null, null);
    
    LongField urlMVSZ = new LongField(null, null);
    

    private AMV_VISTA_DOCUMENTI_HLRow[] rows = new AMV_VISTA_DOCUMENTI_HLRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @20-FF305241

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

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

    public AMV_VISTA_DOCUMENTI_HLRow[] getRows() {
        return rows;
    }

    public void setRows(AMV_VISTA_DOCUMENTI_HLRow[] rows) {
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

//constructor @20-A7FF4F66
    public AMV_VISTA_DOCUMENTI_HLDataObject(Page page) {
        super(page);
    }
//End constructor

//load @20-4957EAA6
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
                    + "WHERE importanza ='SL' "
                    + "and UTENTE = '{Utente}' "
                    + "and STATO in ('U','R') "
                    + "and ID_SEZIONE = {MVSZ} "
                    + "and AMV_DOCUMENTO.GET_DIRITTO_DOC('{Utente}',id_documento) is not null "
                    + "" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( urlMVSZ.getObjectValue() == null ) urlMVSZ.setValue( -1 );
        command.addParameter( "MVSZ", urlMVSZ, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT AMV_DOCUMENTO.CREA_LINK_DOCUMENTO(ID_DOCUMENTO, LINK, TITOLO) TITOLO ,  "
                                                         + "            decode(TIPO_TESTO,'Testo',TESTO,'') testo_txt ,  "
                                                         + "            decode(TIPO_TESTO,'HTML',TESTO,'') testo_html , DATA_ULTIMA_MODIFICA ,  "
                                                         + "            id_documento ID FROM AMV_VISTA_DOCUMENTI WHERE importanza ='SL' and UTENTE = '{Utente}' and STATO in ('U','R') and ID_SEZIONE = {MVSZ} and AMV_DOCUMENTO.GET_DIRITTO_DOC('{Utente}',id_documento) is not null  ) cnt " );
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

//loadDataBind @20-E1888BD2
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AMV_VISTA_DOCUMENTI_HLRow row = new AMV_VISTA_DOCUMENTI_HLRow();
                DbRow record = (DbRow) records.nextElement();
                row.setTITOLO(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getTITOLOField())));
                try {
                    row.setDATA(Utils.convertToDate(ds.parse(record.get("DATA_ULTIMA_MODIFICA"), row.getDATAField())));
                } catch ( java.text.ParseException pe ) {
                    model.addError( "Invalid data" );
                }
                row.setTESTO(Utils.convertToString(ds.parse(record.get("TESTO_TXT"), row.getTESTOField())));
                row.setTESTO_HTML(Utils.convertToString(ds.parse(record.get("TESTO_HTML"), row.getTESTO_HTMLField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @20-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @20-0813D835
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "MVSZ".equals(name) && "url".equals(prefix) ) {
                param = urlMVSZ;
            } else if ( "MVSZ".equals(name) && prefix == null ) {
                param = urlMVSZ;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @20-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @20-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @20-238A81BB
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

//fireBeforeExecuteSelectEvent @20-9DA7B025
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

//fireAfterExecuteSelectEvent @20-F7E8A616
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

//class DataObject Tail @20-ED3F53A4
} // End of class DS
//End class DataObject Tail

