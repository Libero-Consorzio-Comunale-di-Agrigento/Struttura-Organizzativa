//PARAMETRI DataSource @6-F9AF9C0A
package amvadm.AdmRichiestaParametri;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End PARAMETRI DataSource

//class DataObject Header @6-6492639A
public class PARAMETRIDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @6-A03BE22E
    

    DoubleField ctrlID_RIC = new DoubleField(null, null);
    
    TextField ctrlNOME_PAR = new TextField(null, null);
    
    TextField ctrlVALORE = new TextField(null, null);
    
    TextField urlP_UTENTE = new TextField(null, null);
    
    TextField urlID = new TextField(null, null);
    

    private PARAMETRIRow row = new PARAMETRIRow();
    private boolean[] rowResults = null;
    private ArrayList[] rowErrors = null;
    private ArrayList rowError = null;
    private PARAMETRIRow[] rows = new PARAMETRIRow[20];

    private int pageSize;
    private int pageNum;

//End attributes of DataObject

//properties of DataObject @6-D4D8209F

    public void  setCtrlID_RIC( double param ) {
        this.ctrlID_RIC.setValue( param );
    }

    public void  setCtrlID_RIC( double param, Format ignore ) throws java.text.ParseException {
        this.ctrlID_RIC.setValue( param );
    }

    public void  setCtrlID_RIC( Object param, Format format ) throws java.text.ParseException {
        this.ctrlID_RIC.setValue( param, format );
    }

    public void  setCtrlID_RIC( Double param ) {
        this.ctrlID_RIC.setValue( param );
    }

    public void  setCtrlNOME_PAR( String param ) {
        this.ctrlNOME_PAR.setValue( param );
    }

    public void  setCtrlNOME_PAR( Object param ) {
        this.ctrlNOME_PAR.setValue( param );
    }

    public void  setCtrlNOME_PAR( Object param, Format ignore ) {
        this.ctrlNOME_PAR.setValue( param );
    }

    public void  setCtrlVALORE( String param ) {
        this.ctrlVALORE.setValue( param );
    }

    public void  setCtrlVALORE( Object param ) {
        this.ctrlVALORE.setValue( param );
    }

    public void  setCtrlVALORE( Object param, Format ignore ) {
        this.ctrlVALORE.setValue( param );
    }

    public void  setUrlP_UTENTE( String param ) {
        this.urlP_UTENTE.setValue( param );
    }

    public void  setUrlP_UTENTE( Object param ) {
        this.urlP_UTENTE.setValue( param );
    }

    public void  setUrlP_UTENTE( Object param, Format ignore ) {
        this.urlP_UTENTE.setValue( param );
    }

    public void  setUrlID( String param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlID( Object param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlID( Object param, Format ignore ) {
        this.urlID.setValue( param );
    }

    public PARAMETRIRow getRow() {
        return row;
    }

    public void setRow( PARAMETRIRow row ) {
        this.row = row;
    }

    public boolean[] getRowResults() {
        return rowResults;
    }

    public Collection[] getRowErrors() {
        return rowErrors;
    }

    public PARAMETRIRow[] getRows() {
        return rows;
    }

    public void setRows(PARAMETRIRow[] rows) {
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

//constructor @6-C790D37B
    public PARAMETRIDataObject(Page page) {
        super(page);
    }
//End constructor

//load @6-61D4003D
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select parametro nome_par, valore valore, parametro titolo,  "
                    + "'{ID}' id_ric from ad4_parametri_richiesta "
                    + "where id_richiesta = '{ID}' "
                    + "" );
        if ( StringUtils.isEmpty( (String) urlID.getObjectValue() ) ) urlID.setValue( "" );
        command.addParameter( "ID", urlID, null );
        command.setCountSql( "SELECT COUNT(*) FROM ( select parametro nome_par, valore valore, parametro titolo,  "
                                                         + "            '{ID}' id_ric from ad4_parametri_richiesta where id_richiesta = '{ID}'  ) cnt " );
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        } else {
            command.setOrder( "id_parametro" );
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

//loadDataBind @6-E3203C8C
        if ( records == null || ! records.hasMoreElements() ) {
            empty = true;
        } else {
            int counter = 0;
            while ( counter < rows.length && records.hasMoreElements() ) {
                PARAMETRIRow row = new PARAMETRIRow();
                DbRow record = (DbRow) records.nextElement();
                row.setNOME(Utils.convertToString(ds.parse(record.get("TITOLO"), row.getNOMEField())));
                row.setVALORE(Utils.convertToString(ds.parse(record.get("VALORE"), row.getVALOREField())));
                row.setNOME_PAR(Utils.convertToString(ds.parse(record.get("NOME_PAR"), row.getNOME_PARField())));
                row.setID_RIC(Utils.convertToString(ds.parse(record.get("ID_RIC"), row.getID_RICField())));
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

//updateGrid @6-5BA59CBF
    boolean updateGrid() {
        boolean isErrors = false;
        if ( rows == null ) return ( ! isErrors );
        rowResults = new boolean[rows.length];
        rowErrors = new ArrayList[rows.length];
        for( int i=0; i < rows.length; i++ ) {
            row = rows[i];
            rowError = new ArrayList();
            if ( row.isApply() ) {
                
                
                    rowResults[i] = update();
                    rowErrors[i] = new ArrayList(rowError);
                
            } else {
                rowResults[i] = false;
            }
        }
//End updateGrid

//End of updateGrid @6-F575E732
        return ( ! isErrors );
    }
//End End of updateGrid

//update @6-60895272
        boolean update() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMV_UTENTE.SET_PARAMETRO_RICHIESTA ( ?, ?, ?, ? ) }" );
            command.addParameter( "P_ID_RICHIESTA", row.getID_RICField(), java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) row.getNOME_PAR()) ) row.setNOME_PAR( "" );
            command.addParameter( "P_NOME", row.getNOME_PARField(), java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) row.getVALORE()) ) row.setVALORE( "" );
            command.addParameter( "P_VALORE", row.getVALOREField(), java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) urlP_UTENTE.getObjectValue() ) ) urlP_UTENTE.setValue( "" );
            command.addParameter( "P_UTENTE", urlP_UTENTE, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );

            fireBeforeBuildUpdateEvent( new DataObjectEvent(command) );


