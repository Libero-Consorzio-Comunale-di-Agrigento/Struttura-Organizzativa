//AD4_UTENTI DataSource @74-1EB0F2B5
package amvadm.AdmGruppoUtenti;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_UTENTI DataSource

//class DataObject Header @74-587BC4AB
public class AD4_UTENTIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @74-09A4B2DC
    

    TextField urlID = new TextField(null, null);
    
    TextField urlS_TESTO = new TextField(null, null);
    
    TextField sesProgetto = new TextField(null, null);
    
    TextField sesIstanza = new TextField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    LongField sesGroupID = new LongField(null, null);
    
    TextField urlRICERCA = new TextField(null, null);
    

    private AD4_UTENTIRow[] rows = new AD4_UTENTIRow[100];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @74-22DB9DF5

    public void  setUrlID( String param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlID( Object param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlID( Object param, Format ignore ) {
        this.urlID.setValue( param );
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

    public void  setSesProgetto( String param ) {
        this.sesProgetto.setValue( param );
    }

    public void  setSesProgetto( Object param ) {
        this.sesProgetto.setValue( param );
    }

    public void  setSesProgetto( Object param, Format ignore ) {
        this.sesProgetto.setValue( param );
    }

    public void  setSesIstanza( String param ) {
        this.sesIstanza.setValue( param );
    }

    public void  setSesIstanza( Object param ) {
        this.sesIstanza.setValue( param );
    }

    public void  setSesIstanza( Object param, Format ignore ) {
        this.sesIstanza.setValue( param );
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

    public void  setUrlRICERCA( String param ) {
        this.urlRICERCA.setValue( param );
    }

    public void  setUrlRICERCA( Object param ) {
        this.urlRICERCA.setValue( param );
    }

    public void  setUrlRICERCA( Object param, Format ignore ) {
        this.urlRICERCA.setValue( param );
    }

    public AD4_UTENTIRow[] getRows() {
        return rows;
    }

    public void setRows(AD4_UTENTIRow[] rows) {
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

//constructor @74-BB1D6425
    public AD4_UTENTIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @74-4369D458
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT distinct u.utente "
                    + ",  "
                    + "u.nominativo||decode(u.tipo_utente,'U','',' ('||u.tipo_utente||')') nominativo "
                    + ",  "
                    + "AMV_UTENTE.get_gruppi(u.utente,'{Utente}') gruppi "
                    + "from ad4_utenti u "
                    + ", ad4_utenti_gruppo ug "
                    + ", ad4_utenti u1 "
                    + ", ad4_diritti_accesso d1 "
                    + ",  "
                    + "ad4_moduli m "
                    + ", ad4_diritti_accesso d2 "
                    + ",  "
                    + "ad4_ruoli r "
                    + "where ug.gruppo  = nvl('{ID}',  "
                    + "ug.gruppo)   "
                    + "and ug.utente = u.utente "
                    + "and ug.gruppo = u1.utente "
                    + "and m.progetto = '{Progetto}' "
                    + "and d1.istanza = d2.istanza "
                    + "and d1.utente = '{Utente}' "
                    + "and r.ruolo = d1.ruolo "
                    + "and nvl(r.profilo,-1) = nvl({GroupID},-1) "
                    + "and d1.modulo = m.modulo "
                    + "and d2.modulo = d1.modulo "
                    + "and d2.utente = u.utente "
                    + "and u.nominativo like upper('{s_TESTO}%') "
                    + "and '{RICERCA}' = 'S' "
                    + "" );
        if ( StringUtils.isEmpty( (String) urlID.getObjectValue() ) ) urlID.setValue( "" );
        command.addParameter( "ID", urlID, null );
        if ( StringUtils.isEmpty( (String) urlS_TESTO.getObjectValue() ) ) urlS_TESTO.setValue( "" );
        command.addParameter( "s_TESTO", urlS_TESTO, null );
        if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "" );
        command.addParameter( "Progetto", sesProgetto, null );
        if ( StringUtils.isEmpty( (String) sesIstanza.getObjectValue() ) ) sesIstanza.setValue( "" );
        command.addParameter( "Istanza", sesIstanza, null );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( sesGroupID.getObjectValue() == null ) sesGroupID.setValue( null );
        command.addParameter( "GroupID", sesGroupID, null );
        if ( StringUtils.isEmpty( (String) urlRICERCA.getObjectValue() ) ) urlRICERCA.setValue( "" );
        command.addParameter( "RICERCA", urlRICERCA, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT distinct u.utente ,  "
                                                         + "            u.nominativo||decode(u.tipo_utente,'U','',' ('||u.tipo_utente||')') nominativo ,  "
                                                         + "            AMV_UTENTE.get_gruppi(u.utente,'{Utente}') gruppi from ad4_utenti u , ad4_utenti_gruppo ug , ad4_utenti u1 ,  "
                                                         + "            ad4_diritti_accesso d1 , ad4_moduli m , ad4_diritti_accesso d2 ,  "
                                                         + "            ad4_ruoli r where ug.gruppo = nvl('{ID}',  "
                                                         + "            ug.gruppo) and ug.utente = u.utente and ug.gruppo = u1.utente and m.progetto = '{Progetto}' and d1.istanza = d2.istanza and d1.utente = '{Utente}' and r.ruolo = d1.ruolo and nvl(r.profilo,-1) = nvl({GroupID},-1) and d1.modulo = m.modulo and d2.modulo = d1.modulo and d2.utente = u.utente and u.nominativo like upper('{s_TESTO}%') and '{RICERCA}' = 'S'  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "2" );
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

//loadDataBind @74-2826A077
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AD4_UTENTIRow row = new AD4_UTENTIRow();
                DbRow record = (DbRow) records.nextElement();
                row.setNOMINATIVO(Utils.convertToString(ds.parse(record.get("NOMINATIVO"), row.getNOMINATIVOField())));
                row.setGRUPPI(Utils.convertToString(ds.parse(record.get("GRUPPI"), row.getGRUPPIField())));
                row.setIDUTE(Utils.convertToString(ds.parse(record.get("UTENTE"), row.getIDUTEField())));
                row.setUTENTE(Utils.convertToString(ds.parse(record.get("UTENTE"), row.getUTENTEField())));
                rows[counter++] = row;
            }
        }
//End loadDataBind

//End of load @74-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @74-D7BAADEC
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "ID".equals(name) && "url".equals(prefix) ) {
                param = urlID;
            } else if ( "ID".equals(name) && prefix == null ) {
                param = urlID;
            }
            if ( "s_TESTO".equals(name) && "url".equals(prefix) ) {
                param = urlS_TESTO;
            } else if ( "s_TESTO".equals(name) && prefix == null ) {
                param = urlS_TESTO;
            }
            if ( "Progetto".equals(name) && "ses".equals(prefix) ) {
                param = sesProgetto;
            } else if ( "Progetto".equals(name) && prefix == null ) {
                param = sesProgetto;
            }
            if ( "Istanza".equals(name) && "ses".equals(prefix) ) {
                param = sesIstanza;
            } else if ( "Istanza".equals(name) && prefix == null ) {
                param = sesIstanza;
            }
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "GroupID".equals(name) && "ses".equals(prefix) ) {
                param = sesGroupID;
            } else if ( "GroupID".equals(name) && prefix == null ) {
                param = sesGroupID;
            }
            if ( "RICERCA".equals(name) && "url".equals(prefix) ) {
                param = urlRICERCA;
            } else if ( "RICERCA".equals(name) && prefix == null ) {
                param = urlRICERCA;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addGridDataObjectListener @74-B1E4C7C7
    public synchronized void addDataObjectListener( DataObjectListener l ) {
        listeners.addElement(l);
    }
//End addGridDataObjectListener

//removeGridDataObjectListener @74-9F30CEFB
    public synchronized void removeDataObjectListener( DataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeGridDataObjectListener

//fireBeforeBuildSelectEvent @74-238A81BB
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

//fireBeforeExecuteSelectEvent @74-9DA7B025
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

//fireAfterExecuteSelectEvent @74-F7E8A616
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

//class DataObject Tail @74-ED3F53A4
} // End of class DS
//End class DataObject Tail

