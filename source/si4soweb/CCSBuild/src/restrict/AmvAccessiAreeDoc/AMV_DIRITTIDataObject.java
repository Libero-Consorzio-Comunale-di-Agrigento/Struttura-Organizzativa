//AMV_DIRITTI DataSource @6-2F7C4758
package restrict.AmvAccessiAreeDoc;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AMV_DIRITTI DataSource

//class DataObject Header @6-358C4BCD
public class AMV_DIRITTIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @6-EB865C09
    

    TextField sesUtente = new TextField(null, null);
    

    private AMV_DIRITTIRow[] rows = new AMV_DIRITTIRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @6-2D9CF662

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
    }

    public AMV_DIRITTIRow[] getRows() {
        return rows;
    }

    public void setRows(AMV_DIRITTIRow[] rows) {
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

//constructor @6-094BB49F
    public AMV_DIRITTIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @6-0934F61F
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select nvl(aree.nome, '(Tutte)') area "
                    + ", nvl(tipo.nome, '(Tutte)')      tipologia "
                    + ",  "
                    + "decode(diri.accesso "
                    + "        , 'R', 'Lettura' "
                    + "        , 'C',  "
                    + "'Creazione' "
                    + "        , 'U', 'Modifica' "
                    + "             , diri.accesso "
                    + "        ) des_accesso "
                    + ",  "
                    + "nvl(grup.nominativo, '(Tutti)') gruppo "
                    + "from AMV_DIRITTI   diri "
                    + "   ,  "
                    + "AMV_AREE      aree "
                    + "   , AMV_TIPOLOGIE tipo "
                    + "   ,  "
                    + "AD4_UTENTI    grup "
                    + "where aree.id_area (+)      = diri.id_area "
                    + "  and tipo.id_tipologia (+) = diri.id_tipologia "
                    + "  and grup.utente (+)       = diri.gruppo "
                    + "  and diri.gruppo in  "
                    + "(select gruppo  "
                    + "   from AD4_UTENTI_GRUPPO "
                    + "  where utente = '{Utente}' "
                    + ") "
                    + "" );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select nvl(aree.nome, '(Tutte)') area , nvl(tipo.nome, '(Tutte)') tipologia ,  "
                                                         + "            decode(diri.accesso , 'R', 'Lettura' , 'C', 'Creazione' , 'U',  "
                                                         + "            'Modifica' , diri.accesso ) des_accesso , nvl(grup.nominativo,  "
                                                         + "            '(Tutti)') gruppo from AMV_DIRITTI diri , AMV_AREE aree , AMV_TIPOLOGIE tipo ,  "
                                                         + "            AD4_UTENTI grup where aree.id_area (+) = diri.id_area and tipo.id_tipologia (+) = diri.id_tipologia and grup.utente (+) = diri.gruppo and diri.gruppo in (select gruppo from AD4_UTENTI_GRUPPO where utente = '{Utente}' )  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "diri.id_area , diri.id_tipologia 	 , decode(diri.accesso, 'R', 3, 'C', 2, 'U', 1, 4)" );
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

//loadDataBind @6-4A1A4E68
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                AMV_DIRITTIRow row = new AMV_DIRITTIRow();
                DbRow record = (DbRow) records.nextElement();
                row.setAREA(Utils.convertToString(ds.parse(record.get("AREA"), row.getAREAField())));
                row.setTIPOLOGIA(Utils.convertToString(ds.parse(record.get("TIPOLOGIA"), row.getTIPOLOGIAField())));
                row.setDES_ACCESSO(Utils.convertToString(ds.parse(record.get("DES_ACCESSO"), row.getDES_ACCESSOField())));
                row.setGRUPPO(Utils.convertToString(ds.parse(record.get("GRUPPO"), row.getGRUPPOField())));
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

