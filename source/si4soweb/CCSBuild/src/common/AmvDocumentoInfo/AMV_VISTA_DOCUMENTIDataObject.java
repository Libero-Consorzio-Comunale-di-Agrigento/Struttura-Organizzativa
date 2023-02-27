//AMV_VISTA_DOCUMENTI DataSource @5-0E3FD7C4
package common.AmvDocumentoInfo;

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

//attributes of DataObject @5-76F2E5BF
    

    LongField urlID = new LongField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    LongField urlREV = new LongField(null, null);
    

    private AMV_VISTA_DOCUMENTIRow[] rows = new AMV_VISTA_DOCUMENTIRow[100];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @5-CA7A3889

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

//load @5-62E6C917
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT TITOLO "
                    + ", decode(stato,'U', '',amv_revisione.get_des_stato(STATO)) STATO "
                    + ",  "
                    + "decode(TIPO_TESTO,'Testo',TESTO,'Form',TESTO,'') testo "
                    + ", INIZIO_PUBBLICAZIONE "
                    + ",  "
                    + "decode(FINE_PUBBLICAZIONE,null,'','&nbsp;-&nbsp;'||to_char(FINE_PUBBLICAZIONE,'dd/mm/yyyy')) DSP_FINE_PUBBLICAZIONE "
                    + ", DATA_AGGIORNAMENTO "
                    + ", REVISIONE "
                    + ", decode(instr(amv_documento.crea_link_documento(id_documento, link, 'Link...'),'://') "
                    + ",0 "
                    + ",'' "
                    + ",substr(amv_documento.crea_link_documento(id_documento, link, 'Link...'),1,instr(amv_documento.crea_link_documento(id_documento, link, 'Link...'),'>'))||'<img src=\"../common/images/AMV/Links.gif\" align=\"absMiddle\" border=\"0\" alt=\"Apri il collegamento\"></a>') img_link "
                    + ",decode( amv_revisione.get_diritto_modifica('{Utente}',id_documento, revisione) "
                    + "        , 1 "
                    + "        , '<a alt=\"Storico revisioni\" title=\"Storico revisioni\" href=\"../amvadm/AdmRevisioniStorico.do?ID='||id_documento||'&REV='||revisione||'\"><img src=\"../common/images/AMV/storico.gif\" border=\"0\"></a>' "
                    + "        , '' "
                    + "       ) STORICO_SRC "
                    + ",decode( amv_revisione.get_diritto_modifica('{Utente}',id_documento, revisione) "
                    + "        , 1, '<a alt=\"Modifica\" title=\"Modifica\" href=\"../amvadm/AdmDocumento.do?ID='||id_documento||'&REV='||revisione||'\"><img src=\"../common/images/AMV/edit.gif\" border=\"0\"></a>' "
                    + "             , '' "
                    + "       ) MOD_SRC "
                    + ",decode( amv_revisione.get_diritto_revisione('{Utente}',id_documento, revisione) "
                    + "       , 'U' , '<a alt=\"Nuova revisione\" title=\"Nuova revisione\" href=\"../amvadm/AdmRevisioneNuova.do?ID='||id_documento||'&REV='||revisione||'\"><img src=\"../common/images/AMV/rev.gif\" border=\"0\"></a>' "
                    + "             , '' "
                    + "       ) REV_SRC "
                    + "from amv_documenti "
                    + "where id_documento = {ID} "
                    + "  and (   revisione = {REV} "
                    + "       or {REV}  = -1 and STATO in ('U','R') "
                    + "      ) "
                    + "  and (    amv_revisione.get_diritto('{Utente}',id_documento, revisione) is not null "
                    + "       and stato in ('U','R') "
                    + "      or   amv_revisione.get_diritto('{Utente}',id_documento, revisione) = 'U' "
                    + "       and stato = 'F' "
                    + "      or   amv_revisione.get_diritto_modifica('{Utente}',id_documento, revisione)= 1 "
                    + "       ) "
                    + "   and tipo_testo != 'Richiesta'" );
        if ( urlID.getObjectValue() == null ) urlID.setValue( 0 );
        command.addParameter( "ID", urlID, null );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( urlREV.getObjectValue() == null ) urlREV.setValue( -1 );
        command.addParameter( "REV", urlREV, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT TITOLO , decode(stato,'U', '',amv_revisione.get_des_stato(STATO)) STATO ,  "
                                                         + "            decode(TIPO_TESTO,'Testo',TESTO,'Form',TESTO,'') testo ,  "
                                                         + "            INIZIO_PUBBLICAZIONE ,  "
                                                         + "            decode(FINE_PUBBLICAZIONE,null,'','&nbsp;-&nbsp;'||to_char(FINE_PUBBLICAZIONE,'dd/mm/yyyy')) DSP_FINE_PUBBLICAZIONE ,  "
                                                         + "            DATA_AGGIORNAMENTO , REVISIONE ,  "
                                                         + "            decode(instr(amv_documento.crea_link_documento(id_documento, link,  "
                                                         + "            'Link...'),'://') ,0 ,'' ,substr(amv_documento.crea_link_documento(id_documento, link,  "
                                                         + "            'Link...'),1,instr(amv_documento.crea_link_documento(id_documento, link,  "
                                                         + "            'Link...'),'>'))||'<img src=\"../common/images/AMV/Links.gif\" align=\"absMiddle\" border=\"0\" alt=\"Apri il collegamento\"></a>') img_link ,decode( amv_revisione.get_diritto_modifica('{Utente}',id_documento, revisione) , 1 , '<a alt=\"Storico revisioni\" title=\"Storico revisioni\" href=\"../amvadm/AdmRevisioniStorico.do?ID='||id_documento||'&REV='||revisione||'\"><img src=\"../common/images/AMV/storico.gif\" border=\"0\"></a>' , '' ) STORICO_SRC ,decode( amv_revisione.get_diritto_modifica('{Utente}',id_documento, revisione) , 1, '<a alt=\"Modifica\" title=\"Modifica\" href=\"../amvadm/AdmDocumento.do?ID='||id_documento||'&REV='||revisione||'\"><img src=\"../common/images/AMV/edit.gif\" border=\"0\"></a>' , '' ) MOD_SRC ,decode( amv_revisione.get_diritto_revisione('{Utente}',id_documento, revisione) , 'U' , '<a alt=\"Nuova revisione\" title=\"Nuova revisione\" href=\"../amvadm/AdmRevisioneNuova.do?ID='||id_documento||'&REV='||revisione||'\"><img src=\"../common/images/AMV/rev.gif\" border=\"0\"></a>' , '' ) REV_SRC from amv_documenti where id_documento = {ID} and ( revisione = {REV} or {REV} = -1 and STATO in ('U','R') ) and ( amv_revisione.get_diritto('{Utente}',id_documento, revisione) is not null and stato in ('U','R') or amv_revisione.get_diritto('{Utente}',id_documento, revisione) = 'U' and stato = 'F' or amv_revisione.get_diritto_modifica('{Utente}',id_documento, revisione)= 1 ) and tipo_testo != 'Richiesta' ) cnt " );
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

