//AD4_RICHIESTE_ABILITAZIONE DataSource @30-2786B8F7
package amvadm.AdmRichieste;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_RICHIESTE_ABILITAZIONE DataSource

//class DataObject Header @30-D8D2B3E8
public class AD4_RICHIESTE_ABILITAZIONEDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @30-2A92FA4A
    

    LongField urlMVAV = new LongField(null, null);
    
    LongField sesGroupID = new LongField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    

    private AD4_RICHIESTE_ABILITAZIONERow[] rows = new AD4_RICHIESTE_ABILITAZIONERow[100];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @30-F3A0A9A3

    public void  setUrlMVAV( long param ) {
        this.urlMVAV.setValue( param );
    }

    public void  setUrlMVAV( long param, Format ignore ) throws java.text.ParseException {
        this.urlMVAV.setValue( param );
    }

    public void  setUrlMVAV( Object param, Format format ) throws java.text.ParseException {
        this.urlMVAV.setValue( param, format );
    }

    public void  setUrlMVAV( Long param ) {
        this.urlMVAV.setValue( param );
    }

    public void  setSesGroupID( long param ) {
        this.sesGroupID.setValue( param );
    }

    public void  setSesGroupID( long param, Format ignore ) throws java.text.ParseException {
        this.sesGroupID.setValue( param );
    }

    public void  setSesGroupID( Object param, Format format ) throws java.text.ParseException {
        this.sesGroupID.setValue( param, format );
    }

    public void  setSesGroupID( Long param ) {
        this.sesGroupID.setValue( param );
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

    public AD4_RICHIESTE_ABILITAZIONERow[] getRows() {
        return rows;
    }

    public void setRows(AD4_RICHIESTE_ABILITAZIONERow[] rows) {
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

//constructor @30-CBCD891C
    public AD4_RICHIESTE_ABILITAZIONEDataObject(Page page) {
        super(page);
    }
//End constructor

//load @30-BE2CA011
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT m.descrizione||' - '||i.descrizione servizio "
                    + ",  "
                    + "decode(s.abilitazione,'A','Automatica','Controllata') abilitazione "
                    + ", l.descrizione livello "
                    + ", r.modulo "
                    + ",  "
                    + "r.istanza "
                    + ", count(r.id_richiesta) totale_richieste "
                    + ",  "
                    + "decode({MVAV},1,'F',2,'A',3,'R','C') stato  "
                    + "FROM ad4_ruoli ru "
                    + ", ad4_diritti_accesso d "
                    + ",  "
                    + "ad4_livelli_sicurezza l "
                    + ", ad4_servizi s "
                    + ", ad4_istanze i "
                    + ", ad4_moduli m "
                    + ",  "
                    + "ad4_richieste_abilitazione r "
                    + "WHERE ru.ruolo = d.ruolo "
                    + "AND nvl(ru.profilo,-1) = nvl({GroupID},-1) "
                    + "AND d.utente = '{Utente}' "
                    + "AND d.modulo = r.modulo "
                    + "AND d.istanza = r.istanza "
                    + "AND l.livello (+) = s.livello "
                    + "AND s.istanza = r.istanza "
                    + "AND s.modulo = r.modulo "
                    + "AND i.istanza = r.istanza "
                    + "AND m.modulo = r.modulo "
                    + "AND r.stato = decode({MVAV},1,'F',2,'A',3,'R','C') "
                    + "GROUP BY r.modulo, r.istanza, m.descrizione, i.descrizione, l.descrizione, s.abilitazione "
                    + "" );
        if ( urlMVAV.getObjectValue() == null ) urlMVAV.setValue( -1 );
        command.addParameter( "MVAV", urlMVAV, null );
        if ( sesGroupID.getObjectValue() == null ) sesGroupID.setValue( -1 );
        command.addParameter( "GroupID", sesGroupID, null );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT m.descrizione||' - '||i.descrizione servizio ,  "
+ "            decode(s.abilitazione,'A','Automatica','Controllata') abilitazione , l.descrizione livello ,  "
+ "            r.modulo , r.istanza , count(r.id_richiesta) totale_richieste ,  "
+ "            decode({MVAV},1,'F',2,'A',3,'R','C') stato FROM ad4_ruoli ru ,  "
+ "            ad4_diritti_accesso d , ad4_livelli_sicurezza l , ad4_servizi s ,  "
+ "            ad4_istanze i , ad4_moduli m ,  "
+ "            ad4_richieste_abilitazione r WHERE ru.ruolo = d.ruolo AND nvl(ru.profilo,-1) = nvl({GroupID},-1) AND d.utente = '{Utente}' AND d.modulo = r.modulo AND d.istanza = r.istanza AND l.livello (+) = s.livello AND s.istanza = r.istanza AND s.modulo = r.modulo AND i.istanza = r.istanza AND m.modulo = r.modulo AND r.stato = decode({MVAV},1,'F',2,'A',3,'R','C') GROUP BY r.modulo, r.istanza, m.descrizione, i.descrizione, l.descrizione, s.abilitazione  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "1" );
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

//loadDataBind @30-48AC6907
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AD4_RICHIESTE_ABILITAZIONERow row = new AD4_RICHIESTE_ABILITAZIONERow();
                DbRow record = (DbRow) records.nextElement();
                row.setSERVIZIO(Utils.convertToString(ds.parse(record.get("SERVIZIO"), row.getSERVIZIOField())));
                row.setABILITAZIONE(Utils.convertToString(ds.parse(record.get("ABILITAZIONE"), row.getABILITAZIONEField())));
                row.setLIVELLO(Utils.convertToString(ds.parse(record.get("LIVELLO"), row.getLIVELLOField())));
                row.setTOTALE_RICHIESTE(Utils.convertToString(ds.parse(record.get("TOTALE_RICHIESTE"), row.getTOTALE_RICHIESTEField())));
                row.setMOD(Utils.convertToString(ds.parse(record.get("MODULO"), row.getMODField())));
                row.setMODULO(Utils.convertToString(ds.parse(record.get("MODULO"), row.getMODULOField())));
                row.setIST(Utils.convertToString(ds.parse(record.get("ISTANZA"), row.getISTField())));
                row.setISTANZA(Utils.convertToString(ds.parse(record.get("ISTANZA"), row.getISTANZAField())));
                row.setSTATO(Utils.convertToString(ds.parse(record.get("STATO"), row.getSTATOField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @30-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @30-FBBFEA54
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "MVAV".equals(name) && "url".equals(prefix) ) {
                param = urlMVAV;
            } else if ( "MVAV".equals(name) && prefix == null ) {
                param = urlMVAV;
            }
            if ( "GroupID".equals(name) && "ses".equals(prefix) ) {
                param = sesGroupID;
            } else if ( "GroupID".equals(name) && prefix == null ) {
                param = sesGroupID;
            }
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

//addGridDataObjectListener @30-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @30-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @30-238A81BB
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

//fireBeforeExecuteSelectEvent @30-9DA7B025
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

//fireAfterExecuteSelectEvent @30-F7E8A616
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

//class DataObject Tail @30-ED3F53A4
} // End of class DS
//End class DataObject Tail

