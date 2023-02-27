//AD4_DOCUMENTO_SEL DataSource @10-B8CD6794
package amvadm.AdmDocumentoRevisioni;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_DOCUMENTO_SEL DataSource

//class DataObject Header @10-50AAC6FC
public class AD4_DOCUMENTO_SELDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @10-05D8856F
    

    LongField urlREV = new LongField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    LongField urlID = new LongField(null, null);
    

    private AD4_DOCUMENTO_SELRow[] rows = new AD4_DOCUMENTO_SELRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @10-DBEC5214

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

    public AD4_DOCUMENTO_SELRow[] getRows() {
        return rows;
    }

    public void setRows(AD4_DOCUMENTO_SELRow[] rows) {
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

//constructor @10-8764C5C1
    public AD4_DOCUMENTO_SELDataObject(Page page) {
        super(page);
    }
//End constructor

//load @10-D08BC005
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT titolo "
                    + ",  "
                    + "decode(amv_revisione.get_diritto_revisione('{Utente}',id_documento,revisione) "
                    + "        , null, '' "
                    + "        , 'R' , '' "
                    + "        ,  "
                    + "'<a class=\"AFCDataLink\" alt=\"Nuova revisione\" title=\"Nuova revisione\" href=\"../amvadm/AdmRevisioneNuova.do?ID='||id_documento||'&REV='||revisione||'\"><i>Nuova&nbsp;revisione...</i></a>' "
                    + "        ) nuova_rev "
                    + "FROM amv_documenti  "
                    + "WHERE id_documento = {ID} "
                    + "and revisione = {REV}" );
        if ( urlREV.getObjectValue() == null ) urlREV.setValue( 0 );
        command.addParameter( "REV", urlREV, null );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( urlID.getObjectValue() == null ) urlID.setValue( 0 );
        command.addParameter( "ID", urlID, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT titolo ,  "
                                                         + "            decode(amv_revisione.get_diritto_revisione('{Utente}',id_documento,revisione) , null, '' , 'R' , '' ,  "
                                                         + "            '<a class=\"AFCDataLink\" alt=\"Nuova revisione\" title=\"Nuova revisione\" href=\"../amvadm/AdmRevisioneNuova.do?ID='||id_documento||'&REV='||revisione||'\"><i>Nuova&nbsp;revisione...</i></a>' ) nuova_rev FROM amv_documenti WHERE id_documento = {ID} and revisione = {REV} ) cnt " );
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

//loadDataBind @10-2D4B99A5
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AD4_DOCUMENTO_SELRow row = new AD4_DOCUMENTO_SELRow();
                DbRow record = (DbRow) records.nextElement();
                row.setNOME_DOCUMENTO(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getNOME_DOCUMENTOField())));
                row.setNUOVA_REV(Utils.convertToString(ds.parse(record.get("NUOVA_REV"), row.getNUOVA_REVField())));
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

//getParameterByName @10-A94C7867
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "REV".equals(name) && "url".equals(prefix) ) {
                param = urlREV;
            } else if ( "REV".equals(name) && prefix == null ) {
                param = urlREV;
            }
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

