//RICHIESTA_GRID DataSource @39-E461BC83
package common.AmvRichiestaConferma;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End RICHIESTA_GRID DataSource

//class DataObject Header @39-B0525F68
public class RICHIESTA_GRIDDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @39-51FC1125
    

    TextField sesUtente = new TextField(null, null);
    
    LongField sesMVIDRIC = new LongField(null, null);
    
    LongField sesMVREVRIC = new LongField(null, null);
    

    private RICHIESTA_GRIDRow[] rows = new RICHIESTA_GRIDRow[300];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @39-510A7BD1

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
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

    public RICHIESTA_GRIDRow[] getRows() {
        return rows;
    }

    public void setRows(RICHIESTA_GRIDRow[] rows) {
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

//constructor @39-C3A54D6E
    public RICHIESTA_GRIDDataObject(Page page) {
        super(page);
    }
//End constructor

//load @39-462C2E34
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT TITOLO "
                    + ", {MVIDRIC} ID_RICHIESTA "
                    + ", 'elenco richieste' ELENCO_RICHIESTE_SRC "
                    + ",  "
                    + "'../restrict/AmvRichiesteAutore.do' ELENCO_RICHIESTE_HREF "
                    + ",  "
                    + "'visualizzare i dati in formato stampabile' STAMPA_RICHIESTA_SRC "
                    + ",  "
                    + "'../restrict/ServletModulisticaView.do' STAMPA_RICHIESTA_HREF "
                    + ",  "
                    + "decode(stato,'B','modificare i dati inseriti') MODIFICA_RICHIESTA_SRC "
                    + ",  "
                    + "decode(stato,'B','../restrict/ServletModulistica.do','') MODIFICA_RICHIESTA_HREF "
                    + ",  "
                    + "decode(stato,'B','rendere definitiva la richiesta ed attivare l''iter di verifica/approvazione','') CONFERMA_RICHIESTA_SRC "
                    + ",  "
                    + "decode(stato,'B','../common/AmvRichiestaInoltra.do?ccsForm=RICHIESTA_INOLTRA:Edit&Update=Conferma','') CONFERMA_RICHIESTA_HREF "
                    + ", decode(afc.get_stringparm(amv_documento.get_link(ID_DOCUMENTO_PADRE, REVISIONE),'iter','') "
                    + "             , 'N', 'A' "
                    + "             , 'A', 'V' "
                    + "                  , 'N' "
                    + "             ) STATO_FUTURO "
                    + " FROM AMV_DOCUMENTI "
                    + "WHERE AUTORE = '{Utente}' "
                    + "  AND ID_DOCUMENTO = {MVIDRIC} "
                    + "  AND REVISIONE = {MVREVRIC}" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( sesMVIDRIC.getObjectValue() == null ) sesMVIDRIC.setValue( null );
        command.addParameter( "MVIDRIC", sesMVIDRIC, null );
        if ( sesMVREVRIC.getObjectValue() == null ) sesMVREVRIC.setValue( null );
        command.addParameter( "MVREVRIC", sesMVREVRIC, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT TITOLO , {MVIDRIC} ID_RICHIESTA , 'elenco richieste' ELENCO_RICHIESTE_SRC ,  "
                                                         + "            '../restrict/AmvRichiesteAutore.do' ELENCO_RICHIESTE_HREF ,  "
                                                         + "            'visualizzare i dati in formato stampabile' STAMPA_RICHIESTA_SRC ,  "
                                                         + "            '../restrict/ServletModulisticaView.do' STAMPA_RICHIESTA_HREF ,  "
                                                         + "            decode(stato,'B','modificare i dati inseriti') MODIFICA_RICHIESTA_SRC ,  "
                                                         + "            decode(stato,'B','../restrict/ServletModulistica.do','') MODIFICA_RICHIESTA_HREF , decode(stato,'B','rendere definitiva la richiesta ed attivare l''iter di verifica/approvazione','') CONFERMA_RICHIESTA_SRC , decode(stato,'B','../common/AmvRichiestaInoltra.do?ccsForm=RICHIESTA_INOLTRA:Edit&Update=Conferma','') CONFERMA_RICHIESTA_HREF , decode(afc.get_stringparm(amv_documento.get_link(ID_DOCUMENTO_PADRE, REVISIONE),'iter','') , 'N', 'A' , 'A', 'V' , 'N' ) STATO_FUTURO FROM AMV_DOCUMENTI WHERE AUTORE = '{Utente}' AND ID_DOCUMENTO = {MVIDRIC} AND REVISIONE = {MVREVRIC} ) cnt " );
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

//loadDataBind @39-0ABD401B
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                RICHIESTA_GRIDRow row = new RICHIESTA_GRIDRow();
                DbRow record = (DbRow) records.nextElement();
                row.setTITOLO(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getTITOLOField())));
                row.setSTATO_FUTURO(Utils.convertToString(ds.parse(record.get("STATO_FUTURO"), row.getSTATO_FUTUROField())));
                row.setID_RICHIESTA(Utils.convertToLong(ds.parse(record.get("ID_RICHIESTA"), row.getID_RICHIESTAField())));
                row.setELENCO_RICHIESTE_LINK(Utils.convertToString(ds.parse(record.get("ELENCO_RICHIESTE_SRC"), row.getELENCO_RICHIESTE_LINKField())));
                row.setSTAMPA_RICHIESTA(Utils.convertToString(ds.parse(record.get("STAMPA_RICHIESTA_SRC"), row.getSTAMPA_RICHIESTAField())));
                row.setMODIFICA_RICHIESTA_LINK(Utils.convertToString(ds.parse(record.get("MODIFICA_RICHIESTA_SRC"), row.getMODIFICA_RICHIESTA_LINKField())));
                row.setCONFERMA_RICHIESTA_LINK(Utils.convertToString(ds.parse(record.get("CONFERMA_RICHIESTA_SRC"), row.getCONFERMA_RICHIESTA_LINKField())));
                row.setELENCO_RICHIESTE_HREF(Utils.convertToString(ds.parse(record.get("ELENCO_RICHIESTE_HREF"), row.getELENCO_RICHIESTE_HREFField())));
                row.setSTAMPA_RICHIESTA_HREF(Utils.convertToString(ds.parse(record.get("STAMPA_RICHIESTA_HREF"), row.getSTAMPA_RICHIESTA_HREFField())));
                row.setMODIFICA_RICHIESTA_HREF(Utils.convertToString(ds.parse(record.get("MODIFICA_RICHIESTA_HREF"), row.getMODIFICA_RICHIESTA_HREFField())));
                row.setCONFERMA_RICHIESTA_HREF(Utils.convertToString(ds.parse(record.get("CONFERMA_RICHIESTA_HREF"), row.getCONFERMA_RICHIESTA_HREFField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @39-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @39-68901F88
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
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
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @39-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @39-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @39-238A81BB
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

//fireBeforeExecuteSelectEvent @39-9DA7B025
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

//fireAfterExecuteSelectEvent @39-F7E8A616
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

//class DataObject Tail @39-ED3F53A4
} // End of class DS
//End class DataObject Tail

