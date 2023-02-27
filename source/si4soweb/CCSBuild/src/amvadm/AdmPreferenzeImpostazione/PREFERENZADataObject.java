//PREFERENZA DataSource @17-454E111D
package amvadm.AdmPreferenzeImpostazione;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End PREFERENZA DataSource

//class DataObject Header @17-9FC7AAA6
public class PREFERENZADataObject extends DS {
//End class DataObject Header

//attributes of DataObject @17-BA7A74FD
    

    TextField postSTRINGA = new TextField(null, null);
    
    TextField postVALORE = new TextField(null, null);
    
    TextField postMODULO = new TextField(null, null);
    
    TextField exprKey43 = new TextField(null, null);
    
    TextField exprKey41 = new TextField(null, null);
    
    TextField urlP_UTENTE = new TextField(null, null);
    
    TextField urlSTRINGA = new TextField(null, null);
    
    TextField urlMVAV = new TextField(null, null);
    
    TextField sesModulo = new TextField(null, null);
    

    private PREFERENZARow row = new PREFERENZARow();

//End attributes of DataObject

//properties of DataObject @17-F6607B54

    public void  setPostSTRINGA( String param ) {
        this.postSTRINGA.setValue( param );
    }

    public void  setPostSTRINGA( Object param ) {
        this.postSTRINGA.setValue( param );
    }

    public void  setPostSTRINGA( Object param, Format ignore ) {
        this.postSTRINGA.setValue( param );
    }

    public void  setPostVALORE( String param ) {
        this.postVALORE.setValue( param );
    }

    public void  setPostVALORE( Object param ) {
        this.postVALORE.setValue( param );
    }

    public void  setPostVALORE( Object param, Format ignore ) {
        this.postVALORE.setValue( param );
    }

    public void  setPostMODULO( String param ) {
        this.postMODULO.setValue( param );
    }

    public void  setPostMODULO( Object param ) {
        this.postMODULO.setValue( param );
    }

    public void  setPostMODULO( Object param, Format ignore ) {
        this.postMODULO.setValue( param );
    }

    public void  setExprKey43( String param ) {
        this.exprKey43.setValue( param );
    }

    public void  setExprKey43( Object param ) {
        this.exprKey43.setValue( param );
    }

    public void  setExprKey43( Object param, Format ignore ) {
        this.exprKey43.setValue( param );
    }

    public void  setExprKey41( String param ) {
        this.exprKey41.setValue( param );
    }

    public void  setExprKey41( Object param ) {
        this.exprKey41.setValue( param );
    }

    public void  setExprKey41( Object param, Format ignore ) {
        this.exprKey41.setValue( param );
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

    public void  setUrlSTRINGA( String param ) {
        this.urlSTRINGA.setValue( param );
    }

    public void  setUrlSTRINGA( Object param ) {
        this.urlSTRINGA.setValue( param );
    }

    public void  setUrlSTRINGA( Object param, Format ignore ) {
        this.urlSTRINGA.setValue( param );
    }

    public void  setUrlMVAV( String param ) {
        this.urlMVAV.setValue( param );
    }

    public void  setUrlMVAV( Object param ) {
        this.urlMVAV.setValue( param );
    }

    public void  setUrlMVAV( Object param, Format ignore ) {
        this.urlMVAV.setValue( param );
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

    public PREFERENZARow getRow() {
        return row;
    }

    public void setRow( PREFERENZARow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @17-0184EF06
    public PREFERENZADataObject(Page page) {
        super(page);
    }
//End constructor

//load @17-5730C36B
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT stringa "
                    + ",  "
                    + "AMVWEB.GET_PREFERENZA(stringa,0,decode('{MVAV}',1,'{Modulo}','')) valore "
                    + ", decode('{MVAV}',1,'{Modulo}','') modulo "
                    + ",  "
                    + "max(commento) commento "
                    + "from REGISTRO  "
                    + "where stringa = '{STRINGA}' "
                    + "group by stringa" );
        if ( StringUtils.isEmpty( (String) urlSTRINGA.getObjectValue() ) ) urlSTRINGA.setValue( "" );
        command.addParameter( "STRINGA", urlSTRINGA, null );
        if ( StringUtils.isEmpty( (String) urlMVAV.getObjectValue() ) ) urlMVAV.setValue( "" );
        command.addParameter( "MVAV", urlMVAV, null );
        if ( StringUtils.isEmpty( (String) sesModulo.getObjectValue() ) ) sesModulo.setValue( "" );
        command.addParameter( "Modulo", sesModulo, null );
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

//loadDataBind @17-3839B4EE
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setSTRINGA_LABEL(Utils.convertToString(ds.parse(record.get("STRINGA"), row.getSTRINGA_LABELField())));
            row.setCOMMENTO(Utils.convertToString(ds.parse(record.get("COMMENTO"), row.getCOMMENTOField())));
            row.setVALORE(Utils.convertToString(ds.parse(record.get("VALORE"), row.getVALOREField())));
            row.setSTRINGA(Utils.convertToString(ds.parse(record.get("STRINGA"), row.getSTRINGAField())));
            row.setMODULO(Utils.convertToString(ds.parse(record.get("MODULO"), row.getMODULOField())));
        }
//End loadDataBind

//End of load @17-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//update @17-0D41D73F
        boolean update() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMVWEB.SET_PREFERENZA ( ?, ?, ?, ? ) }" );
            if ( StringUtils.isEmpty( (String) postSTRINGA.getObjectValue() ) ) postSTRINGA.setValue( "" );
            command.addParameter( "P_STRINGA", postSTRINGA, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postVALORE.getObjectValue() ) ) postVALORE.setValue( "" );
            command.addParameter( "P_VALORE", postVALORE, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postMODULO.getObjectValue() ) ) postMODULO.setValue( "" );
            command.addParameter( "P_MODULO", postMODULO, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) exprKey43.getObjectValue() ) ) exprKey43.setValue( "" );
            command.addParameter( "P_UTENTE", exprKey43, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );

            fireBeforeBuildUpdateEvent( new DataObjectEvent(command) );


