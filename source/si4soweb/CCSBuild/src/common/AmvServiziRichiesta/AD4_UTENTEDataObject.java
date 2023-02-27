/******************************************************************************
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
  1   05/02/2003   AO   Gestione parametri di output della procedure
******************************************************************************/
//AD4_UTENTE DataSource @2-C61B270A
package common.AmvServiziRichiesta;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_UTENTE DataSource

//class DataObject Header @2-6F70C966
public class AD4_UTENTEDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @2-AF62AC1C
    

    DoubleField sesMVRIC = new DoubleField(null, null);
    
    TextField sesUtente = new TextField(null, null);
    
    TextField sesMVUTE = new TextField(null, null);
    
    TextField postMODULO = new TextField(null, null);
    
    TextField postISTANZA = new TextField(null, null);
    
    TextField sesMVPWD = new TextField(null, null);
    
    TextField sesModulo = new TextField(null, null);
    
    TextField urlMODULO = new TextField(null, null);
    
    TextField urlISTANZA = new TextField(null, null);
    
    TextField sesIstanza = new TextField(null, null);
    

    private AD4_UTENTERow row = new AD4_UTENTERow();

//End attributes of DataObject

//properties of DataObject @2-3E6D0C05

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

    public void  setSesUtente( String param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param ) {
        this.sesUtente.setValue( param );
    }

    public void  setSesUtente( Object param, Format ignore ) {
        this.sesUtente.setValue( param );
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

    public void  setPostMODULO( String param ) {
        this.postMODULO.setValue( param );
    }

    public void  setPostMODULO( Object param ) {
        this.postMODULO.setValue( param );
    }

    public void  setPostMODULO( Object param, Format ignore ) {
        this.postMODULO.setValue( param );
    }

    public void  setPostISTANZA( String param ) {
        this.postISTANZA.setValue( param );
    }

    public void  setPostISTANZA( Object param ) {
        this.postISTANZA.setValue( param );
    }

    public void  setPostISTANZA( Object param, Format ignore ) {
        this.postISTANZA.setValue( param );
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

    public void  setSesModulo( String param ) {
        this.sesModulo.setValue( param );
    }

    public void  setSesModulo( Object param ) {
        this.sesModulo.setValue( param );
    }

    public void  setSesModulo( Object param, Format ignore ) {
        this.sesModulo.setValue( param );
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

//constructor @2-275A48E5
    public AD4_UTENTEDataObject(Page page) {
        super(page);
        addRecordDataObjectListener( new AD4_UTENTEDataObjectHandler() );
    }
//End constructor

//load @2-5B30B3E1
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT decode('{MVPWD}',null,'<strong>'||u.NOMINATIVO||'</strong>','L''utente <strong>'||u.NOMINATIVO||' </strong>è stato registrato.') NOMINATIVO "
                    + ",  "
                    + "m.DESCRIZIONE||' - '||i.DESCRIZIONE SERVIZIO "
                    + ",  "
                    + "decode('{MVPWD}',null,'','La password assegnata all''utente  è divisa in due parti.<p>La prima parte della password è : <strong>'||'{MVPWD}'||'</strong></p><p>La seconda parte verrà consegnata secondo le modalità previste dal servizio.</p>') PASSWORD "
                    + ", decode (v.TIPO_NOTIFICA,null,'','Il servizio richiesto prevede notifica di approvazione tramite '||v.TIPO_NOTIFICA||'. Fornire gli estremi di residenza o recapito necessari.') NOTIFICA "
                    + ", nvl(nvl "
                    + "(decode(AMV_MENU.GET_PAGE(substr(nvl('{MODULOURL}','{Modulo}'),1,5)||'RGA'),'','',AMV_MENU.GET_PAGE(substr(nvl('{MODULOURL}','{Modulo}'),1,5)||'RGA')), "
                    + "decode(AMV_MENU.GET_PAGE(substr(nvl('{MODULOURL}','{Modulo}'),1,5)||'RGP'),'','',AMV_MENU.GET_PAGE(substr(nvl('{MODULOURL}','{Modulo}'),1,5)||'RGP')) "
                    + "),'../common/AmvValidaAbilitazione.do?ccsForm=GESTISCI_RICHIESTA:Edit*Update=Aggiorna') REDIRECTION "
                    + ", nvl('{MVUTE}','{Utente}')UTENTE "
                    + ", nvl('{MODULOURL}','{Modulo}') MODULO,nvl('{ISTANZAURL}','{Istanza}')ISTANZA "
                    + ", AD4_SOGGETTO.GET_INDIRIZZO_COMPLETO(s.SOGGETTO,'Y') INDIRIZZO_COMPLETO "
                    + ", AD4_SOGGETTO.GET_INDIRIZZO_WEB(s.SOGGETTO) INDIRIZZO_WEB "
                    + ", AD4_SOGGETTO.GET_TELEFONO(s.SOGGETTO) TELEFONO "
                    + ", AD4_SOGGETTO.GET_FAX(s.SOGGETTO) FAX "
                    + "FROM AD4_UTENTI u, AD4_UTENTI_SOGGETTI s, AD4_MODULI m, AD4_ISTANZE i, AD4_SERVIZI v "
                    + "WHERE u.UTENTE = nvl('{MVUTE}','{Utente}') "
                    + "AND s.utente = u.utente "
                    + "AND m.modulo = nvl('{MODULOURL}','{Modulo}') "
                    + "AND i.istanza = nvl('{ISTANZAURL}','{Istanza}') "
                    + "AND v.modulo = m.modulo "
                    + "AND v.istanza = i.istanza " );
        if ( StringUtils.isEmpty( (String) sesMVPWD.getObjectValue() ) ) sesMVPWD.setValue( "" );
        command.addParameter( "MVPWD", sesMVPWD, null );
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

//loadDataBind @2-34B1A2CB
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setISTANZA(Utils.convertToString(ds.parse(record.get("ISTANZA"), row.getISTANZAField())));
            row.setMODULO(Utils.convertToString(ds.parse(record.get("MODULO"), row.getMODULOField())));
            row.setMVPAGES(Utils.convertToString(ds.parse(record.get("REDIRECTION"), row.getMVPAGESField())));
        }
//End loadDataBind

//End of load @2-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load
//Rev.1 : gestione parametri output della procedure custom AFC 
//update @2-24F173F3
Collection update() {	//custom AFC
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMV_UTENTE.REGISTRA_RICHIESTA ( ?, ?, ?, ?, ? ) }" );
            command.addParameter( "P_RICHIESTA", sesMVRIC, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_OUTPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
            command.addParameter( "P_UTENTE", sesUtente, java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) sesMVUTE.getObjectValue() ) ) sesMVUTE.setValue( "" );
            command.addParameter( "P_NUOVO_UTENTE", sesMVUTE, java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postMODULO.getObjectValue() ) ) postMODULO.setValue( "" );
            command.addParameter( "P_MODULO", postMODULO, java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) postISTANZA.getObjectValue() ) ) postISTANZA.setValue( "" );
            command.addParameter( "P_ISTANZA", postISTANZA, java.sql.Types.VARCHAR, 0, SPParameter.INPUT_PARAMETER );

            fireBeforeBuildUpdateEvent( new DataObjectEvent(command) );


