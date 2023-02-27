//AD4_UTENTI DataSource @5-2CD539AA
package amvadm.AdmGruppiElenco;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_UTENTI DataSource

//class DataObject Header @5-587BC4AB
public class AD4_UTENTIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @5-77A8EBA7
    

    TextField urlS_TESTO = new TextField(null, null);
    
    TextField sesProgetto = new TextField(null, null);
    
    TextField sesIstanza = new TextField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    LongField sesGroupID = new LongField(null, null);
    

    private AD4_UTENTIRow[] rows = new AD4_UTENTIRow[100];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @5-087C6CD9

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

//constructor @5-BB1D6425
    public AD4_UTENTIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @5-A2822EA1
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select distinct u.nominativo nome_gruppo "
                    + ", ug.gruppo "
                    + ",  "
                    + "AMV_UTENTE.GET_DIRITTI_ACCESSO(ug.gruppo,'{Utente}','{Istanza}','{Progetto}','{GroupID}') diritti "
                    + "from AD4_UTENTI_GRUPPO ug, AD4_UTENTI u "
                    + ", AD4_DIRITTI_ACCESSO d, AD4_MODULI m "
                    + "where ug.utente = d.utente "
                    + "and u.utente = upper(ug.gruppo) "
                    + "and d.modulo = m.modulo "
                    + "and m.progetto = '{Progetto}' "
                    + "and u.nominativo like '{s_TESTO}%' "
                    + "" );
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
        command.setCountSql( "SELECT COUNT(*) FROM ( select distinct u.nominativo nome_gruppo , ug.gruppo ,  "
                                                         + "            AMV_UTENTE.GET_DIRITTI_ACCESSO(ug.gruppo,'{Utente}','{Istanza}','{Progetto}','{GroupID}') diritti from AD4_UTENTI_GRUPPO ug, AD4_UTENTI u , AD4_DIRITTI_ACCESSO d, AD4_MODULI m where ug.utente = d.utente and u.utente = upper(ug.gruppo) and d.modulo = m.modulo and m.progetto = '{Progetto}' and u.nominativo like '{s_TESTO}%'  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "u.nominativo" );
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

//loadDataBind @5-6D341F4A
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AD4_UTENTIRow row = new AD4_UTENTIRow();
                DbRow record = (DbRow) records.nextElement();
                row.setNOME_GRUPPO(Utils.convertToString(ds.parse(record.get("NOME_GRUPPO"), row.getNOME_GRUPPOField())));
                row.setDIRITTI(Utils.convertToString(ds.parse(record.get("DIRITTI"), row.getDIRITTIField())));
                row.setIDUTE(Utils.convertToString(ds.parse(record.get("GRUPPO"), row.getIDUTEField())));
                row.setGRUPPO(Utils.convertToString(ds.parse(record.get("GRUPPO"), row.getGRUPPOField())));
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

//getParameterByName @5-01FEA650
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
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

