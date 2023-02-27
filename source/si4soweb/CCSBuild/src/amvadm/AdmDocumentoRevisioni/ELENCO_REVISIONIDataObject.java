//ELENCO_REVISIONI DataSource @2-B8CD6794
package amvadm.AdmDocumentoRevisioni;

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

//attributes of DataObject @2-C132D9B3
    

    TextField sesUtente = new TextField(null, null);
    
    LongField urlID = new LongField(null, null);
    

    private ELENCO_REVISIONIRow[] rows = new ELENCO_REVISIONIRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @2-3F2A2F4C

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
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

//load @2-98214BF8
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select id_documento "
                    + ", revisione "
                    + ", titolo "
                    + ", data_riferimento "
                    + ",  "
                    + "amv_revisione.get_img_stato(stato) STATO_DOCUMENTO "
                    + ",decode( amv_revisione.get_diritto_modifica('{Utente}',id_documento, revisione) "
                    + "        , 1, '<a alt=\"Modifica\" title=\"Modifica\" href=\"../amvadm/AdmDocumento.do?ID='||id_documento||'&REV='||revisione||'\"><img src=\"../common/images/AMV/edit.gif\" border=\"0\"></a>' "
                    + "             , '' "
                    + "       ) MOD_SRC "
                    + ", '../common/AmvDocumentoInfo.do' HREF_SRC "
                    + "from amv_documenti "
                    + "where id_documento = {ID} "
                    + "and amv_revisione.get_diritto('{Utente}',id_documento, revisione) is not null "
                    + "" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( urlID.getObjectValue() == null ) urlID.setValue( -1 );
        command.addParameter( "ID", urlID, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select id_documento , revisione , titolo , data_riferimento ,  "
                                                         + "            amv_revisione.get_img_stato(stato) STATO_DOCUMENTO ,decode( amv_revisione.get_diritto_modifica('{Utente}',id_documento, revisione) , 1, '<a alt=\"Modifica\" title=\"Modifica\" href=\"../amvadm/AdmDocumento.do?ID='||id_documento||'&REV='||revisione||'\"><img src=\"../common/images/AMV/edit.gif\" border=\"0\"></a>' , '' ) MOD_SRC , '../common/AmvDocumentoInfo.do' HREF_SRC from amv_documenti where id_documento = {ID} and amv_revisione.get_diritto('{Utente}',id_documento, revisione) is not null  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "revisione desc" );
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

//loadDataBind @2-D9AB2D03
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                ELENCO_REVISIONIRow row = new ELENCO_REVISIONIRow();
                DbRow record = (DbRow) records.nextElement();
                row.setREVISIONE(Utils.convertToString(ds.parse(record.get("REVISIONE"), row.getREVISIONEField())));
                row.setSTATO_DOCUMENTO(Utils.convertToString(ds.parse(record.get("STATO_DOCUMENTO"), row.getSTATO_DOCUMENTOField())));
                row.setTITOLO_DOC(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getTITOLO_DOCField())));
                row.setMODIFICA(Utils.convertToString(ds.parse(record.get("MOD_SRC"), row.getMODIFICAField())));
                row.setID(Utils.convertToString(ds.parse(record.get("ID_DOCUMENTO"), row.getIDField())));
                row.setID_DOCUMENTO(Utils.convertToString(ds.parse(record.get("ID_DOCUMENTO"), row.getID_DOCUMENTOField())));
                row.setREV(Utils.convertToString(ds.parse(record.get("REVISIONE"), row.getREVField())));
                row.setHREF_SRC(Utils.convertToString(ds.parse(record.get("HREF_SRC"), row.getHREF_SRCField())));
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

//getParameterByName @2-40CA08CB
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "ID".equals(name) && "url".equals(prefix) ) {
                param = urlID;
            } else if ( "ID".equals(name) && prefix == null ) {
                param = urlID;
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

