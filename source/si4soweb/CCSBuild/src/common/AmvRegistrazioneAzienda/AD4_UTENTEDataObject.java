//AD4_UTENTE DataSource @14-7980DA47
package common.AmvRegistrazioneAzienda;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_UTENTE DataSource

//class DataObject Header @14-6F70C966
public class AD4_UTENTEDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @14-1E68F75C
    

    DoubleField sesMVRIC = new DoubleField(null, null);
    
    TextField exprKey54 = new TextField(null, null);
    
    TextField postRS_AZIENDA = new TextField(null, null);
    
    TextField exprKey56 = new TextField(null, null);
    
    TextField postCF_AZIENDA = new TextField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    TextField sesModulo = new TextField(null, null);
    
    TextField sesMVUTE = new TextField(null, null);
    
    TextField urlMODULO = new TextField(null, null);
    
    TextField urlISTANZA = new TextField(null, null);
    
    TextField sesIstanza = new TextField(null, null);
    

    private AD4_UTENTERow row = new AD4_UTENTERow();

//End attributes of DataObject

//properties of DataObject @14-FD74C48A

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

    public void  setExprKey54( String param ) {
        this.exprKey54.setValue( param );
    }

    public void  setExprKey54( Object param ) {
        this.exprKey54.setValue( param );
    }

    public void  setExprKey54( Object param, Format ignore ) {
        this.exprKey54.setValue( param );
    }

    public void  setPostRS_AZIENDA( String param ) {
        this.postRS_AZIENDA.setValue( param );
    }

    public void  setPostRS_AZIENDA( Object param ) {
        this.postRS_AZIENDA.setValue( param );
    }

    public void  setPostRS_AZIENDA( Object param, Format ignore ) {
        this.postRS_AZIENDA.setValue( param );
    }

    public void  setExprKey56( String param ) {
        this.exprKey56.setValue( param );
    }

    public void  setExprKey56( Object param ) {
        this.exprKey56.setValue( param );
    }

    public void  setExprKey56( Object param, Format ignore ) {
        this.exprKey56.setValue( param );
    }

    public void  setPostCF_AZIENDA( String param ) {
        this.postCF_AZIENDA.setValue( param );
    }

    public void  setPostCF_AZIENDA( Object param ) {
        this.postCF_AZIENDA.setValue( param );
    }

    public void  setPostCF_AZIENDA( Object param, Format ignore ) {
        this.postCF_AZIENDA.setValue( param );
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

    public void  setSesModulo( String param ) {
        this.sesModulo.setValue( param );
    }

    public void  setSesModulo( Object param ) {
        this.sesModulo.setValue( param );
    }

    public void  setSesModulo( Object param, Format ignore ) {
        this.sesModulo.setValue( param );
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

    public void  setUrlMODULO( String param ) {
        this.urlMODULO.setValue( param );
    }

    public void  setUrlMODULO( Object param ) {
        this.urlMODULO.setValue( param );
    }

    public void  setUrlMODULO( Object param, Format ignore ) {
        this.urlMODULO.setValue( param );
    }

    public void  setUrlISTANZA( String param ) {
        this.urlISTANZA.setValue( param );
    }

    public void  setUrlISTANZA( Object param ) {
        this.urlISTANZA.setValue( param );
    }

    public void  setUrlISTANZA( Object param, Format ignore ) {
        this.urlISTANZA.setValue( param );
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

    public AD4_UTENTERow getRow() {
        return row;
    }

    public void setRow( AD4_UTENTERow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @14-F9C29682
    public AD4_UTENTEDataObject(Page page) {
        super(page);
    }
//End constructor

//load @14-7E727FC1
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT u.NOMINATIVO NOMINATIVO "
                    + ", m.DESCRIZIONE||' - '||i.descrizione SERVIZIO "
                    + ",  "
                    + "nvl( "
                    + "decode(AMV_MENU.GET_PAGE(substr(nvl('{MODULOURL}','{Modulo}'),1,5)||'RGP'),'','',AMV_MENU.GET_PAGE(substr(nvl('{MODULOURL}','{Modulo}'),1,5)||'RGP')) "
                    + ",'../common/AmvValidaAbilitazione.do?ccsForm=GESTISCI_RICHIESTA:Edit*Update=Aggiorna') REDIRECTION "
                    + "FROM AD4_UTENTI u, AD4_UTENTI_SOGGETTI s, AD4_MODULI m, AD4_ISTANZE i "
                    + "WHERE u.UTENTE = nvl('{MVUTE}','{Utente}') "
                    + "AND s.utente = u.utente "
                    + "AND m.modulo = nvl('{MODULOURL}','{Modulo}') "
                    + "AND i.istanza = nvl('{ISTANZAURL}','{Istanza}')" );
        if ( StringUtils.isEmpty( (String) sesModulo.getObjectValue() ) ) sesModulo.setValue( "" );
        command.addParameter( "Modulo", sesModulo, null );
        if ( StringUtils.isEmpty( (String) sesMVUTE.getObjectValue() ) ) sesMVUTE.setValue( "" );
        command.addParameter( "MVUTE", sesMVUTE, null );
        if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
        command.addParameter( "Utente", sesUtente, null );
        if ( StringUtils.isEmpty( (String) urlMODULO.getObjectValue() ) ) urlMODULO.setValue( "" );
        command.addParameter( "MODULOURL", urlMODULO, null );
        if ( StringUtils.isEmpty( (String) urlISTANZA.getObjectValue() ) ) urlISTANZA.setValue( "" );
        command.addParameter( "ISTANZAURL", urlISTANZA, null );
        if ( StringUtils.isEmpty( (String) sesIstanza.getObjectValue() ) ) sesIstanza.setValue( "" );
        command.addParameter( "Istanza", sesIstanza, null );
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

//loadDataBind @14-F2A371B3
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setNOMINATIVO(Utils.convertToString(ds.parse(record.get("NOMINATIVO"), row.getNOMINATIVOField())));
            row.setSERVIZIO(Utils.convertToString(ds.parse(record.get("SERVIZIO"), row.getSERVIZIOField())));
            row.setMVPAGES(Utils.convertToString(ds.parse(record.get("REDIRECTION"), row.getMVPAGESField())));
        }
//End loadDataBind

//End of load @14-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//update @14-18FC57F6
        boolean update() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMV_UTENTE.SET_PARAMETRI_AZIENDA ( ?, ?, ?, ?, ?, ? ) }" );
            command.addParameter( "P_ID_RICHIESTA", sesMVRIC, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) exprKey54.getObjectValue() ) ) exprKey54.setValue( "" );
            command.addParameter( "P_RS", exprKey54, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postRS_AZIENDA.getObjectValue() ) ) postRS_AZIENDA.setValue( "" );
            command.addParameter( "P_RS_VALORE", postRS_AZIENDA, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) exprKey56.getObjectValue() ) ) exprKey56.setValue( "" );
            command.addParameter( "P_CF", exprKey56, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postCF_AZIENDA.getObjectValue() ) ) postCF_AZIENDA.setValue( "" );
            command.addParameter( "P_CF_VALORE", postCF_AZIENDA, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
            command.addParameter( "P_UTENTE", sesUtente, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );

            fireBeforeBuildUpdateEvent( new DataObjectEvent(command) );


//End update

//updateDataBound @14-0130DCE2
            fireBeforeExecuteUpdateEvent( new DataObjectEvent(command) );

            if ( ! ds.hasErrors() ) {
                command.executeUpdate();
            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteUpdateEvent( new DataObjectEvent(command) );

//End updateDataBound

//End of update @14-CDC5319F
            ds.closeConnection();
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            return ( ! isErrors );
        }
//End End of update

//getParameterByName @14-70ED96D5
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "MVRIC".equals(name) && "ses".equals(prefix) ) {
                param = sesMVRIC;
            } else if ( "MVRIC".equals(name) && prefix == null ) {
                param = sesMVRIC;
            }
            if ( "exprKey54".equals(name) && "expr".equals(prefix) ) {
                param = exprKey54;
            } else if ( "exprKey54".equals(name) && prefix == null ) {
                param = exprKey54;
            }
            if ( "RS_AZIENDA".equals(name) && "post".equals(prefix) ) {
                param = postRS_AZIENDA;
            } else if ( "RS_AZIENDA".equals(name) && prefix == null ) {
                param = postRS_AZIENDA;
            }
            if ( "exprKey56".equals(name) && "expr".equals(prefix) ) {
                param = exprKey56;
            } else if ( "exprKey56".equals(name) && prefix == null ) {
                param = exprKey56;
            }
            if ( "CF_AZIENDA".equals(name) && "post".equals(prefix) ) {
                param = postCF_AZIENDA;
            } else if ( "CF_AZIENDA".equals(name) && prefix == null ) {
                param = postCF_AZIENDA;
            }
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "Modulo".equals(name) && "ses".equals(prefix) ) {
                param = sesModulo;
            } else if ( "Modulo".equals(name) && prefix == null ) {
                param = sesModulo;
            }
            if ( "MVUTE".equals(name) && "ses".equals(prefix) ) {
                param = sesMVUTE;
            } else if ( "MVUTE".equals(name) && prefix == null ) {
                param = sesMVUTE;
            }
            if ( "MODULO".equals(name) && "url".equals(prefix) ) {
                param = urlMODULO;
            } else if ( "MODULO".equals(name) && prefix == null ) {
                param = urlMODULO;
            }
            if ( "ISTANZA".equals(name) && "url".equals(prefix) ) {
                param = urlISTANZA;
            } else if ( "ISTANZA".equals(name) && prefix == null ) {
                param = urlISTANZA;
            }
            if ( "Istanza".equals(name) && "ses".equals(prefix) ) {
                param = sesIstanza;
            } else if ( "Istanza".equals(name) && prefix == null ) {
                param = sesIstanza;
            }
            return param;
        }

        public Parameter getParameterByName(String name) {
            return getParameterByName( name, null );
        }
//End getParameterByName

//addRecordDataObjectListener @14-47141785
    public synchronized void addRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.addElement(l);
    }
//End addRecordDataObjectListener

//removeRecordDataObjectListener @14-A1ABC1F4
    public synchronized void removeRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeRecordDataObjectListener

//fireBeforeBuildSelectEvent @14-305A023C
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

//fireBeforeExecuteSelectEvent @14-D00ACF95
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

//fireAfterExecuteSelectEvent @14-3BAD39CE
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

//fireBeforeBuildInsertEvent @14-FBA08B71
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

//fireBeforeExecuteInsertEvent @14-47AFA6A5
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

//fireAfterExecuteInsertEvent @14-E9CE95AE
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

//fireBeforeBuildSelectEvent @14-2405BE8B
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

//fireBeforeExecuteSelectEvent @14-E9DFF86B
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

//fireAfterExecuteSelectEvent @14-580A2987
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

//fireBeforeBuildSelectEvent @14-D021D0EA
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

//fireBeforeExecuteDeleteEvent @14-DD540FBB
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

//fireAfterExecuteDeleteEvent @14-2A6E2049
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

//class DataObject Tail @14-ED3F53A4
} // End of class DS
//End class DataObject Tail

