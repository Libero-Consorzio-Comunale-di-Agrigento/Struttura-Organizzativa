//AD4_RICHIESTE_ABILITAZIONERecord DataSource @7-0C95D343
package amvadm.AdmRichiesta;

import java.util.*;
import java.text.*;
import com.codecharge.*;
import com.codecharge.db.*;
import com.codecharge.events.*;
import com.codecharge.util.*;
import com.codecharge.components.*;
//End AD4_RICHIESTE_ABILITAZIONERecord DataSource

//class DataObject Header @7-40A7212F
public class AD4_RICHIESTE_ABILITAZIONERecordDataObject extends DS {
//End class DataObject Header

//attributes of DataObject @7-842387B2
    

    DoubleField urlID = new DoubleField(null, null);
    
    TextField urlTC = new TextField(null, null);
    

    private AD4_RICHIESTE_ABILITAZIONERecordRow row = new AD4_RICHIESTE_ABILITAZIONERecordRow();

//End attributes of DataObject

//properties of DataObject @7-84C6413F

    public void  setUrlID( double param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlID( double param, Format ignore ) throws java.text.ParseException {
        this.urlID.setValue( param );
    }

    public void  setUrlID( Object param, Format format ) throws java.text.ParseException {
        this.urlID.setValue( param, format );
    }

    public void  setUrlID( Double param ) {
        this.urlID.setValue( param );
    }

    public void  setUrlTC( String param ) {
        this.urlTC.setValue( param );
    }

    public void  setUrlTC( Object param ) {
        this.urlTC.setValue( param );
    }

    public void  setUrlTC( Object param, Format ignore ) {
        this.urlTC.setValue( param );
    }

    public AD4_RICHIESTE_ABILITAZIONERecordRow getRow() {
        return row;
    }

    public void setRow( AD4_RICHIESTE_ABILITAZIONERecordRow row ) {
        this.row = row;
    }

//End properties of DataObject

//constructor @7-AB9EAC2B
    public AD4_RICHIESTE_ABILITAZIONERecordDataObject(Page page) {
        super(page);
    }
//End constructor

//load @7-476660A5
    boolean load() {
        boolean isErrors = false;
        JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
        ds.setLocale(page.getCCSLocale().getLocale());
        RawCommand command = new RawCommand( ds );

        command.setSql( "SELECT m.descrizione||' - '||i.descrizione servizio, u.nominativo richiedente,  "
                    + "r.data data, decode(r.stato,'C','In attesa di approvazione (Dati convalidati)','F',  "
                    + "'In attesa di rettifica (Dati non corretti)') stato,  "
                    + "r.tipo_notifica tipo_notifica, r.indirizzo_notifica indirizzo_notifica "
                    + ",  "
                    + "decode(AMV_MENU.GET_PAGE(substr(r.modulo,1,5)||'RGR'),'','',  "
                    + "nvl(AMV_MENU.GET_PARAM_VOCE(substr(r.modulo,1,5)||'RGR','title'),'Competenza'))  revisione_competenza "
                    + ",  "
                    + "decode(AMV_MENU.GET_PAGE(substr(r.modulo,1,5)||'RGR'),'','',  "
                    + "AMV_MENU.GET_PAGE(substr(r.modulo,1,5)||'RGR')) revisione_competenza_href   "
                    + ",  "
                    + "decode(AMV_MENU.GET_PAGE(substr(r.modulo,1,5)||'RGA')||AMV_MENU.GET_PAGE(substr(r.modulo,1,5)||'RGP'),'','',  "
                    + "nvl(AMV_MENU.GET_PARAM_VOCE(substr(r.modulo,1,5)||'RGM','title'),'Parametri'))  revisione_parametri "
                    + ", decode(AMV_MENU.GET_PAGE(substr(r.modulo,1,5)||'RGA')||AMV_MENU.GET_PAGE(substr(r.modulo,1,5)||'RGP'),'','', nvl(AMV_MENU.GET_PAGE(substr(r.modulo,1,5)||'RGM'),'../amvadm/AdmRichiestaParametri.do')) revisione_parametri_href   "
                    + " FROM ad4_richieste_abilitazione r, ad4_istanze i, ad4_moduli m, ad4_utenti u "
                    + "WHERE r.modulo = m.modulo "
                    + "AND r.istanza = i.istanza "
                    + "AND r.utente = u.utente "
                    + "AND r.id_richiesta = {ID}" );
        if ( urlID.getObjectValue() == null ) urlID.setValue( 0 );
        command.addParameter( "ID", urlID, null );
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

//loadDataBind @7-0A5AA8B4
        if ( record == null || record.isEmpty() ) {
            empty = true;
        } else {
            row.setREVISIONE_PARAMETRI(Utils.convertToString(ds.parse(record.get("REVISIONE_PARAMETRI"), row.getREVISIONE_PARAMETRIField())));
            row.setREVISIONE_COMPETENZA(Utils.convertToString(ds.parse(record.get("REVISIONE_COMPETENZA"), row.getREVISIONE_COMPETENZAField())));
            row.setREVISIONE_PARAMETRI_HREF(Utils.convertToString(ds.parse(record.get("REVISIONE_PARAMETRI_HREF"), row.getREVISIONE_PARAMETRI_HREFField())));
            row.setREVISIONE_COMPETENZA_HREF(Utils.convertToString(ds.parse(record.get("REVISIONE_COMPETENZA_HREF"), row.getREVISIONE_COMPETENZA_HREFField())));
        }
//End loadDataBind

//End of load @7-B1C63002
        isErrors = ds.hasErrors();
        if ( isErrors ) addErrors( ds.getErrors() );
        return ( ! isErrors );
    }
//End End of load

//update @7-B9F7AC76
        boolean update() {
            boolean isErrors = false;
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            SPCommand command = SPCommandFactory.getSPCommand( "cn" );
            command.setJdbcConnection( ds );

            command.setSql( "{ call AMV_UTENTE.GESTISCI_RICHIESTA ( ?, ? ) }" );
            command.addParameter( "P_RICHIESTA", urlID, java.sql.Types.DOUBLE, 0, SPParameter.INPUT_PARAMETER );
            if ( StringUtils.isEmpty( (String) urlTC.getObjectValue() ) ) urlTC.setValue( "" );
            command.addParameter( "P_TIPO_CONVALIDA", urlTC, java.sql.Types.CHAR, 0, SPParameter.INPUT_PARAMETER );

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

//getParameterByName @7-EDD37929
        public Parameter getParameterByName(String name, ParameterSource parameterSource) {
            Parameter param = null;
            String prefix = (parameterSource == null ? null : parameterSource.getPrefix());
            if ( "ID".equals(name) && "url".equals(prefix) ) {
                param = urlID;
            } else if ( "ID".equals(name) && prefix == null ) {
                param = urlID;
            }
            if ( "TC".equals(name) && "url".equals(prefix) ) {
                param = urlTC;
            } else if ( "TC".equals(name) && prefix == null ) {
                param = urlTC;
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

