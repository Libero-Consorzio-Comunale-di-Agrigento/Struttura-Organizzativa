//ELENCO_REVISIONI DataSource @6-3D85EE0D
package amvadm.AdmRevisioniElenco;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End ELENCO_REVISIONI DataSource

//class DataObject Header @6-D5AC570F
public class ELENCO_REVISIONIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @6-AE64AEB3
    

    TextField sesUtente = new TextField(null, null);
    

    private ELENCO_REVISIONIRow[] rows = new ELENCO_REVISIONIRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @6-6A451BB6

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
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

//constructor @6-3DAE4065
    public ELENCO_REVISIONIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @6-7347F894
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select '<a alt=\"Modifica\" href=\"../amvadm/AdmDocumento.do?ID='||r.id_documento||'&REV='||r.revisione "
                    + "  ||'\">'||d.titolo||'</a>' titolo "
                    + ",  "
                    + "r.revisione "
                    + ",amv_revisione.get_img_stato(d.STATO) STATO_DOCUMENTO "
                    + ",  "
                    + "r.cronologia cronologia "
                    + "from amv_documenti d,  "
                    + "amv_documenti_revisioni r "
                    + "where d.id_documento = r.id_documento "
                    + "  and d.revisione = r.revisione "
                    + "  and amv_revisione.get_diritto_modifica('{Utente}',r.id_documento, r.revisione) = 1 "
                    + "  and stato in ('B','N','V','A')  "
                    + "  and d.tipo_testo != 'Richiesta'  " );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select '<a alt=\"Modifica\" href=\"../amvadm/AdmDocumento.do?ID='||r.id_documento||'&REV='||r.revisione ||'\">'||d.titolo||'</a>' titolo ,  "
                                                         + "            r.revisione ,amv_revisione.get_img_stato(d.STATO) STATO_DOCUMENTO ,  "
                                                         + "            r.cronologia cronologia from amv_documenti d,  "
                                                         + "            amv_documenti_revisioni r where d.id_documento = r.id_documento and d.revisione = r.revisione and amv_revisione.get_diritto_modifica('{Utente}',r.id_documento, r.revisione) = 1 and stato in ('B','N','V','A') and d.tipo_testo != 'Richiesta'  ) cnt " );
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

//loadDataBind @6-69E4496C
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                ELENCO_REVISIONIRow row = new ELENCO_REVISIONIRow();
                DbRow record = (DbRow) records.nextElement();
                row.setTITOLO(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getTITOLOField())));
                row.setREVISIONE(Utils.convertToString(ds.parse(record.get("REVISIONE"), row.getREVISIONEField())));
                row.setCRONOLOGIA(Utils.convertToString(ds.parse(record.get("CRONOLOGIA"), row.getCRONOLOGIAField())));
                row.setSTATO_DOCUMENTO(Utils.convertToString(ds.parse(record.get("STATO_DOCUMENTO"), row.getSTATO_DOCUMENTOField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @6-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @6-041216E8
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

//addGridDataObjectListener @6-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @6-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @6-238A81BB
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

//fireBeforeExecuteSelectEvent @6-9DA7B025
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

//fireAfterExecuteSelectEvent @6-F7E8A616
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

//class DataObject Tail @6-ED3F53A4
} // End of class DS
//End class DataObject Tail

