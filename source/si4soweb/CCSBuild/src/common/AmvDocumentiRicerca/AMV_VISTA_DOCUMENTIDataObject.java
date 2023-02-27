//AMV_VISTA_DOCUMENTI DataSource @5-02CBA6C0
package common.AmvDocumentiRicerca;

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

//attributes of DataObject @5-15AC4705
    

    TextField urlS_ID_TIPOLOGIA = new TextField(null, null);
    
    TextField urlS_TESTO = new TextField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    TextField urlS_CERCA_TESTO = new TextField(null, null);
    
    TextField urlS_ID_SEZIONE = new TextField(null, null);
    
    TextField urlS_ID_CATEGORIA = new TextField(null, null);
    
    TextField urlS_ID_ARGOMENTO = new TextField(null, null);
    
    TextField urlMVTD = new TextField(null, null);
    
    TextField urlID_CATEGORIA = new TextField(null, null);
    

    private AMV_VISTA_DOCUMENTIRow[] rows = new AMV_VISTA_DOCUMENTIRow[100];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @5-47571601

    public void  setUrlS_ID_TIPOLOGIA( String param ) {
        this.urlS_ID_TIPOLOGIA.setValue( param );
    }

    public void  setUrlS_ID_TIPOLOGIA( Object param ) {
        this.urlS_ID_TIPOLOGIA.setValue( param );
    }

    public void  setUrlS_ID_TIPOLOGIA( Object param, Format ignore ) {
        this.urlS_ID_TIPOLOGIA.setValue( param );
    }

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

    public void  setUrlS_CERCA_TESTO( String param ) {
        this.urlS_CERCA_TESTO.setValue( param );
    }

    public void  setUrlS_CERCA_TESTO( Object param ) {
        this.urlS_CERCA_TESTO.setValue( param );
    }

    public void  setUrlS_CERCA_TESTO( Object param, Format ignore ) {
        this.urlS_CERCA_TESTO.setValue( param );
    }

    public void  setUrlS_ID_SEZIONE( String param ) {
        this.urlS_ID_SEZIONE.setValue( param );
    }

    public void  setUrlS_ID_SEZIONE( Object param ) {
        this.urlS_ID_SEZIONE.setValue( param );
    }

    public void  setUrlS_ID_SEZIONE( Object param, Format ignore ) {
        this.urlS_ID_SEZIONE.setValue( param );
    }

    public void  setUrlS_ID_CATEGORIA( String param ) {
        this.urlS_ID_CATEGORIA.setValue( param );
    }

    public void  setUrlS_ID_CATEGORIA( Object param ) {
        this.urlS_ID_CATEGORIA.setValue( param );
    }

    public void  setUrlS_ID_CATEGORIA( Object param, Format ignore ) {
        this.urlS_ID_CATEGORIA.setValue( param );
    }

    public void  setUrlS_ID_ARGOMENTO( String param ) {
        this.urlS_ID_ARGOMENTO.setValue( param );
    }

    public void  setUrlS_ID_ARGOMENTO( Object param ) {
        this.urlS_ID_ARGOMENTO.setValue( param );
    }

    public void  setUrlS_ID_ARGOMENTO( Object param, Format ignore ) {
        this.urlS_ID_ARGOMENTO.setValue( param );
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

    public void  setUrlID_CATEGORIA( String param ) {
        this.urlID_CATEGORIA.setValue( param );
    }

    public void  setUrlID_CATEGORIA( Object param ) {
        this.urlID_CATEGORIA.setValue( param );
    }

    public void  setUrlID_CATEGORIA( Object param, Format ignore ) {
        this.urlID_CATEGORIA.setValue( param );
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

//load @5-3C8DFFD3
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT DISTINCT "
                    + "  ID_DOCUMENTO "
                    + ", REVISIONE "
                    + ", ID_TIPOLOGIA "
                    + ", DES_TIPOLOGIA "
                    + ",  "
                    + "ID_CATEGORIA "
                    + ", DES_CATEGORIA "
                    + ", ID_ARGOMENTO "
                    + ", DES_ARGOMENTO "
                    + ", ID_RILEVANZA "
                    + ",  "
                    + "DES_RILEVANZA "
                    + ", ID_SEZIONE "
                    + ", DES_SEZIONE "
                    + ", IMPORTANZA "
                    + ", SEQUENZA "
                    + ", ID_AREA "
                    + ", TITOLO "
                    + ",  "
                    + "TIPO_TESTO "
                    + ", LINK "
                    + ", DATA_RIFERIMENTO "
                    + ", INIZIO_PUBBLICAZIONE "
                    + ",  "
                    + "decode(FINE_PUBBLICAZIONE,null,'','&nbsp;-&nbsp;'||to_char(FINE_PUBBLICAZIONE,'dd/mm/yyyy')) FINE_PUBBLICAZIONE "
                    + ", AUTORE "
                    + ", NOME_AUTORE "
                    + ", DATA_INSERIMENTO "
                    + ", UTENTE_AGGIORNAMENTO "
                    + ", NOME_UTENTE "
                    + ", DATA_ULTIMA_MODIFICA "
                    + ", UTENTE "
                    + ", EDIT "
                    + ", decode( EDIT,'SI', '<a alt=\"Modifica\" title=\"Modifica\" href=\"../amvadm/AdmDocumento.do?ID='||id_documento||'&REV='||revisione||'\"><img src=\"../common/images/AMV/edit.gif\" border=\"0\"></a>' "
                    + "             , '' "
                    + "       ) MOD_SRC "
                    + "FROM AMV_VISTA_DOCUMENTI "
                    + "WHERE UTENTE = '{Utente}' "
                    + "AND STATO in ('U','R') "
                    + "AND nvl(nvl('{s_ID_TIPOLOGIA}','{MVTD}'),ID_TIPOLOGIA) = ID_TIPOLOGIA  "
                    + "AND nvl('{s_ID_SEZIONE}',ID_SEZIONE) = ID_SEZIONE  "
                    + "AND nvl(nvl('{s_ID_CATEGORIA}','{ID_CATEGORIA}'),ID_CATEGORIA) = ID_CATEGORIA "
                    + "AND nvl('{s_ID_ARGOMENTO}',ID_ARGOMENTO) = ID_ARGOMENTO "
                    + "AND ( UPPER(TITOLO) LIKE '%'||UPPER(nvl('{s_TESTO}','%'))||'%' "
                    + "OR decode('{s_CERCA_TESTO}','1',DBMS_LOB.instr(TESTO,'{s_TESTO}'),0) > 0  "
                    + "OR decode('{s_CERCA_TESTO}','1',DBMS_LOB.instr(TESTO,UPPER(nvl('{s_TESTO}','%'))),0) > 0  "
                    + "OR decode('{s_CERCA_TESTO}','1',DBMS_LOB.instr(TESTO,LOWER(nvl('{s_TESTO}','%'))),0) > 0  "
                    + "OR decode('{s_CERCA_TESTO}','1',DBMS_LOB.instr(TESTO,INITCAP(nvl('{s_TESTO}','%'))),0) > 0  "
                    + "OR DES_CATEGORIA LIKE '%{s_TESTO}%' "
                    + "OR DES_ARGOMENTO LIKE '%{s_TESTO}%'  "
                    + "OR DES_TIPOLOGIA LIKE '%{s_TESTO}%'  "
                    + "OR DES_SEZIONE LIKE '%{s_TESTO}%'  "
                    + "OR to_char(DATA_ULTIMA_MODIFICA,'dd/mm/yyyy') LIKE '%{s_TESTO}%' ) "
                    + "" );
        if ( StringUtils.isEmpty( (String) urlS_ID_TIPOLOGIA.getObjectValue() ) ) urlS_ID_TIPOLOGIA.setValue( "" );
        command.addParameter( "s_ID_TIPOLOGIA", urlS_ID_TIPOLOGIA, null );
        if ( StringUtils.isEmpty( (String) urlS_TESTO.getObjectValue() ) ) urlS_TESTO.setValue( "" );
        command.addParameter( "s_TESTO", urlS_TESTO, null );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( StringUtils.isEmpty( (String) urlS_CERCA_TESTO.getObjectValue() ) ) urlS_CERCA_TESTO.setValue( "" );
        command.addParameter( "s_CERCA_TESTO", urlS_CERCA_TESTO, null );
        if ( StringUtils.isEmpty( (String) urlS_ID_SEZIONE.getObjectValue() ) ) urlS_ID_SEZIONE.setValue( "" );
        command.addParameter( "s_ID_SEZIONE", urlS_ID_SEZIONE, null );
        if ( StringUtils.isEmpty( (String) urlS_ID_CATEGORIA.getObjectValue() ) ) urlS_ID_CATEGORIA.setValue( "" );
        command.addParameter( "s_ID_CATEGORIA", urlS_ID_CATEGORIA, null );
        if ( StringUtils.isEmpty( (String) urlS_ID_ARGOMENTO.getObjectValue() ) ) urlS_ID_ARGOMENTO.setValue( "" );
        command.addParameter( "s_ID_ARGOMENTO", urlS_ID_ARGOMENTO, null );
        if ( StringUtils.isEmpty( (String) urlMVTD.getObjectValue() ) ) urlMVTD.setValue( "" );
        command.addParameter( "MVTD", urlMVTD, null );
        if ( StringUtils.isEmpty( (String) urlID_CATEGORIA.getObjectValue() ) ) urlID_CATEGORIA.setValue( "" );
        command.addParameter( "ID_CATEGORIA", urlID_CATEGORIA, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT DISTINCT ID_DOCUMENTO , REVISIONE , ID_TIPOLOGIA , DES_TIPOLOGIA ,  "
                                                         + "            ID_CATEGORIA , DES_CATEGORIA , ID_ARGOMENTO , DES_ARGOMENTO , ID_RILEVANZA ,  "
                                                         + "            DES_RILEVANZA , ID_SEZIONE , DES_SEZIONE , IMPORTANZA , SEQUENZA ,  "
                                                         + "            ID_AREA , TITOLO , TIPO_TESTO , LINK , DATA_RIFERIMENTO ,  "
                                                         + "            INIZIO_PUBBLICAZIONE ,  "
                                                         + "            decode(FINE_PUBBLICAZIONE,null,'','&nbsp;-&nbsp;'||to_char(FINE_PUBBLICAZIONE,'dd/mm/yyyy')) FINE_PUBBLICAZIONE , AUTORE ,  "
                                                         + "            NOME_AUTORE , DATA_INSERIMENTO , UTENTE_AGGIORNAMENTO ,  "
                                                         + "            NOME_UTENTE , DATA_ULTIMA_MODIFICA , UTENTE , EDIT , decode( EDIT,'SI',  "
                                                         + "            '<a alt=\"Modifica\" title=\"Modifica\" href=\"../amvadm/AdmDocumento.do?ID='||id_documento||'&REV='||revisione||'\"><img src=\"../common/images/AMV/edit.gif\" border=\"0\"></a>' , '' ) MOD_SRC FROM AMV_VISTA_DOCUMENTI WHERE UTENTE = '{Utente}' AND STATO in ('U','R') AND nvl(nvl('{s_ID_TIPOLOGIA}','{MVTD}'),ID_TIPOLOGIA) = ID_TIPOLOGIA AND nvl('{s_ID_SEZIONE}',ID_SEZIONE) = ID_SEZIONE AND nvl(nvl('{s_ID_CATEGORIA}','{ID_CATEGORIA}'),ID_CATEGORIA) = ID_CATEGORIA AND nvl('{s_ID_ARGOMENTO}',ID_ARGOMENTO) = ID_ARGOMENTO AND ( UPPER(TITOLO) LIKE '%'||UPPER(nvl('{s_TESTO}','%'))||'%' OR decode('{s_CERCA_TESTO}','1',DBMS_LOB.instr(TESTO,'{s_TESTO}'),0) > 0 OR decode('{s_CERCA_TESTO}','1',DBMS_LOB.instr(TESTO,UPPER(nvl('{s_TESTO}','%'))),0) > 0 OR decode('{s_CERCA_TESTO}','1',DBMS_LOB.instr(TESTO,LOWER(nvl('{s_TESTO}','%'))),0) > 0 OR decode('{s_CERCA_TESTO}','1',DBMS_LOB.instr(TESTO,INITCAP(nvl('{s_TESTO}','%'))),0) > 0 OR DES_CATEGORIA LIKE '%{s_TESTO}%' OR DES_ARGOMENTO LIKE '%{s_TESTO}%' OR DES_TIPOLOGIA LIKE '%{s_TESTO}%' OR DES_SEZIONE LIKE '%{s_TESTO}%' OR to_char(DATA_ULTIMA_MODIFICA,'dd/mm/yyyy') LIKE '%{s_TESTO}%' )  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "TITOLO" );
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

//loadDataBind @5-E4453BD9
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AMV_VISTA_DOCUMENTIRow row = new AMV_VISTA_DOCUMENTIRow();
                DbRow record = (DbRow) records.nextElement();
                row.setTITOLO(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getTITOLOField())));
                row.setSEZIONE(Utils.convertToString(ds.parse(record.get("DES_SEZIONE"), row.getSEZIONEField())));
                try {
                    row.setDATA_ULTIMA_MODIFICA(Utils.convertToDate(ds.parse(record.get("DATA_ULTIMA_MODIFICA"), row.getDATA_ULTIMA_MODIFICAField())));
                } catch ( java.text.ParseException pe ) {
                    model.addError( "Invalid data" );
                }
                row.setMODIFICA(Utils.convertToString(ds.parse(record.get("MOD_SRC"), row.getMODIFICAField())));
                row.setID(Utils.convertToString(ds.parse(record.get("ID_DOCUMENTO"), row.getIDField())));
                row.setID_DOCUMENTO(Utils.convertToString(ds.parse(record.get("ID_DOCUMENTO"), row.getID_DOCUMENTOField())));
                row.setREV(Utils.convertToString(ds.parse(record.get("REVISIONE"), row.getREVField())));
                row.setREVISIONE(Utils.convertToString(ds.parse(record.get("REVISIONE"), row.getREVISIONEField())));
                row.setMVTD(Utils.convertToString(ds.parse(record.get("ID_TIPOLOGIA"), row.getMVTDField())));
                row.setID_TIPOLOGIA(Utils.convertToString(ds.parse(record.get("ID_TIPOLOGIA"), row.getID_TIPOLOGIAField())));
                row.setMVSZ(Utils.convertToString(ds.parse(record.get("ID_SEZIONE"), row.getMVSZField())));
                row.setID_SEZIONE(Utils.convertToString(ds.parse(record.get("ID_SEZIONE"), row.getID_SEZIONEField())));
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

