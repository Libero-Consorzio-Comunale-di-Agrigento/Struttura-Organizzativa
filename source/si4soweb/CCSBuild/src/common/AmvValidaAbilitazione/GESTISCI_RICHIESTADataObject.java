//GESTISCI_RICHIESTA DataSource @7-E8690D14
package common.AmvValidaAbilitazione;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End GESTISCI_RICHIESTA DataSource

//class DataObject Header @7-FCE7818F
public class GESTISCI_RICHIESTADataObject extends DS {
//End class DataObject Header

//attributes of DataObject @7-E00D0A8F
    

    DoubleField sesMVRIC = new DoubleField(null, null);
    
    TextField exprKey21 = new TextField(null, null);
    
    TextField sesMVPWD = new TextField(null, null);
    

    private GESTISCI_RICHIESTARow row = new GESTISCI_RICHIESTARow();

//End attributes of DataObject

//properties of DataObject @7-5845D5CA

    public void  setSesMVRIC( double param ) {
        this.sesMVRIC.setValue( param );
    }

    public void  setSesMVRIC( double param, Format ignore ) throws java.text.ParseException {
        this.sesMVRIC.setValue( param );
    }

    public void  setSesMVRIC( Object param, Format format ) throws java.text.ParseException {
        this.sesMVRIC.setValue( param, format );
    }

    public void  setSesMVRIC( Double param ) {
        this.sesMVRIC.setValue( param );
    }

    public void  setExprKey21( String param ) {
        this.exprKey21.setValue( param );
    }

    public void  setExprKey21( Object param ) {
        this.exprKey21.setValue( param );
    }

    public void  setExprKey21( Object param, Format ignore ) {
        this.exprKey21.setValue( param );
    }

    public void  setSesMVPWD( String param ) {
        this.sesMVPWD.setValue( param );
    }

    public void  setSesMVPWD( Object param ) {
        this.sesMVPWD.setValue( param );
    }

    public void  setSesMVPWD( Object param, Format ignore ) {
        this.sesMVPWD.setValue( param );
    }

    public GESTISCI_RICHIESTARow getRow() {
        return row;
    }

    public void setRow( GESTISCI_RICHIESTARow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @7-2CD742F2
    public GESTISCI_RICHIESTADataObject(Page page) {
        super(page);
    }
//End constructor

//load @7-95826162
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT decode('{MVPWD}',null,'<strong>'||AD4_SOGGETTO.GET_NOME(s.SOGGETTO,'Y')||'</strong>','Registrazione al servizio per l''utente <strong>'||u.NOMINATIVO||' </strong>.') NOMINATIVO "
                    + ",  "
                    + "m.DESCRIZIONE||' - '||i.DESCRIZIONE SERVIZIO "
                    + "FROM AD4_UTENTI u, AD4_UTENTI_SOGGETTI s, AD4_MODULI m, AD4_ISTANZE i,  "
                    + "AD4_RICHIESTE_ABILITAZIONE r "
                    + "WHERE u.UTENTE = r.utente "
                    + "AND s.utente = u.utente "
                    + "AND m.modulo = r.modulo "
                    + "AND i.istanza = r.istanza "
                    + "AND r.id_richiesta = {MVRIC}" );
        if ( sesMVRIC.getObjectValue() == null ) sesMVRIC.setValue( 0 );
        command.addParameter( "MVRIC", sesMVRIC, null );
        if ( StringUtils.isEmpty( (String) sesMVPWD.getObjectValue() ) ) sesMVPWD.setValue( "" );
        command.addParameter( "MVPWD", sesMVPWD, null );
        if ( ! command.isSetAllParams() ) {
            empty = true;
            ds.closeConnection();
            return true;
        }
        if ( ! StringUtils.isEmpty( orderBy ) ) {
            command.setOrder( orderBy );
        }

        fireBeforeBuildSelectEvent( new DataObjectEvent(command) );


        fireBeforeExecuteSelectEvent( new DataObjectEvent(command) );

        DbRow record = null;
        if ( ! ds.hasErrors() ) {
            record = command.getOneRow();
        }

        CCLogger.getInstance().debug(command.toString());

        fireAfterExecuteSelectEvent( new DataObjectEvent(command) );

        ds.closeConnection();
//End load

//loadDataBind @7-3235E50D
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
        }
//End loadDataBind