//End update
            Collection cParam = null;	//custom AFC 
//updateDataBound @2-0130DCE2
            fireBeforeExecuteUpdateEvent( new DataObjectEvent(command) );

            if ( ! ds.hasErrors() ) {
                command.executeUpdate();
				cParam = command.getParameters();  //custom AFC 
            }

            CCLogger.getInstance().debug(command.toString());

            fireAfterExecuteUpdateEvent( new DataObjectEvent(command) );

//End updateDataBound

//End of update @2-F7C3107A
            isErrors = ds.hasErrors();
            if ( isErrors ) addErrors( ds.getErrors() );
            ds.closeConnection();
            //return ( ! isErrors );
			return cParam;		//custom AFC 
        }
//End End of update
//Rev.1 : fine 
//getParameterByName @2-B1A4452F
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "MVRIC".equals(name) && "ses".equals(prefix) ) {
                param = sesMVRIC;
            } else if ( "MVRIC".equals(name) && prefix == null ) {
                param = sesMVRIC;
            }
            if ( "Utente".equals(name) && "ses".equals(prefix) ) {
                param = sesUtente;
            } else if ( "Utente".equals(name) && prefix == null ) {
                param = sesUtente;
            }
            if ( "MVUTE".equals(name) && "ses".equals(prefix) ) {
                param = sesMVUTE;
            } else if ( "MVUTE".equals(name) && prefix == null ) {
                param = sesMVUTE;
            }
            if ( "MODULO".equals(name) && "post".equals(prefix) ) {
                param = postMODULO;
            } else if ( "MODULO".equals(name) && prefix == null ) {
                param = postMODULO;
            }
            if ( "ISTANZA".equals(name) && "post".equals(prefix) ) {
                param = postISTANZA;
            } else if ( "ISTANZA".equals(name) && prefix == null ) {
                param = postISTANZA;
            }
            if ( "MVPWD".equals(name) && "ses".equals(prefix) ) {
                param = sesMVPWD;
            } else if ( "MVPWD".equals(name) && prefix == null ) {
                param = sesMVPWD;
            }
            if ( "Modulo".equals(name) && "ses".equals(prefix) ) {
                param = sesModulo;
            } else if ( "Modulo".equals(name) && prefix == null ) {
                param = sesModulo;
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

//addRecordDataObjectListener @2-47141785
    public synchronized void addRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.addElement(l);
    }
//End addRecordDataObjectListener

//removeRecordDataObjectListener @2-A1ABC1F4
    public synchronized void removeRecordDataObjectListener( RecordDataObjectListener l ) {
        listeners.removeElement(l);
    }
//End removeRecordDataObjectListener

//fireBeforeBuildSelectEvent @2-305A023C
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

//fireBeforeExecuteSelectEvent @2-D00ACF95
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

//fireAfterExecuteSelectEvent @2-3BAD39CE
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

//fireBeforeBuildInsertEvent @2-FBA08B71
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

//fireBeforeExecuteInsertEvent @2-47AFA6A5
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

//fireAfterExecuteInsertEvent @2-E9CE95AE
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

//fireBeforeBuildSelectEvent @2-2405BE8B
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

//fireBeforeExecuteSelectEvent @2-E9DFF86B
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

//fireAfterExecuteSelectEvent @2-580A2987
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

//fireBeforeBuildSelectEvent @2-D021D0EA
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

//fireBeforeExecuteDeleteEvent @2-DD540FBB
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

//fireAfterExecuteDeleteEvent @2-2A6E2049
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

//class DataObject Tail @2-ED3F53A4
} // End of class DS
//End class DataObject Tail