//End update

//updateDataBound @17-0130DCE2
            fireBeforeExecuteUpdateEvent( new DataObjectEvent(command) );

            if ( ! ds.hasErrors() ) {
                command.executeUpdate();
            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteUpdateEvent( new DataObjectEvent(command) );

//End updateDataBound

//End of update @17-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of update

//delete @17-1234CC68
        boolean delete() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMVWEB.SET_PREFERENZA ( ?, ?, ?, ? ) }" );
            if ( StringUtils.isEmpty( (String) postSTRINGA.getObjectValue() ) ) postSTRINGA.setValue( "" );
            command.addParameter( "P_STRINGA", postSTRINGA, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) exprKey41.getObjectValue() ) ) exprKey41.setValue( "" );
            command.addParameter( "P_VALORE", exprKey41, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postMODULO.getObjectValue() ) ) postMODULO.setValue( "" );
            command.addParameter( "P_MODULO", postMODULO, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) urlP_UTENTE.getObjectValue() ) ) urlP_UTENTE.setValue( "" );
            command.addParameter( "P_UTENTE", urlP_UTENTE, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );

            fireBeforeBuildDeleteEvent( new DataObjectEvent(command) );


//End delete

//deleteDataBound @17-67425D5E
            fireBeforeExecuteDeleteEvent( new DataObjectEvent(command) );

            if ( ! ds.hasErrors() ) {
                command.executeUpdate();
            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteDeleteEvent( new DataObjectEvent(command) );

//End deleteDataBound

//End of delete @17-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of delete

//getParameterByName @17-CE4A6E41
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "STRINGA".equals(name) && "post".equals(prefix) ) {
                param = postSTRINGA;
            } else if ( "STRINGA".equals(name) && prefix == null ) {
                param = postSTRINGA;
            }
            if ( "VALORE".equals(name) && "post".equals(prefix) ) {
                param = postVALORE;
            } else if ( "VALORE".equals(name) && prefix == null ) {
                param = postVALORE;
            }
            if ( "MODULO".equals(name) && "post".equals(prefix) ) {
                param = postMODULO;
            } else if ( "MODULO".equals(name) && prefix == null ) {
                param = postMODULO;
            }
            if ( "exprKey43".equals(name) && "expr".equals(prefix) ) {
                param = exprKey43;
            } else if ( "exprKey43".equals(name) && prefix == null ) {
                param = exprKey43;
            }
            if ( "exprKey41".equals(name) && "expr".equals(prefix) ) {
                param = exprKey41;
            } else if ( "exprKey41".equals(name) && prefix == null ) {
                param = exprKey41;
            }
            if ( "P_UTENTE".equals(name) && "url".equals(prefix) ) {
                param = urlP_UTENTE;
            } else if ( "P_UTENTE".equals(name) && prefix == null ) {
                param = urlP_UTENTE;
            }
            if ( "STRINGA".equals(name) && "url".equals(prefix) ) {
                param = urlSTRINGA;
            } else if ( "STRINGA".equals(name) && prefix == null ) {
                param = urlSTRINGA;
            }
            if ( "MVAV".equals(name) && "url".equals(prefix) ) {
                param = urlMVAV;
            } else if ( "MVAV".equals(name) && prefix == null ) {
                param = urlMVAV;
            }
            if ( "Modulo".equals(name) && "ses".equals(prefix) ) {
                param = sesModulo;
            } else if ( "Modulo".equals(name) && prefix == null ) {
                param = sesModulo;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addRecordDataObjectListener @17-47141785
    public synchronized void addRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.addElement(l);
    }
//End addRecordDataObjectListener

//removeRecordDataObjectListener @17-A1ABC1F4
    public synchronized void removeRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeRecordDataObjectListener

//fireBeforeBuildSelectEvent @17-305A023C
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

//fireBeforeExecuteSelectEvent @17-D00ACF95
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

//fireAfterExecuteSelectEvent @17-3BAD39CE
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

//fireBeforeBuildInsertEvent @17-FBA08B71
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

//fireBeforeExecuteInsertEvent @17-47AFA6A5
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

//fireAfterExecuteInsertEvent @17-E9CE95AE
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

//fireBeforeBuildSelectEvent @17-2405BE8B
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

//fireBeforeExecuteSelectEvent @17-E9DFF86B
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

//fireAfterExecuteSelectEvent @17-580A2987
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

//fireBeforeBuildSelectEvent @17-D021D0EA
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

//fireBeforeExecuteDeleteEvent @17-DD540FBB
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

//fireAfterExecuteDeleteEvent @17-2A6E2049
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

//class DataObject Tail @17-ED3F53A4
} // End of class DS
//End class DataObject Tail