//getParameterByName @5-A6CF312B
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "s_ID_TIPOLOGIA".equals(name) && "url".equals(prefix) ) {
                param = urlS_ID_TIPOLOGIA;
            } else if ( "s_ID_TIPOLOGIA".equals(name) && prefix == null ) {
                param = urlS_ID_TIPOLOGIA;
            }
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
            if ( "s_CERCA_TESTO".equals(name) && "url".equals(prefix) ) {
                param = urlS_CERCA_TESTO;
            } else if ( "s_CERCA_TESTO".equals(name) && prefix == null ) {
                param = urlS_CERCA_TESTO;
            }
            if ( "s_ID_SEZIONE".equals(name) && "url".equals(prefix) ) {
                param = urlS_ID_SEZIONE;
            } else if ( "s_ID_SEZIONE".equals(name) && prefix == null ) {
                param = urlS_ID_SEZIONE;
            }
            if ( "s_ID_CATEGORIA".equals(name) && "url".equals(prefix) ) {
                param = urlS_ID_CATEGORIA;
            } else if ( "s_ID_CATEGORIA".equals(name) && prefix == null ) {
                param = urlS_ID_CATEGORIA;
            }
            if ( "s_ID_ARGOMENTO".equals(name) && "url".equals(prefix) ) {
                param = urlS_ID_ARGOMENTO;
            } else if ( "s_ID_ARGOMENTO".equals(name) && prefix == null ) {
                param = urlS_ID_ARGOMENTO;
            }
            if ( "MVTD".equals(name) && "url".equals(prefix) ) {
                param = urlMVTD;
            } else if ( "MVTD".equals(name) && prefix == null ) {
                param = urlMVTD;
            }
            if ( "ID_CATEGORIA".equals(name) && "url".equals(prefix) ) {
                param = urlID_CATEGORIA;
            } else if ( "ID_CATEGORIA".equals(name) && prefix == null ) {
                param = urlID_CATEGORIA;
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