//End of load @7-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//update @7-3AD10FBB
        boolean update() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMV_UTENTE.GESTISCI_RICHIESTA ( ?, ? ) }" );
            command.addParameter( "P_RICHIESTA", sesMVRIC, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) exprKey21.getObjectValue() ) ) exprKey21.setValue( "" );
            command.addParameter( "P_TIPO_CONVALIDA", exprKey21, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );

            fireBeforeBuildUpdateEvent( new DataObjectEvent(command) );


//End update

//updateDataBound @7-0130DCE2
            fireBeforeExecuteUpdateEvent( new DataObjectEvent(command) );

            if ( ! ds.hasErrors() ) {
                command.executeUpdate();
            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteUpdateEvent( new DataObjectEvent(command) );

//End updateDataBound

//End of update @7-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of update

//getParameterByName @7-379A92CC
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "MVRIC".equals(name) && "ses".equals(prefix) ) {
                param = sesMVRIC;
            } else if ( "MVRIC".equals(name) && prefix == null ) {
                param = sesMVRIC;
            }
            if ( "exprKey21".equals(name) && "expr".equals(prefix) ) {
                param = exprKey21;
            } else if ( "exprKey21".equals(name) && prefix == null ) {
                param = exprKey21;
            }
            if ( "MVPWD".equals(name) && "ses".equals(prefix) ) {
                param = sesMVPWD;
            } else if ( "MVPWD".equals(name) && prefix == null ) {
                param = sesMVPWD;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addRecordDataObjectListener @7-47141785
    public synchronized void addRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.addElement(l);
    }
//End addRecordDataObjectListener

//removeRecordDataObjectListener @7-A1ABC1F4
    public synchronized void removeRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeRecordDataObjectListener

//fireBeforeBuildSelectEvent @7-305A023C
    public void fireBeforeBuildSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeBuildSelect(e);
        }
    }
//End fireBeforeBuildSelectEvent

//fireBeforeExecuteSelectEvent @7-D00ACF95
    public void fireBeforeExecuteSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeExecuteSelect(e);
        }
    }
//End fireBeforeExecuteSelectEvent

//fireAfterExecuteSelectEvent @7-3BAD39CE
    public void fireAfterExecuteSelectEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).afterExecuteSelect(e);
        }
    }
//End fireAfterExecuteSelectEvent

//fireBeforeBuildInsertEvent @7-FBA08B71
    public void fireBeforeBuildInsertEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeBuildInsert(e);
        }
    }
//End fireBeforeBuildInsertEvent

//fireBeforeExecuteInsertEvent @7-47AFA6A5
    public void fireBeforeExecuteInsertEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeExecuteInsert(e);
        }
    }
//End fireBeforeExecuteInsertEvent

//fireAfterExecuteInsertEvent @7-E9CE95AE
    public void fireAfterExecuteInsertEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).afterExecuteInsert(e);
        }
    }
//End fireAfterExecuteInsertEvent

//fireBeforeBuildSelectEvent @7-2405BE8B
    public void fireBeforeBuildUpdateEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeBuildUpdate(e);
        }
    }
//End fireBeforeBuildSelectEvent

//fireBeforeExecuteSelectEvent @7-E9DFF86B
    public void fireBeforeExecuteUpdateEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeExecuteUpdate(e);
        }
    }
//End fireBeforeExecuteSelectEvent

//fireAfterExecuteSelectEvent @7-580A2987
    public void fireAfterExecuteUpdateEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).afterExecuteUpdate(e);
        }
    }
//End fireAfterExecuteSelectEvent

//fireBeforeBuildSelectEvent @7-D021D0EA
    public void fireBeforeBuildDeleteEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeBuildDelete(e);
        }
    }
//End fireBeforeBuildSelectEvent

//fireBeforeExecuteDeleteEvent @7-DD540FBB
    public void fireBeforeExecuteDeleteEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).beforeExecuteDelete(e);
        }
    }
//End fireBeforeExecuteDeleteEvent

//fireAfterExecuteDeleteEvent @7-2A6E2049
    public void fireAfterExecuteDeleteEvent( DataObjectEvent e ) {
        Vector v;
        e.setDataSource( this );
        e.setSource(model);
        synchronized(this) {v = (Vector)listeners.clone();}
        for (int i = 0; i < v.size(); i++) {
            ((RecordDataObjectListener)v.elementAt(i)).afterExecuteDelete(e);
        }
    }
//End fireAfterExecuteDeleteEvent

//class DataObject Tail @7-ED3F53A4
} // End of class DS
//End class DataObject Tail

