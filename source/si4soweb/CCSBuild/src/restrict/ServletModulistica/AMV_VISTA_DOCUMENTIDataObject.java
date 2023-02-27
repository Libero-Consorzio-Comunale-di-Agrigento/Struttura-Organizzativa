//AMV_VISTA_DOCUMENTI DataSource @9-4B91B36E
package restrict.ServletModulistica;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AMV_VISTA_DOCUMENTI DataSource

//class DataObject Header @9-84F1CF2F
public class AMV_VISTA_DOCUMENTIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @9-33CFDF41
    

    LongField urlIDPD = new LongField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    LongField urlREV = new LongField(null, null);
    
    LongField sesMVIDPDRIC = new LongField(null, null);
    
    LongField urlID = new LongField(null, null);
    
    LongField sesMVIDRIC = new LongField(null, null);
    
    LongField sesMVREVRIC = new LongField(null, null);
    
    TextField urlCr = new TextField(null, null);
    
    TextField postCr = new TextField(null, null);
    

    private AMV_VISTA_DOCUMENTIRow[] rows = new AMV_VISTA_DOCUMENTIRow[100];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @9-6CE82DFC

    public void  setUrlIDPD( long param ) {
        this.urlIDPD.setValue( param );
    }

    public void  setUrlIDPD( long param, Format ignore ) throws java.text.ParseException {
        this.urlIDPD.setValue( param );
    }

    public void  setUrlIDPD( Object param, Format format ) throws java.text.ParseException {
        this.urlIDPD.setValue( param, format );
    }

    public void  setUrlIDPD( Long param ) {
        this.urlIDPD.setValue( param );
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

    public void  setUrlREV( long param ) {
        this.urlREV.setValue( param );
    }

    public void  setUrlREV( long param, Format ignore ) throws java.text.ParseException {
        this.urlREV.setValue( param );
    }

    public void  setUrlREV( Object param, Format format ) throws java.text.ParseException {
        this.urlREV.setValue( param, format );
    }

    public void  setUrlREV( Long param ) {
        this.urlREV.setValue( param );
    }

    public void  setSesMVIDPDRIC( long param ) {
        this.sesMVIDPDRIC.setValue( param );
    }

    public void  setSesMVIDPDRIC( long param, Format ignore ) throws java.text.ParseException {
        this.sesMVIDPDRIC.setValue( param );
    }

    public void  setSesMVIDPDRIC( Object param, Format format ) throws java.text.ParseException {
        this.sesMVIDPDRIC.setValue( param, format );
    }

    public void  setSesMVIDPDRIC( Long param ) {
        this.sesMVIDPDRIC.setValue( param );
    }

    public void  setUrlID( long param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlID( long param, Format ignore ) throws java.text.ParseException {
        this.urlID.setValue( param );
    }

    public void  setUrlID( Object param, Format format ) throws java.text.ParseException {
        this.urlID.setValue( param, format );
    }

    public void  setUrlID( Long param ) {
        this.urlID.setValue( param );
    }

    public void  setSesMVIDRIC( long param ) {
        this.sesMVIDRIC.setValue( param );
    }

    public void  setSesMVIDRIC( long param, Format ignore ) throws java.text.ParseException {
        this.sesMVIDRIC.setValue( param );
    }

    public void  setSesMVIDRIC( Object param, Format format ) throws java.text.ParseException {
        this.sesMVIDRIC.setValue( param, format );
    }

    public void  setSesMVIDRIC( Long param ) {
        this.sesMVIDRIC.setValue( param );
    }

    public void  setSesMVREVRIC( long param ) {
        this.sesMVREVRIC.setValue( param );
    }

    public void  setSesMVREVRIC( long param, Format ignore ) throws java.text.ParseException {
        this.sesMVREVRIC.setValue( param );
    }

    public void  setSesMVREVRIC( Object param, Format format ) throws java.text.ParseException {
        this.sesMVREVRIC.setValue( param, format );
    }

    public void  setSesMVREVRIC( Long param ) {
        this.sesMVREVRIC.setValue( param );
    }

    public void  setUrlCr( String param ) {
        this.urlCr.setValue( param );
    }

    public void  setUrlCr( Object param ) {
        this.urlCr.setValue( param );
    }

    public void  setUrlCr( Object param, Format ignore ) {
        this.urlCr.setValue( param );
    }

    public void  setPostCr( String param ) {
        this.postCr.setValue( param );
    }

    public void  setPostCr( Object param ) {
        this.postCr.setValue( param );
    }

    public void  setPostCr( Object param, Format ignore ) {
        this.postCr.setValue( param );
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

//constructor @9-891C8440
    public AMV_VISTA_DOCUMENTIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @9-D22B812A
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT TITOLO "
                    + ",  "
                    + "amv_revisione.get_des_stato(amv_revisione.get_stato(nvl({ID},{MVIDRIC}),nvl({REV},{MVREVRIC}))) STATO "
                    + ",  "
                    + "amv_revisione.get_stato({MVIDRIC},{MVREVRIC}) COD_STATO "
                    + ", decode(TIPO_TESTO,'Testo',TESTO,'Form',TESTO,'') testo "
                    + ",  "
                    + "DATA_AGGIORNAMENTO "
                    + ",  "
                    + "REVISIONE "
                    + ",0 "
                    + ",'' "
                    + ",decode( stato||amv_revisione.get_diritto_modifica('{Utente}',id_documento, revisione) "
                    + "        , 'B1',  "
                    + "'<a alt=\"Modifica\" title=\"Modifica\" href=\"../common/ServletModulistica.do?ID='||nvl({ID},{MVIDRIC})||'&IDPD='||id_documento||'&REV='||revisione||'&rw=W&'||link||'&'||replace(amv_documento.get_modello(id_documento_padre, revisione),'/','&')||'\"><img src=\"../common/images/AMV/edit.gif\" border=\"0\"></a>' "
                    + "             , '' "
                    + "       ) MOD_SRC "
                    + ", amv_documento.get_allegati(id_documento, revisione) ALLEGATI "
                    + ", nvl('{CRURL}','{CRFORM}') CODICE_RICHIESTA "
                    + ", 'MVIDRIC='||{MVIDRIC}||' MVIDPDRIC='||{MVIDPDRIC}||' REV='||{MVREVRIC} VARIABILI "
                    + "from amv_documenti "
                    + "where stato <> 'F' "
                    + "  and amv_revisione.get_diritto('{Utente}',id_documento, revisione) is not null "
                    + "  and id_documento = NVL({IDPD},{MVIDPDRIC}) "
                    + "  and (   revisione = {REV} "
                    + "       or nvl({REV},-1)     = -1 and STATO in ('U','R') "
                    + "      )" );
        if ( urlIDPD.getObjectValue() == null ) urlIDPD.setValue( null );
        command.addParameter( "IDPD", urlIDPD, null );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( urlREV.getObjectValue() == null ) urlREV.setValue( null );
        command.addParameter( "REV", urlREV, null );
        if ( sesMVIDPDRIC.getObjectValue() == null ) sesMVIDPDRIC.setValue( null );
        command.addParameter( "MVIDPDRIC", sesMVIDPDRIC, null );
        if ( urlID.getObjectValue() == null ) urlID.setValue( null );
        command.addParameter( "ID", urlID, null );
        if ( sesMVIDRIC.getObjectValue() == null ) sesMVIDRIC.setValue( -1 );
        command.addParameter( "MVIDRIC", sesMVIDRIC, null );
        if ( sesMVREVRIC.getObjectValue() == null ) sesMVREVRIC.setValue( -1 );
        command.addParameter( "MVREVRIC", sesMVREVRIC, null );
        if ( StringUtils.isEmpty( (String) urlCr.getObjectValue() ) ) urlCr.setValue( "" );
        command.addParameter( "CRURL", urlCr, null );
        if ( StringUtils.isEmpty( (String) postCr.getObjectValue() ) ) postCr.setValue( "" );
        command.addParameter( "CRFORM", postCr, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT TITOLO ,  "
                                                         + "            amv_revisione.get_des_stato(amv_revisione.get_stato(nvl({ID},{MVIDRIC}),nvl({REV},{MVREVRIC}))) STATO ,  "
                                                         + "            amv_revisione.get_stato({MVIDRIC},{MVREVRIC}) COD_STATO ,  "
                                                         + "            decode(TIPO_TESTO,'Testo',TESTO,'Form',TESTO,'') testo , DATA_AGGIORNAMENTO ,  "
                                                         + "            REVISIONE ,0 ,'' ,decode( stato||amv_revisione.get_diritto_modifica('{Utente}',id_documento,  "
                                                         + "            revisione) , 'B1',  "
                                                         + "            '<a alt=\"Modifica\" title=\"Modifica\" href=\"../common/ServletModulistica.do?ID='||nvl({ID},{MVIDRIC})||'&IDPD='||id_documento||'&REV='||revisione||'&rw=W&'||link||'&'||replace(amv_documento.get_modello(id_documento_padre, revisione),'/','&')||'\"><img src=\"../common/images/AMV/edit.gif\" border=\"0\"></a>' , '' ) MOD_SRC , amv_documento.get_allegati(id_documento, revisione) ALLEGATI , nvl('{CRURL}','{CRFORM}') CODICE_RICHIESTA , 'MVIDRIC='||{MVIDRIC}||' MVIDPDRIC='||{MVIDPDRIC}||' REV='||{MVREVRIC} VARIABILI from amv_documenti where stato <> 'F' and amv_revisione.get_diritto('{Utente}',id_documento, revisione) is not null and id_documento = NVL({IDPD},{MVIDPDRIC}) and ( revisione = {REV} or nvl({REV},-1) = -1 and STATO in ('U','R') ) ) cnt " );
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

//loadDataBind @9-7578DED1
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AMV_VISTA_DOCUMENTIRow row = new AMV_VISTA_DOCUMENTIRow();
                DbRow record = (DbRow) records.nextElement();
                row.setTITOLO(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getTITOLOField())));
                row.setMODIFICA(Utils.convertToString(ds.parse(record.get("MOD_SRC"), row.getMODIFICAField())));
                row.setSTATO(Utils.convertToString(ds.parse(record.get("STATO"), row.getSTATOField())));
                row.setCOD_STATO(Utils.convertToString(ds.parse(record.get("COD_STATO"), row.getCOD_STATOField())));
                try {
                    row.setDATA_ULTIMA_MODIFICA(Utils.convertToDate(ds.parse(record.get("DATA_AGGIORNAMENTO"), row.getDATA_ULTIMA_MODIFICAField())));
                } catch ( java.text.ParseException pe ) {
                    model.addError( "Invalid data" );
                }
                row.setTESTO(Utils.convertToString(ds.parse(record.get("TESTO"), row.getTESTOField())));
                row.setALLEGATI(Utils.convertToString(ds.parse(record.get("ALLEGATI"), row.getALLEGATIField())));
                row.setMOD_HREF(Utils.convertToString(ds.parse(record.get("MOD_HREF"), row.getMOD_HREFField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @9-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @9-073DF12E
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "IDPD".equals(name) && "url".equals(prefix) ) {
                param = urlIDPD;
            } else if ( "IDPD".equals(name) && prefix == null ) {
                param = urlIDPD;
            }
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "REV".equals(name) && "url".equals(prefix) ) {
                param = urlREV;
            } else if ( "REV".equals(name) && prefix == null ) {
                param = urlREV;
            }
            if ( "MVIDPDRIC".equals(name) && "ses".equals(prefix) ) {
                param = sesMVIDPDRIC;
            } else if ( "MVIDPDRIC".equals(name) && prefix == null ) {
                param = sesMVIDPDRIC;
            }
            if ( "ID".equals(name) && "url".equals(prefix) ) {
                param = urlID;
            } else if ( "ID".equals(name) && prefix == null ) {
                param = urlID;
            }
            if ( "MVIDRIC".equals(name) && "ses".equals(prefix) ) {
                param = sesMVIDRIC;
            } else if ( "MVIDRIC".equals(name) && prefix == null ) {
                param = sesMVIDRIC;
            }
            if ( "MVREVRIC".equals(name) && "ses".equals(prefix) ) {
                param = sesMVREVRIC;
            } else if ( "MVREVRIC".equals(name) && prefix == null ) {
                param = sesMVREVRIC;
            }
            if ( "cr".equals(name) && "url".equals(prefix) ) {
                param = urlCr;
            } else if ( "cr".equals(name) && prefix == null ) {
                param = urlCr;
            }
            if ( "cr".equals(name) && "post".equals(prefix) ) {
                param = postCr;
            } else if ( "cr".equals(name) && prefix == null ) {
                param = postCr;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @9-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @9-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @9-238A81BB
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

//fireBeforeExecuteSelectEvent @9-9DA7B025
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

//fireAfterExecuteSelectEvent @9-F7E8A616
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

//class DataObject Tail @9-ED3F53A4
} // End of class DS
//End class DataObject Tail

