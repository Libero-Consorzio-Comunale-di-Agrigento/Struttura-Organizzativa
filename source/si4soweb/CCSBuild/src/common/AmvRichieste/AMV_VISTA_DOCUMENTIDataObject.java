//AMV_VISTA_DOCUMENTI DataSource @5-FA4DDEAE
package common.AmvRichieste;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AMV_VISTA_DOCUMENTI DataSource

//class DataObject Header @5-84F1CF2F
public class AMV_VISTA_DOCUMENTIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @5-82972277
    

    TextField urlS_TESTO = new TextField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    LongField urlIDRIC = new LongField(null, null);
    
    TextField urlREVRIC = new TextField(null, null);
    
    TextField urlMVTD = new TextField(null, null);
    
    TextField urlMVSZ = new TextField(null, null);
    

    private AMV_VISTA_DOCUMENTIRow[] rows = new AMV_VISTA_DOCUMENTIRow[100];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @5-6370CF07

    public void  setUrlS_TESTO( String param ) {
        this.urlS_TESTO.setValue( param );
    }

    public void  setUrlS_TESTO( Object param ) {
        this.urlS_TESTO.setValue( param );
    }

    public void  setUrlS_TESTO( Object param, Format ignore ) {
        this.urlS_TESTO.setValue( param );
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

    public void  setUrlIDRIC( long param ) {
        this.urlIDRIC.setValue( param );
    }

    public void  setUrlIDRIC( long param, Format ignore ) throws java.text.ParseException {
        this.urlIDRIC.setValue( param );
    }

    public void  setUrlIDRIC( Object param, Format format ) throws java.text.ParseException {
        this.urlIDRIC.setValue( param, format );
    }

    public void  setUrlIDRIC( Long param ) {
        this.urlIDRIC.setValue( param );
    }

    public void  setUrlREVRIC( String param ) {
        this.urlREVRIC.setValue( param );
    }

    public void  setUrlREVRIC( Object param ) {
        this.urlREVRIC.setValue( param );
    }

    public void  setUrlREVRIC( Object param, Format ignore ) {
        this.urlREVRIC.setValue( param );
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

    public void  setUrlMVSZ( String param ) {
        this.urlMVSZ.setValue( param );
    }

    public void  setUrlMVSZ( Object param ) {
        this.urlMVSZ.setValue( param );
    }

    public void  setUrlMVSZ( Object param, Format ignore ) {
        this.urlMVSZ.setValue( param );
    }

    public AMV_VISTA_DOCUMENTIRow[] getRows() {
        return rows;
    }

    public void setRows(AMV_VISTA_DOCUMENTIRow[] rows) {
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

//constructor @5-891C8440
    public AMV_VISTA_DOCUMENTIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @5-784848EC
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT DISTINCT  "
                    + "  ID_DOCUMENTO "
                    + ", TITOLO "
                    + ", NOME_AUTORE "
                    + ", DATA_INSERIMENTO "
                    + ",  "
                    + "STATO "
                    + ",  "
                    + "amv_revisione.get_img_stato(STATO) STATO_DOCUMENTO "
                    + ",'ServletModulistica.do?ID='||id_documento||'&IDPD='||id_documento_padre||'&REV='||revisione "
                    + " ||decode( stato||amv_revisione.get_diritto_modifica('{Utente}',id_documento, revisione) "
                    + "         , 'B1', '&rw=W' "
                    + "               , '&rw=R' "
                    + "         ) "
                    + " ||'&'||link||'&'||replace(amv_documento.get_modello(id_documento_padre,revisione),'/','&') href "
                    + ", amv_revisione.get_flusso('{Utente}', ID_DOCUMENTO, REVISIONE, stato, 'T','IDRIC={IDRIC}&REVRIC={REVRIC}&MVTD={MVTD}&MVSZ={MVSZ}') flusso "
                    + "FROM AMV_VISTA_DOCUMENTI "
                    + "WHERE ID_DOCUMENTO_PADRE= {IDRIC}  "
                    + "AND amv_revisione.get_diritto_modifica('{Utente}', ID_DOCUMENTO, REVISIONE) = 1 "
                    + "AND STATO in ('B','N','V') "
                    + "AND (NOME_AUTORE LIKE '%{s_TESTO}%'  "
                    + "OR to_char(data_inserimento,'dd/mm/yyyy hh24:mi') LIKE '%{s_TESTO}%' "
                    + "OR amv_revisione.get_des_stato(STATO) LIKE '%{s_TESTO}%' "
                    + ") "
                    + "AND '{Utente}' != 'GUEST' "
                    + "" );
        if ( StringUtils.isEmpty( (String) urlS_TESTO.getObjectValue() ) ) urlS_TESTO.setValue( "" );
        command.addParameter( "s_TESTO", urlS_TESTO, null );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( urlIDRIC.getObjectValue() == null ) urlIDRIC.setValue( null );
        command.addParameter( "IDRIC", urlIDRIC, null );
        if ( StringUtils.isEmpty( (String) urlREVRIC.getObjectValue() ) ) urlREVRIC.setValue( "" );
        command.addParameter( "REVRIC", urlREVRIC, null );
        if ( StringUtils.isEmpty( (String) urlMVTD.getObjectValue() ) ) urlMVTD.setValue( "" );
        command.addParameter( "MVTD", urlMVTD, null );
        if ( StringUtils.isEmpty( (String) urlMVSZ.getObjectValue() ) ) urlMVSZ.setValue( "" );
        command.addParameter( "MVSZ", urlMVSZ, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT DISTINCT ID_DOCUMENTO , TITOLO , NOME_AUTORE , DATA_INSERIMENTO , STATO ,  "
                                                         + "            amv_revisione.get_img_stato(STATO) STATO_DOCUMENTO ,'ServletModulistica.do?ID='||id_documento||'&IDPD='||id_documento_padre||'&REV='||revisione ||decode( stato||amv_revisione.get_diritto_modifica('{Utente}',id_documento, revisione) , 'B1', '&rw=W' , '&rw=R' ) ||'&'||link||'&'||replace(amv_documento.get_modello(id_documento_padre,revisione),'/','&') href , amv_revisione.get_flusso('{Utente}', ID_DOCUMENTO, REVISIONE, stato, 'T','IDRIC={IDRIC}&REVRIC={REVRIC}&MVTD={MVTD}&MVSZ={MVSZ}') flusso FROM AMV_VISTA_DOCUMENTI WHERE ID_DOCUMENTO_PADRE= {IDRIC} AND amv_revisione.get_diritto_modifica('{Utente}', ID_DOCUMENTO, REVISIONE) = 1 AND STATO in ('B','N','V') AND (NOME_AUTORE LIKE '%{s_TESTO}%' OR to_char(data_inserimento,'dd/mm/yyyy hh24:mi') LIKE '%{s_TESTO}%' OR amv_revisione.get_des_stato(STATO) LIKE '%{s_TESTO}%' ) AND '{Utente}' != 'GUEST'  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "DATA_INSERIMENTO" );
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

//loadDataBind @5-A0F4B433
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AMV_VISTA_DOCUMENTIRow row = new AMV_VISTA_DOCUMENTIRow();
                DbRow record = (DbRow) records.nextElement();
                row.setID_DOCUMENTO(Utils.convertToString(ds.parse(record.get("ID_DOCUMENTO"), row.getID_DOCUMENTOField())));
                try {
                    row.setDATA_INSERIMENTO(Utils.convertToDate(ds.parse(record.get("DATA_INSERIMENTO"), row.getDATA_INSERIMENTOField())));
                } catch ( java.text.ParseException pe ) {
                    model.addError( "Invalid data" );
                }
                row.setSTATO_DOCUMENTO(Utils.convertToString(ds.parse(record.get("STATO_DOCUMENTO"), row.getSTATO_DOCUMENTOField())));
                row.setFLUSSO(Utils.convertToString(ds.parse(record.get("FLUSSO"), row.getFLUSSOField())));
                row.setAUTORE(Utils.convertToString(ds.parse(record.get("NOME_AUTORE"), row.getAUTOREField())));
                row.setHREF(Utils.convertToString(ds.parse(record.get("HREF"), row.getHREFField())));
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

//getParameterByName @5-A45A1CEF
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "s_TESTO".equals(name) && "url".equals(prefix) ) {
                param = urlS_TESTO;
            } else if ( "s_TESTO".equals(name) && prefix == null ) {
                param = urlS_TESTO;
            }
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "IDRIC".equals(name) && "url".equals(prefix) ) {
                param = urlIDRIC;
            } else if ( "IDRIC".equals(name) && prefix == null ) {
                param = urlIDRIC;
            }
            if ( "REVRIC".equals(name) && "url".equals(prefix) ) {
                param = urlREVRIC;
            } else if ( "REVRIC".equals(name) && prefix == null ) {
                param = urlREVRIC;
            }
            if ( "MVTD".equals(name) && "url".equals(prefix) ) {
                param = urlMVTD;
            } else if ( "MVTD".equals(name) && prefix == null ) {
                param = urlMVTD;
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

