//Ruolo DataSource @6-93188AC4
package amvadm.AdmMenu;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End Ruolo DataSource

//class DataObject Header @6-F9324714
public class RuoloDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @6-114E12D8
    

    TextField sesMVSM = new TextField(null, null);
    
    TextField sesMVSR = new TextField(null, null);
    
    TextField sesModulo = new TextField(null, null);
    
    TextField sesProgetto = new TextField(null, null);
    
    TextField sesMVSP = new TextField(null, null);
    

    private RuoloRow row = new RuoloRow();

//End attributes of DataObject

//properties of DataObject @6-19E891A7

    public void  setSesMVSM( String param ) {
        this.sesMVSM.setValue( param );
    }

    public void  setSesMVSM( Object param ) {
        this.sesMVSM.setValue( param );
    }

    public void  setSesMVSM( Object param, Format ignore ) {
        this.sesMVSM.setValue( param );
    }

    public void  setSesMVSR( String param ) {
        this.sesMVSR.setValue( param );
    }

    public void  setSesMVSR( Object param ) {
        this.sesMVSR.setValue( param );
    }

    public void  setSesMVSR( Object param, Format ignore ) {
        this.sesMVSR.setValue( param );
    }

    public void  setSesModulo( String param ) {
        this.sesModulo.setValue( param );
    }

    public void  setSesModulo( Object param ) {
        this.sesModulo.setValue( param );
    }

    public void  setSesModulo( Object param, Format ignore ) {
        this.sesModulo.setValue( param );
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

    public void  setSesMVSP( String param ) {
        this.sesMVSP.setValue( param );
    }

    public void  setSesMVSP( Object param ) {
        this.sesMVSP.setValue( param );
    }

    public void  setSesMVSP( Object param, Format ignore ) {
        this.sesMVSP.setValue( param );
    }

    public RuoloRow getRow() {
        return row;
    }

    public void setRow( RuoloRow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @6-56D8F3B2
    public RuoloDataObject(Page page) {
        super(page);
    }
//End constructor

//load @6-0DC10F5F
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select  "
                    + "'{MVSM}' modulo_sel "
                    + ", '{MVSR}' ruolo_sel "
                    + ",  "
                    + "'{MVSP}' progetto_sel from dual" );
        if ( StringUtils.isEmpty( (String) sesMVSM.getObjectValue() ) ) sesMVSM.setValue( "" );
        command.addParameter( "MVSM", sesMVSM, null );
        if ( StringUtils.isEmpty( (String) sesMVSR.getObjectValue() ) ) sesMVSR.setValue( "" );
        command.addParameter( "MVSR", sesMVSR, null );
        if ( StringUtils.isEmpty( (String) sesModulo.getObjectValue() ) ) sesModulo.setValue( "" );
        command.addParameter( "Modulo", sesModulo, null );
        if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "" );
        command.addParameter( "Progetto", sesProgetto, null );
        if ( StringUtils.isEmpty( (String) sesMVSP.getObjectValue() ) ) sesMVSP.setValue( "" );
        command.addParameter( "MVSP", sesMVSP, null );
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

//loadDataBind @6-5AF60595
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setSP(Utils.convertToString(ds.parse(record.get("PROGETTO_SEL"), row.getSPField())));
            row.setSM(Utils.convertToString(ds.parse(record.get("MODULO_SEL"), row.getSMField())));
            row.setSR(Utils.convertToString(ds.parse(record.get("RUOLO_SEL"), row.getSRField())));
        }
//End loadDataBind

//End of load @6-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//getParameterByName @6-2F956E73
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "MVSM".equals(name) && "ses".equals(prefix) ) {
                param = sesMVSM;
            } else if ( "MVSM".equals(name) && prefix == null ) {
                param = sesMVSM;
            }
            if ( "MVSR".equals(name) && "ses".equals(prefix) ) {
                param = sesMVSR;
            } else if ( "MVSR".equals(name) && prefix == null ) {
                param = sesMVSR;
            }
            if ( "Modulo".equals(name) && "ses".equals(prefix) ) {
                param = sesModulo;
            } else if ( "Modulo".equals(name) && prefix == null ) {
                param = sesModulo;
            }
            if ( "Progetto".equals(name) && "ses".equals(prefix) ) {
                param = sesProgetto;
            } else if ( "Progetto".equals(name) && prefix == null ) {
                param = sesProgetto;
            }
            if ( "MVSP".equals(name) && "ses".equals(prefix) ) {
                param = sesMVSP;
            } else if ( "MVSP".equals(name) && prefix == null ) {
                param = sesMVSP;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addRecordDataObjectListener @6-47141785
    public synchronized void addRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.addElement(l);
    }
//End addRecordDataObjectListener

//removeRecordDataObjectListener @6-A1ABC1F4
    public synchronized void removeRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeRecordDataObjectListener

//fireBeforeBuildSelectEvent @6-305A023C
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

//fireBeforeExecuteSelectEvent @6-D00ACF95
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

//fireAfterExecuteSelectEvent @6-3BAD39CE
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

//fireBeforeBuildInsertEvent @6-FBA08B71
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

//fireBeforeExecuteInsertEvent @6-47AFA6A5
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

//fireAfterExecuteInsertEvent @6-E9CE95AE
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

//fireBeforeBuildSelectEvent @6-2405BE8B
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

//fireBeforeExecuteSelectEvent @6-E9DFF86B
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

//fireAfterExecuteSelectEvent @6-580A2987
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

//fireBeforeBuildSelectEvent @6-D021D0EA
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

//fireBeforeExecuteDeleteEvent @6-DD540FBB
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

//fireAfterExecuteDeleteEvent @6-2A6E2049
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

//class DataObject Tail @6-ED3F53A4
} // End of class DS
//End class DataObject Tail

