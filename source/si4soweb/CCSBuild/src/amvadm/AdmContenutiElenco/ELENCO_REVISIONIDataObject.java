//ELENCO_REVISIONI DataSource @2-E33A715F
package amvadm.AdmContenutiElenco;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End ELENCO_REVISIONI DataSource

//class DataObject Header @2-D5AC570F
public class ELENCO_REVISIONIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @2-061BDF4F
    

    TextField sesUtente = new TextField(null, null);
    
    LongField urlSZ = new LongField(null, null);
    

    private ELENCO_REVISIONIRow[] rows = new ELENCO_REVISIONIRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @2-28453033

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

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

    public ELENCO_REVISIONIRow[] getRows() {
        return rows;
    }

    public void setRows(ELENCO_REVISIONIRow[] rows) {
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

//constructor @2-3DAE4065
    public ELENCO_REVISIONIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @2-C54CC651
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select id_documento "
                    + ", revisione "
                    + ", titolo "
                    + ", id_tipologia "
                    + ", id_sezione "
                    + ",  "
                    + "data_riferimento "
                    + ",  "
                    + "amv_revisione.get_img_stato(stato) STATO_DOCUMENTO "
                    + ",decode(tipo_testo,'Richiesta','',decode( revisione "
                    + "       , 0, '' "
                    + "          ,  "
                    + "'<a alt=\"Storico revisioni\" title=\"Storico revisioni\" href=\"AdmRevisioniStorico.do?ID='||id_documento||'&REV='||revisione||'\"><img src=\"../common/images/AMV/storico.gif\" border=\"0\"></a>' "
                    + "       )) STORICO_SRC "
                    + ",decode(tipo_testo,'Richiesta','',decode( amv_revisione.get_diritto_modifica('{Utente}',id_documento, revisione) "
                    + "        , 1, '<a alt=\"Modifica\" title=\"Modifica\" href=\"../amvadm/AdmDocumento.do?ID='||id_documento||'&REV='||revisione||'\"><img src=\"../common/images/AMV/edit.gif\" border=\"0\"></a>' "
                    + "             , '' "
                    + "       )) MOD_SRC "
                    + ",decode( amv_revisione.get_diritto_revisione('{Utente}',id_documento, revisione) "
                    + "       , 'U' , '<a alt=\"Nuova revisione\" title=\"Nuova revisione\" href=\"../amvadm/AdmRevisioneNuova.do?ID='||id_documento||'&REV='||revisione||'\"><img src=\"../common/images/AMV/rev.gif\" border=\"0\"></a>' "
                    + "             , '' "
                    + "       ) REV_SRC "
                    + ", decode(tipo_testo "
                    + "        ,'Richiesta','../common/ServletModulistica.do?ID='||id_documento||'&IDPD='||id_documento_padre||'&REV='||revisione||'&'||link||'&'||replace(amv_documento.get_modello(id_documento_padre, revisione),'/','&')                    ,'../common/AmvDocumentoInfo.do?ID='||id_documento||'&REV='||revisione "
                    + "         ) HREF_SRC "
                    + "from amv_documenti where stato <> 'F' "
                    + "  and amv_revisione.get_diritto('{Utente}',id_documento, revisione) is not null "
                    + "  and id_sezione = {SZ} "
                    + "  and tipo_testo != 'Richiesta'  "
                    + "       " );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( urlSZ.getObjectValue() == null ) urlSZ.setValue( 0 );
        command.addParameter( "SZ", urlSZ, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select id_documento , revisione , titolo , id_tipologia , id_sezione ,  "
                                                         + "            data_riferimento ,  "
                                                         + "            amv_revisione.get_img_stato(stato) STATO_DOCUMENTO ,decode(tipo_testo,'Richiesta','',decode( revisione , 0, '' ,  "
                                                         + "            '<a alt=\"Storico revisioni\" title=\"Storico revisioni\" href=\"AdmRevisioniStorico.do?ID='||id_documento||'&REV='||revisione||'\"><img src=\"../common/images/AMV/storico.gif\" border=\"0\"></a>' )) STORICO_SRC ,decode(tipo_testo,'Richiesta','',decode( amv_revisione.get_diritto_modifica('{Utente}',id_documento, revisione) , 1, '<a alt=\"Modifica\" title=\"Modifica\" href=\"../amvadm/AdmDocumento.do?ID='||id_documento||'&REV='||revisione||'\"><img src=\"../common/images/AMV/edit.gif\" border=\"0\"></a>' , '' )) MOD_SRC ,decode( amv_revisione.get_diritto_revisione('{Utente}',id_documento, revisione) , 'U' , '<a alt=\"Nuova revisione\" title=\"Nuova revisione\" href=\"../amvadm/AdmRevisioneNuova.do?ID='||id_documento||'&REV='||revisione||'\"><img src=\"../common/images/AMV/rev.gif\" border=\"0\"></a>' , '' ) REV_SRC , decode(tipo_testo ,'Richiesta','../common/ServletModulistica.do?ID='||id_documento||'&IDPD='||id_documento_padre||'&REV='||revisione||'&'||link||'&'||replace(amv_documento.get_modello(id_documento_padre, revisione),'/','&') ,'../common/AmvDocumentoInfo.do?ID='||id_documento||'&REV='||revisione ) HREF_SRC from amv_documenti where stato <> 'F' and amv_revisione.get_diritto('{Utente}',id_documento, revisione) is not null and id_sezione = {SZ} and tipo_testo != 'Richiesta'  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "titolo" );
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

//loadDataBind @2-D0118E2A
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                ELENCO_REVISIONIRow row = new ELENCO_REVISIONIRow();
                DbRow record = (DbRow) records.nextElement();
                row.setTITOLO_DOC(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getTITOLO_DOCField())));
                try {
                    row.setDATA_RIFERIMENTO(Utils.convertToDate(ds.parse(record.get("DATA_RIFERIMENTO"), row.getDATA_RIFERIMENTOField())));
                } catch ( java.text.ParseException pe ) {
                    model.addError( "Invalid data" );
                }
                row.setID_DOCUMENTO(Utils.convertToString(ds.parse(record.get("ID_DOCUMENTO"), row.getID_DOCUMENTOField())));
                row.setREVISIONE(Utils.convertToString(ds.parse(record.get("REVISIONE"), row.getREVISIONEField())));
                row.setSTATO_DOCUMENTO(Utils.convertToString(ds.parse(record.get("STATO_DOCUMENTO"), row.getSTATO_DOCUMENTOField())));
                row.setSTORICO(Utils.convertToString(ds.parse(record.get("STORICO_SRC"), row.getSTORICOField())));
                row.setREVISIONA(Utils.convertToString(ds.parse(record.get("REV_SRC"), row.getREVISIONAField())));
                row.setMODIFICA(Utils.convertToString(ds.parse(record.get("MOD_SRC"), row.getMODIFICAField())));
                row.setHREF_SRC(Utils.convertToString(ds.parse(record.get("HREF_SRC"), row.getHREF_SRCField())));
                row.setREV_HREF(Utils.convertToString(ds.parse(record.get("REV_HREF"), row.getREV_HREFField())));
                row.setMOD_HREF(Utils.convertToString(ds.parse(record.get("MOD_HREF"), row.getMOD_HREFField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @2-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @2-05462794
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "SZ".equals(name) && "url".equals(prefix) ) {
                param = urlSZ;
            } else if ( "SZ".equals(name) && prefix == null ) {
                param = urlSZ;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @2-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @2-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @2-238A81BB
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

//fireBeforeExecuteSelectEvent @2-9DA7B025
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

//fireAfterExecuteSelectEvent @2-F7E8A616
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

//class DataObject Tail @2-ED3F53A4
} // End of class DS
//End class DataObject Tail