//loadDataBind @5-CA74EDC7
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AMV_VISTA_DOCUMENTIRow row = new AMV_VISTA_DOCUMENTIRow();
                DbRow record = (DbRow) records.nextElement();
                row.setTITOLO(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getTITOLOField())));
                row.setIMG_LINK(Utils.convertToString(ds.parse(record.get("IMG_LINK"), row.getIMG_LINKField())));
                row.setSTORICO(Utils.convertToString(ds.parse(record.get("STORICO_SRC"), row.getSTORICOField())));
                row.setREVISIONA(Utils.convertToString(ds.parse(record.get("REV_SRC"), row.getREVISIONAField())));
                row.setMODIFICA(Utils.convertToString(ds.parse(record.get("MOD_SRC"), row.getMODIFICAField())));
                row.setSTATO(Utils.convertToString(ds.parse(record.get("STATO"), row.getSTATOField())));
                try {
                    row.setINIZIO_PUBBLICAZIONE(Utils.convertToDate(ds.parse(record.get("INIZIO_PUBBLICAZIONE"), row.getINIZIO_PUBBLICAZIONEField())));
                } catch ( java.text.ParseException pe ) {
                    model.addError( "Invalid data" );
                }
                row.setDSP_FINE_PUBBLICAZIONE(Utils.convertToString(ds.parse(record.get("DSP_FINE_PUBBLICAZIONE"), row.getDSP_FINE_PUBBLICAZIONEField())));
                try {
                    row.setDATA_ULTIMA_MODIFICA(Utils.convertToDate(ds.parse(record.get("DATA_AGGIORNAMENTO"), row.getDATA_ULTIMA_MODIFICAField())));
                } catch ( java.text.ParseException pe ) {
                    model.addError( "Invalid data" );
                }
                row.setTESTO(Utils.convertToString(ds.parse(record.get("TESTO"), row.getTESTOField())));
                row.setREV_HREF(Utils.convertToString(ds.parse(record.get("REV_HREF"), row.getREV_HREFField())));
                row.setMOD_HREF(Utils.convertToString(ds.parse(record.get("MOD_HREF"), row.getMOD_HREFField())));
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

//getParameterByName @5-CDA1165A
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "ID".equals(name) && "url".equals(prefix) ) {
                param = urlID;
            } else if ( "ID".equals(name) && prefix == null ) {
                param = urlID;
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