//End update

//updateDataBound @6-BB1231DF
            fireBeforeExecuteUpdateEvent( new DataObjectEvent(command) );

            Enumeration records = null;
            if ( ! ds.hasErrors() ) {
                records = command.getRows();
            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteUpdateEvent( new DataObjectEvent(command) );

//End updateDataBound

//End of update @6-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of update

//getParameterByName @6-1040673D
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "ID_RIC".equals(name) && "ctrl".equals(prefix) ) {
                param = ctrlID_RIC;
            } else if ( "ID_RIC".equals(name) && prefix == null ) {
                param = ctrlID_RIC;
            }
            if ( "NOME_PAR".equals(name) && "ctrl".equals(prefix) ) {
                param = ctrlNOME_PAR;
            } else if ( "NOME_PAR".equals(name) && prefix == null ) {
                param = ctrlNOME_PAR;
            }
            if ( "VALORE".equals(name) && "ctrl".equals(prefix) ) {
                param = ctrlVALORE;
            } else if ( "VALORE".equals(name) && prefix == null ) {
                param = ctrlVALORE;
            }
            if ( "P_UTENTE".equals(name) && "url".equals(prefix) ) {
                param = urlP_UTENTE;
            } else if ( "P_UTENTE".equals(name) && prefix == null ) {
                param = urlP_UTENTE;
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

//addRecordDataObjectListener @6-25514F84
    public synchronized void addEditableGridDataObjectListener( EditableGridDataObjectListener l ) {
        listeners.addElement(l);
    }
//End addRecordDataObjectListener

//removeRecordDataObjectListener @6-9D4236FF
    public synchronized void removeEditableGridDataObjectListener( EditableGridDataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeRecordDataObjectListener

//fireBeforeBuildSelectEvent @6-4379EB32
    public void fireBeforeBuildSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).beforeBuildSelect(e);
        }
    }
//End fireBeforeBuildSelectEvent

//fireBeforeExecuteSelectEvent @6-E42AFD15
    public void fireBeforeExecuteSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).beforeExecuteSelect(e);
        }
    }
//End fireBeforeExecuteSelectEvent

//fireAfterExecuteSelectEvent @6-5BEEEBAA
    public void fireAfterExecuteSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).afterExecuteSelect(e);
        }
    }
//End fireAfterExecuteSelectEvent

//fireBeforeBuildInsertEvent @6-810ECF3B
    public void fireBeforeBuildInsertEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).beforeBuildInsert(e);
        }
    }
//End fireBeforeBuildInsertEvent

//fireBeforeExecuteInsertEvent @6-4FFDC8FC
    public void fireBeforeExecuteInsertEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).beforeExecuteInsert(e);
        }
    }
//End fireBeforeExecuteInsertEvent

//fireAfterExecuteInsertEvent @6-F8354FEE
    public void fireAfterExecuteInsertEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).afterExecuteInsert(e);
        }
    }
//End fireAfterExecuteInsertEvent

//fireBeforeBuildSelectEvent @6-AEB290C0
    public void fireBeforeBuildUpdateEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).beforeBuildUpdate(e);
        }
    }
//End fireBeforeBuildSelectEvent

//fireBeforeExecuteSelectEvent @6-55F1DF2C
    public void fireBeforeExecuteUpdateEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).beforeExecuteUpdate(e);
        }
    }
//End fireBeforeExecuteSelectEvent

//fireAfterExecuteSelectEvent @6-3E06DA3B
    public void fireAfterExecuteUpdateEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).afterExecuteUpdate(e);
        }
    }
//End fireAfterExecuteSelectEvent

//fireBeforeBuildSelectEvent @6-0BC3DBB0
    public void fireBeforeBuildDeleteEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).beforeBuildDelete(e);
        }
    }
//End fireBeforeBuildSelectEvent

//fireBeforeExecuteDeleteEvent @6-79A78EFE
    public void fireBeforeExecuteDeleteEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).beforeExecuteDelete(e);
        }
    }
//End fireBeforeExecuteDeleteEvent

//fireAfterExecuteDeleteEvent @6-2683A622
    public void fireAfterExecuteDeleteEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((EditableGridDataObjectListener)v.elementAt(i)).afterExecuteDelete(e);
        }
    }
//End fireAfterExecuteDeleteEvent

//class DataObject Tail @6-ED3F53A4
} // End of class DS
//End class DataObject Tail

