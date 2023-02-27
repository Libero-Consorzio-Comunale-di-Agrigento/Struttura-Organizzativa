//UTENTE_CONTROL DataSource @2-38918A07
package common.AmvUtenteNominativo_i;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End UTENTE_CONTROL DataSource

//class DataObject Header @2-9D69A28D
public class UTENTE_CONTROLDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @2-8F1B6678
    

    TextField urlIDUTE = new TextField(null, null);
    
    TextField sesMVUTE = new TextField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    TextField sesProgetto = new TextField(null, null);
    
    TextField sesGroupID = new TextField(null, null);
    

    private UTENTE_CONTROLRow[] rows = new UTENTE_CONTROLRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @2-559E97C7

    public void  setUrlIDUTE( String param ) {
        this.urlIDUTE.setValue( param );
    }

    public void  setUrlIDUTE( Object param ) {
        this.urlIDUTE.setValue( param );
    }

    public void  setUrlIDUTE( Object param, Format ignore ) {
        this.urlIDUTE.setValue( param );
    }

    public void  setSesMVUTE( String param ) {
        this.sesMVUTE.setValue( param );
    }

    public void  setSesMVUTE( Object param ) {
        this.sesMVUTE.setValue( param );
    }

    public void  setSesMVUTE( Object param, Format ignore ) {
        this.sesMVUTE.setValue( param );
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

    public void  setSesProgetto( String param ) {
        this.sesProgetto.setValue( param );
    }

    public void  setSesProgetto( Object param ) {
        this.sesProgetto.setValue( param );
    }

    public void  setSesProgetto( Object param, Format ignore ) {
        this.sesProgetto.setValue( param );
    }

    public void  setSesGroupID( String param ) {
        this.sesGroupID.setValue( param );
    }

    public void  setSesGroupID( Object param ) {
        this.sesGroupID.setValue( param );
    }

    public void  setSesGroupID( Object param, Format ignore ) {
        this.sesGroupID.setValue( param );
    }

    public UTENTE_CONTROLRow[] getRows() {
        return rows;
    }

    public void setRows(UTENTE_CONTROLRow[] rows) {
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

//constructor @2-8DFCF6C2
    public UTENTE_CONTROLDataObject(Page page) {
        super(page);
        addDataObjectListener( new UTENTE_CONTROLDataObjectHandler() );
    }
//End constructor

//load @2-6EB5BD05
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT decode(max(u.tipo_utente),'G',  "
                    + "'Gruppo','Utente')||' : '||nvl(max(u.NOMINATIVO),'- non disponibile -') NOMINATIVO "
                    + ",  "
                    + "max(u.utente) UTENTE "
                    + "FROM AD4_UTENTI u "
                    + "WHERE u.UTENTE = nvl('{IDUTE}','{MVUTE}') "
                    + "AND AMV_UTENTE.IS_UTENTE_VALIDO(nvl('{IDUTE}','{MVUTE}'),'{Utente}','{Progetto}','{GroupID}')= 1" );
        if ( StringUtils.isEmpty( (String) urlIDUTE.getObjectValue() ) ) urlIDUTE.setValue( "" );
        command.addParameter( "IDUTE", urlIDUTE, null );
        if ( StringUtils.isEmpty( (String) sesMVUTE.getObjectValue() ) ) sesMVUTE.setValue( "" );
        command.addParameter( "MVUTE", sesMVUTE, null );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "" );
        command.addParameter( "Progetto", sesProgetto, null );
        if ( StringUtils.isEmpty( (String) sesGroupID.getObjectValue() ) ) sesGroupID.setValue( "" );
        command.addParameter( "GroupID", sesGroupID, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( SELECT decode(max(u.tipo_utente),'G',  "
                                                         + "            'Gruppo','Utente')||' : '||nvl(max(u.NOMINATIVO),'- non disponibile -') NOMINATIVO ,  "
                                                         + "            max(u.utente) UTENTE FROM AD4_UTENTI u WHERE u.UTENTE = nvl('{IDUTE}','{MVUTE}') AND AMV_UTENTE.IS_UTENTE_VALIDO(nvl('{IDUTE}','{MVUTE}'),'{Utente}','{Progetto}','{GroupID}')= 1 ) cnt " );
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

//loadDataBind @2-E991A0F5
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                UTENTE_CONTROLRow row = new UTENTE_CONTROLRow();
                DbRow record = (DbRow) records.nextElement();
                row.setNOMINATIVO(Utils.convertToString(ds.parse(record.get("NOMINATIVO"), row.getNOMINATIVOField())));
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

//getParameterByName @2-0447C14E
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "IDUTE".equals(name) && "url".equals(prefix) ) {
                param = urlIDUTE;
            } else if ( "IDUTE".equals(name) && prefix == null ) {
                param = urlIDUTE;
            }
            if ( "MVUTE".equals(name) && "ses".equals(prefix) ) {
                param = sesMVUTE;
            } else if ( "MVUTE".equals(name) && prefix == null ) {
                param = sesMVUTE;
            }
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "Progetto".equals(name) && "ses".equals(prefix) ) {
                param = sesProgetto;
            } else if ( "Progetto".equals(name) && prefix == null ) {
                param = sesProgetto;
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

