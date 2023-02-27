//LOSTLOGIN DataSource @6-165A798A
package common.AmvLostLogin;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End LOSTLOGIN DataSource

//class DataObject Header @6-83AD47AD
public class LOSTLOGINDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @6-F86DF4E9
    

    TextField postNOME = new TextField(null, null);
    
    TextField postCOGNOME = new TextField(null, null);
    
    TextField postEMAIL = new TextField(null, null);
    
    TextField sesModulo = new TextField(null, null);
    
    TextField sesIstanza = new TextField(null, null);
    
    TextField sesProgetto = new TextField(null, null);
    
    TextField exprKey23 = new TextField(null, null);
    

    private LOSTLOGINRow row = new LOSTLOGINRow();

//End attributes of DataObject

//properties of DataObject @6-A5BF6C5A

    public void  setPostNOME( String param ) {
        this.postNOME.setValue( param );
    }

    public void  setPostNOME( Object param ) {
        this.postNOME.setValue( param );
    }

    public void  setPostNOME( Object param, Format ignore ) {
        this.postNOME.setValue( param );
    }

    public void  setPostCOGNOME( String param ) {
        this.postCOGNOME.setValue( param );
    }

    public void  setPostCOGNOME( Object param ) {
        this.postCOGNOME.setValue( param );
    }

    public void  setPostCOGNOME( Object param, Format ignore ) {
        this.postCOGNOME.setValue( param );
    }

    public void  setPostEMAIL( String param ) {
        this.postEMAIL.setValue( param );
    }

    public void  setPostEMAIL( Object param ) {
        this.postEMAIL.setValue( param );
    }

    public void  setPostEMAIL( Object param, Format ignore ) {
        this.postEMAIL.setValue( param );
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

    public void  setSesIstanza( String param ) {
        this.sesIstanza.setValue( param );
    }

    public void  setSesIstanza( Object param ) {
        this.sesIstanza.setValue( param );
    }

    public void  setSesIstanza( Object param, Format ignore ) {
        this.sesIstanza.setValue( param );
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

    public void  setExprKey23( String param ) {
        this.exprKey23.setValue( param );
    }

    public void  setExprKey23( Object param ) {
        this.exprKey23.setValue( param );
    }

    public void  setExprKey23( Object param, Format ignore ) {
        this.exprKey23.setValue( param );
    }

    public LOSTLOGINRow getRow() {
        return row;
    }

    public void setRow( LOSTLOGINRow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @6-12FF033D
    public LOSTLOGINDataObject(Page page) {
        super(page);
    }
//End constructor

//load @6-8B768152
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "select 1 "
                    + "from dual "
                    + "where 1=2" );
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

//loadDataBind @6-3235E50D
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
        }
//End loadDataBind

//End of load @6-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//insert @6-60D63709
        boolean insert() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMV_UTENTE.RECUPERA_LOGIN ( ?, ?, ?, ?, ?, ?, ? ) }" );
            if ( StringUtils.isEmpty( (String) postNOME.getObjectValue() ) ) postNOME.setValue( "" );
            command.addParameter( "P_NOME", postNOME, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postCOGNOME.getObjectValue() ) ) postCOGNOME.setValue( "" );
            command.addParameter( "P_COGNOME", postCOGNOME, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postEMAIL.getObjectValue() ) ) postEMAIL.setValue( "" );
            command.addParameter( "P_EMAIL", postEMAIL, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) sesModulo.getObjectValue() ) ) sesModulo.setValue( "" );
            command.addParameter( "P_MODULO", sesModulo, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) sesIstanza.getObjectValue() ) ) sesIstanza.setValue( "" );
            command.addParameter( "P_ISTANZA", sesIstanza, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) sesProgetto.getObjectValue() ) ) sesProgetto.setValue( "" );
            command.addParameter( "P_PROGETTO", sesProgetto, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) exprKey23.getObjectValue() ) ) exprKey23.setValue( "" );
            command.addParameter( "P_LINK", exprKey23, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );

            fireBeforeBuildInsertEvent( new DataObjectEvent(command) );

//End insert

//insertDataBound @6-BC781F8A
            fireBeforeExecuteInsertEvent( new DataObjectEvent(command) );

            if ( ! ds.hasErrors() ) {
                command.executeUpdate();
            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteInsertEvent( new DataObjectEvent(command) );

//End insertDataBound

//End of insert @6-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of insert

//getParameterByName @6-7A0B7323
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "NOME".equals(name) && "post".equals(prefix) ) {
                param = postNOME;
            } else if ( "NOME".equals(name) && prefix == null ) {
                param = postNOME;
            }
            if ( "COGNOME".equals(name) && "post".equals(prefix) ) {
                param = postCOGNOME;
            } else if ( "COGNOME".equals(name) && prefix == null ) {
                param = postCOGNOME;
            }
            if ( "EMAIL".equals(name) && "post".equals(prefix) ) {
                param = postEMAIL;
            } else if ( "EMAIL".equals(name) && prefix == null ) {
                param = postEMAIL;
            }
            if ( "Modulo".equals(name) && "ses".equals(prefix) ) {
                param = sesModulo;
            } else if ( "Modulo".equals(name) && prefix == null ) {
                param = sesModulo;
            }
            if ( "Istanza".equals(name) && "ses".equals(prefix) ) {
                param = sesIstanza;
            } else if ( "Istanza".equals(name) && prefix == null ) {
                param = sesIstanza;
            }
            if ( "Progetto".equals(name) && "ses".equals(prefix) ) {
                param = sesProgetto;
            } else if ( "Progetto".equals(name) && prefix == null ) {
                param = sesProgetto;
            }
            if ( "exprKey23".equals(name) && "expr".equals(prefix) ) {
                param = exprKey23;
            } else if ( "exprKey23".equals(name) && prefix == null ) {
                param = exprKey23;
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

