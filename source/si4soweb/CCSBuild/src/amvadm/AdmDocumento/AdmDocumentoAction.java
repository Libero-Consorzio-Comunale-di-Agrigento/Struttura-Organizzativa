/******************************************************************************
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
  1   21/03/2005   AO   Gestione parametri di output della procedure in Insert
******************************************************************************/
//AdmDocumentoAction imports @1-0E7F2988
package amvadm.AdmDocumento;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmDocumentoAction imports

//AdmDocumentoAction class @1-AE5E3232
public class AdmDocumentoAction extends Action {

//End AdmDocumentoAction class

//AdmDocumentoAction: method perform @1-225B1AF3
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmDocumentoModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmDocumentoModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmDocumentoAction: method perform

//AdmDocumentoAction: call children actions @1-153EBECB
        if ( page.getChild( "Header" ).isVisible() ) {
            page.getRequest().setAttribute("HeaderParent",page);
            common.Header.HeaderAction Header = new common.Header.HeaderAction();
            result = result != null ? result : Header.perform( req, resp,  context );
            page.setCookies();
        }
        if (result == null) {
            AMV_DOCUMENTIClass AMV_DOCUMENTI = new AMV_DOCUMENTIClass();
            if ( ( redirect = AMV_DOCUMENTI.perform( page.getRecord("AMV_DOCUMENTI")) ) != null ) result = redirect;
        }
        if ( page.getChild( "Footer" ).isVisible() ) {
            page.getRequest().setAttribute("FooterParent",page);
            common.Footer.FooterAction Footer = new common.Footer.FooterAction();
            result = result != null ? result : Footer.perform( req, resp,  context );
            page.setCookies();
        }
        if (result==null) { result = page.getRedirectString(); }
        return result;
    }
//End AdmDocumentoAction: call children actions

//AMV_DOCUMENTI Record @5-D5C01822
    final class AMV_DOCUMENTIClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AMV_DOCUMENTI Record

//AMV_DOCUMENTI Record: method perform @5-F68184A5
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( page.getActionPageName() + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowInsert() ) model.getChild( "Insert" ).setVisible( false );
            if ( ! model.isAllowUpdate() ) model.getChild( "Update" ).setVisible( false );
            if ( ! model.isAllowDelete() ) model.getChild( "Delete" ).setVisible( false );
//End AMV_DOCUMENTI Record: method perform

//AMV_DOCUMENTI Record: children actions @5-3506B17D
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AMV_DOCUMENTI".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Update") != null) {
                        if (validate()) {
                            Update7Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Delete") != null) {
                        Delete8Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                    if (page.getParameter("Cancel") != null) {
                        Cancel9Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Insert") != null) {
                        if (validate()) {
                            Insert6Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Cancel") != null) {
                        Cancel9Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                }
            }
            setProperties(model, Action.GET, true );
            read();
            readID_AREA(model.getListBox("ID_AREA"));
            readID_TIPOLOGIA(model.getListBox("ID_TIPOLOGIA"));
            readID_CATEGORIA(model.getListBox("ID_CATEGORIA"));
            readID_ARGOMENTO(model.getListBox("ID_ARGOMENTO"));
            readID_SEZIONE(model.getListBox("ID_SEZIONE"));
            readID_RILEVANZA(model.getListBox("ID_RILEVANZA"));
            readTIPO_TESTO(model.getRadioButton("TIPO_TESTO"));
            readLINK_ITER(model.getRadioButton("LINK_ITER"));
            readLINK_INOLTRO(model.getRadioButton("LINK_INOLTRO"));
            readALLEGATO(model.getListBox("ALLEGATO"));
//End AMV_DOCUMENTI Record: children actions

//AMV_DOCUMENTI Record: method perform tail @5-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AMV_DOCUMENTI Record: method perform tail

//Insert Button @6-BA032DC0
        void Insert6Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Insert");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmRevisioniElenco" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            InsertAction();
        }
//End Insert Button

//Update Button @7-02A7E526
        void Update7Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( page.getActionPageName() + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Update Button

//Delete Button @8-81BD7C32
        void Delete8Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Delete");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( page.getActionPageName() + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            DeleteAction();
        }
//End Delete Button

//Cancel Button @9-F3AF3A88
        void Cancel9Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Cancel");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( page.getActionPageName() + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
        }
//End Cancel Button

//ListBoxAction @105-3814E714
        protected void readID_AREA(com.codecharge.components.ListBox model) {

            TextField sesUtente = new TextField(null, null);
            
            sesUtente.setValue( SessionStorage.getInstance(req).getAttribute("Utente") );
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "SELECT to_number(null) ID_AREA,  "
                        + "' - -' NOME "
                        + "FROM DUAL "
                        + "UNION "
                        + "SELECT DISTINCT ID_AREA, AMV_AREE.NOME "
                        + "FROM AMV_AREE,  "
                        + "AMV_TIPOLOGIE WHERE  "
                        + "amv_documento.get_diritto_area('{Utente}',ID_AREA, ID_TIPOLOGIA) in ('C','U','V','A') "
                        + "" );
            if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
            command.addParameter( "Utente", sesUtente, null );
            command.setOrder( "NOME" );

            model.fireBeforeBuildSelectEvent( e );




            model.fireBeforeExecuteSelectEvent( e );

            Enumeration records = null;
            if ( ! ds.hasErrors() ) {
                model.setOptions( command.getRows(), ds );
            }

            CCLogger.getInstance().debug(command.toString());

            model.fireAfterExecuteSelectEvent( e );

            ds.closeConnection();
        }
//End ListBoxAction

//ListBoxAction @103-B0BFE7FA
        protected void readID_TIPOLOGIA(com.codecharge.components.ListBox model) {

            TextField sesUtente = new TextField(null, null);
            
            sesUtente.setValue( SessionStorage.getInstance(req).getAttribute("Utente") );
            LongField postID_AREA = new LongField(null, null);
            
            try {
                postID_AREA.setValue( page.getHttpPostParams().getParameter("ID_AREA"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter" );
                return;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter" );
                return;
            }
            LongField urlID = new LongField(null, null);
            
            try {
                urlID.setValue( page.getHttpGetParams().getParameter("ID"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter" );
                return;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter" );
                return;
            }
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "SELECT to_number(null) ID_TIPOLOGIA,  "
                        + "' - -' NOME "
                        + "FROM DUAL "
                        + "UNION "
                        + "SELECT DISTINCT ID_TIPOLOGIA, AMV_TIPOLOGIE.NOME "
                        + "FROM AMV_AREE,  "
                        + "AMV_TIPOLOGIE WHERE  "
                        + "amv_documento.get_diritto_area('{Utente}',ID_AREA,  "
                        + "ID_TIPOLOGIA) in ('C','U','V','A') "
                        + "and ID_AREA =  "
                        + "(select nvl({ID_AREA},  "
                        + "max(ID_AREA))  "
                        + "from AMV_DOCUMENTI where id_documento = {ID}) "
                        + "" );
            if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
            command.addParameter( "Utente", sesUtente, null );
            if ( postID_AREA.getObjectValue() == null ) postID_AREA.setValue( null );
            command.addParameter( "ID_AREA", postID_AREA, null );
            if ( urlID.getObjectValue() == null ) urlID.setValue( -1 );
            command.addParameter( "ID", urlID, null );
            command.setOrder( "NOME" );

            model.fireBeforeBuildSelectEvent( e );




            model.fireBeforeExecuteSelectEvent( e );

            Enumeration records = null;
            if ( ! ds.hasErrors() ) {
                model.setOptions( command.getRows(), ds );
            }

            CCLogger.getInstance().debug(command.toString());

            model.fireAfterExecuteSelectEvent( e );

            ds.closeConnection();
        }
//End ListBoxAction

//ListBoxAction @102-DBA1847B
        protected void readID_CATEGORIA(com.codecharge.components.ListBox model) {
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "SELECT *  "
                        + "FROM AMV_CATEGORIE" );
            command.setOrder( "NOME" );

            model.fireBeforeBuildSelectEvent( e );




            model.fireBeforeExecuteSelectEvent( e );

            Enumeration records = null;
            if ( ! ds.hasErrors() ) {
                model.setOptions( command.getRows(), ds );
            }

            CCLogger.getInstance().debug(command.toString());

            model.fireAfterExecuteSelectEvent( e );

            ds.closeConnection();
        }
//End ListBoxAction

//ListBoxAction @101-1EEDCB96
        protected void readID_ARGOMENTO(com.codecharge.components.ListBox model) {
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "SELECT *  "
                        + "FROM AMV_ARGOMENTI" );
            command.setOrder( "NOME" );

            model.fireBeforeBuildSelectEvent( e );




            model.fireBeforeExecuteSelectEvent( e );

            Enumeration records = null;
            if ( ! ds.hasErrors() ) {
                model.setOptions( command.getRows(), ds );
            }

            CCLogger.getInstance().debug(command.toString());

            model.fireAfterExecuteSelectEvent( e );

            ds.closeConnection();
        }
//End ListBoxAction

//ListBoxAction @134-E8F45C16
        protected void readID_SEZIONE(com.codecharge.components.ListBox model) {

            TextField sesUtente = new TextField(null, null);
            
            sesUtente.setValue( SessionStorage.getInstance(req).getAttribute("Utente") );
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "select id_sezione,  "
                        + "nome from AMV_SEZIONI "
                        + "where decode(id_area,'','R',amv_area.get_diritto_utente('{Utente}', id_area)) in ('R','C','V','A','U')" );
            if ( StringUtils.isEmpty( (String) sesUtente.getObjectValue() ) ) sesUtente.setValue( "" );
            command.addParameter( "Utente", sesUtente, null );
            command.setOrder( "" );

            model.fireBeforeBuildSelectEvent( e );




            model.fireBeforeExecuteSelectEvent( e );

            Enumeration records = null;
            if ( ! ds.hasErrors() ) {
                model.setOptions( command.getRows(), ds );
            }

            CCLogger.getInstance().debug(command.toString());

            model.fireAfterExecuteSelectEvent( e );

            ds.closeConnection();
        }
//End ListBoxAction

//ListBoxAction @100-35C6EDC6
        protected void readID_RILEVANZA(com.codecharge.components.ListBox model) {
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "SELECT *  "
                        + "FROM AMV_RILEVANZE" );
            command.setOrder( "IMPORTANZA" );

            model.fireBeforeBuildSelectEvent( e );




            model.fireBeforeExecuteSelectEvent( e );

            Enumeration records = null;
            if ( ! ds.hasErrors() ) {
                model.setOptions( command.getRows(), ds );
            }

            CCLogger.getInstance().debug(command.toString());

            model.fireAfterExecuteSelectEvent( e );

            ds.closeConnection();
        }
//End ListBoxAction

//RadioButtonAction @118-22719EC4
        protected void readTIPO_TESTO(com.codecharge.components.RadioButton model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( "Testo;Testo/HTML;Link;Link;Form;Modello inserimento" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End RadioButtonAction

//RadioButtonAction @161-7B97FD66
        protected void readLINK_ITER(com.codecharge.components.RadioButton model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( "V;Verifica e Approvazione;A;Solo Approvazione;N;Senza Approvazione" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End RadioButtonAction

//RadioButtonAction @164-92F81183
        protected void readLINK_INOLTRO(com.codecharge.components.RadioButton model) {
            DataObjectEvent e = new DataObjectEvent();
            e.setSql( "I;Immediato;P;da Pagina" );
            model.fireBeforeBuildSelectEvent(e);
            model.fireBeforeExecuteSelectEvent(e);
            model.setListOfValues( e.getSql() );
            model.fireAfterExecuteSelectEvent(e);
        }
//End RadioButtonAction

//ListBoxAction @150-82E25643
        protected void readALLEGATO(com.codecharge.components.ListBox model) {

            DoubleField urlID = new DoubleField(null, null);
            
            try {
                urlID.setValue( page.getHttpGetParams().getParameter("ID"), page.getCCSLocale().getFormat("Float") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter" );
                return;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter" );
                return;
            }
            LongField urlREV = new LongField(null, null);
            
            try {
                urlREV.setValue( page.getHttpGetParams().getParameter("REV"), page.getCCSLocale().getFormat("Integer") );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter" );
                return;
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter" );
                return;
            }
            JDBCConnection ds = JDBCConnectionFactory.getJDBCConnection( "cn" );
            ds.setLocale(page.getCCSLocale().getLocale());
            RawCommand command = new RawCommand( ds );

            DataObjectEvent e = new DataObjectEvent();
            e.setSource(model);
            e.setCommand(command);
            e.setConnection(ds);
            command.setOptimizeSQL(false);

            command.setSql( "select b.NOME nome, b.id_blob id_blob "
                        + "  from AMV_DOCUMENTI_BLOB doc_blob,  "
                        + " "
                        + "       AMV_BLOB b "
                        + " where doc_blob.ID_DOCUMENTO  = {ID} "
                        + "   and doc_blob.REVISIONE = {REV} "
                        + "   and doc_blob.ID_BLOB = b.ID_BLOB "
                        + " " );
            if ( urlID.getObjectValue() == null ) urlID.setValue( 0 );
            command.addParameter( "ID", urlID, null );
            if ( urlREV.getObjectValue() == null ) urlREV.setValue( 0 );
            command.addParameter( "REV", urlREV, null );
            command.setOrder( "nome" );

            model.fireBeforeBuildSelectEvent( e );




            model.fireBeforeExecuteSelectEvent( e );

            Enumeration records = null;
            if ( ! ds.hasErrors() ) {
                model.setOptions( command.getRows(), ds );
            }

            CCLogger.getInstance().debug(command.toString());

            model.fireAfterExecuteSelectEvent( e );

            ds.closeConnection();
        }
//End ListBoxAction

void read() { //AMV_DOCUMENTI Record: method read @5-7F8AAE5A

//AMV_DOCUMENTI Record: method read head @5-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AMV_DOCUMENTI Record: method read head

//AMV_DOCUMENTI Record: init DataSource @5-AA60C921
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AMV_DOCUMENTIDataObject ds = new AMV_DOCUMENTIDataObject(page);
            ds.setComponent( model );
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
            }
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            try {
                ds.setPostID_AREA( page.getHttpPostParams().getParameter("ID_AREA"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID_AREA'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID_AREA'" );
            }
            ds.setPostTITOLO( page.getHttpPostParams().getParameter("TITOLO") );
            ds.setPostLINK( page.getHttpPostParams().getParameter("LINK") );
            ds.setPostTIPO_TESTO( page.getHttpPostParams().getParameter("TIPO_TESTO") );
            try {
                ds.setUrlREV( page.getHttpGetParams().getParameter("REV"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'REV'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'REV'" );
            }
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End AMV_DOCUMENTI Record: init DataSource

//AMV_DOCUMENTI Record: check errors @5-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AMV_DOCUMENTI Record: check errors

} //AMV_DOCUMENTI Record: method read tail @5-FCB6E20C

//AMV_DOCUMENTI Record: bind @5-5F1C9130
            public void bind(com.codecharge.components.Component model, AMV_DOCUMENTIRow row ) {
                if ( model == null || row == null ) return;
                model.getControl("REVISIONE_LABEL").setValue(row.getREVISIONE_LABEL());
                model.getControl("STATO_DOCUMENTO").setValue(row.getSTATO_DOCUMENTO());
                model.getControl("FLUSSO").setValue(row.getFLUSSO());
                model.getControl("CRONOLOGIA").setValue(row.getCRONOLOGIA());
                model.getControl("NOTE").setValue(row.getNOTE());
                model.getControl("ALLEGATI").setValue(row.getALLEGATI());
                if ( this.valid ) {
                    model.getControl("ID_DOCUMENTO").setValue(row.getID_DOCUMENTO());
                    model.getControl("REVISIONE").setValue(row.getREVISIONE());
                    model.getControl("STATO").setValue(row.getSTATO());
                    model.getControl("TITOLO").setValue(row.getTITOLO());
                    model.getControl("DATA_INSERIMENTO").setValue(row.getDATA_INSERIMENTO());
                    model.getControl("AUTORE").setValue(row.getAUTORE());
                    model.getControl("DATA_AGGIORNAMENTO").setValue(row.getDATA_AGGIORNAMENTO());
                    model.getControl("UTENTE_AGGIORNAMENTO").setValue(row.getUTENTE_AGGIORNAMENTO());
                    model.getControl("ID_AREA").setValue(row.getID_AREA());
                    model.getControl("ID_AREA_SEL").setValue(row.getID_AREA_SEL());
                    model.getControl("ID_TIPOLOGIA").setValue(row.getID_TIPOLOGIA());
                    model.getControl("ID_CATEGORIA").setValue(row.getID_CATEGORIA());
                    model.getControl("ID_ARGOMENTO").setValue(row.getID_ARGOMENTO());
                    model.getControl("ID_SEZIONE").setValue(row.getID_SEZIONE());
                    model.getControl("ID_RILEVANZA").setValue(row.getID_RILEVANZA());
                    model.getControl("SEQUENZA").setValue(row.getSEQUENZA());
                    model.getControl("DATA_RIFERIMENTO").setValue(row.getDATA_RIFERIMENTO());
                    model.getControl("INIZIO_PUBBLICAZIONE").setValue(row.getINIZIO_PUBBLICAZIONE());
                    model.getControl("FINE_PUBBLICAZIONE").setValue(row.getFINE_PUBBLICAZIONE());
                    model.getControl("TIPO_TESTO").setValue(row.getTIPO_TESTO());
                    model.getControl("TESTO").setValue(row.getTESTO());
                    model.getControl("TESTOXQUERY").setValue(row.getTESTOXQUERY());
                    model.getControl("LINKURL").setValue(row.getLINKURL());
                    model.getControl("CR").setValue(row.getCR());
                    model.getControl("XML").setValue(row.getXML());
                    model.getControl("ABSTRACT").setValue(row.getABSTRACT());
                    model.getControl("LINKMR").setValue(row.getLINKMR());
                    model.getControl("LINKMA").setValue(row.getLINKMA());
                    model.getControl("LINK_ITER").setValue(row.getLINK_ITER());
                    model.getControl("LINK_INOLTRO").setValue(row.getLINK_INOLTRO());
                    model.getControl("LINKDATASOURCE").setValue(row.getLINKDATASOURCE());
                    model.getControl("IMMAGINE").setValue(row.getIMMAGINE());
                    model.getControl("ICONA").setValue(row.getICONA());
                }
            }
//End AMV_DOCUMENTI Record: bind

//AMV_DOCUMENTI Record: getRowFieldByName @5-36CDE493
            public Object getRowFieldByName( String name, AMV_DOCUMENTIRow row ) {
                Object value = null;
                if ( "RECORD_TITLE".equals(name) ) {
                    value = row.getRECORD_TITLE();
                } else if ( "ID_DOCUMENTO".equals(name) ) {
                    value = row.getID_DOCUMENTO();
                } else if ( "REVISIONE".equals(name) ) {
                    value = row.getREVISIONE();
                } else if ( "STATO".equals(name) ) {
                    value = row.getSTATO();
                } else if ( "TITOLO".equals(name) ) {
                    value = row.getTITOLO();
                } else if ( "REVISIONE_LABEL".equals(name) ) {
                    value = row.getREVISIONE_LABEL();
                } else if ( "STATO_DOCUMENTO".equals(name) ) {
                    value = row.getSTATO_DOCUMENTO();
                } else if ( "FLUSSO".equals(name) ) {
                    value = row.getFLUSSO();
                } else if ( "DATA_INSERIMENTO".equals(name) ) {
                    value = row.getDATA_INSERIMENTO();
                } else if ( "AUTORE".equals(name) ) {
                    value = row.getAUTORE();
                } else if ( "DATA_AGGIORNAMENTO".equals(name) ) {
                    value = row.getDATA_AGGIORNAMENTO();
                } else if ( "UTENTE_AGGIORNAMENTO".equals(name) ) {
                    value = row.getUTENTE_AGGIORNAMENTO();
                } else if ( "CRONOLOGIA".equals(name) ) {
                    value = row.getCRONOLOGIA();
                } else if ( "NOTE".equals(name) ) {
                    value = row.getNOTE();
                } else if ( "ID_AREA".equals(name) ) {
                    value = row.getID_AREA();
                } else if ( "ID_AREA_SEL".equals(name) ) {
                    value = row.getID_AREA_SEL();
                } else if ( "ID_TIPOLOGIA".equals(name) ) {
                    value = row.getID_TIPOLOGIA();
                } else if ( "ID_CATEGORIA".equals(name) ) {
                    value = row.getID_CATEGORIA();
                } else if ( "ID_ARGOMENTO".equals(name) ) {
                    value = row.getID_ARGOMENTO();
                } else if ( "ID_SEZIONE".equals(name) ) {
                    value = row.getID_SEZIONE();
                } else if ( "ID_RILEVANZA".equals(name) ) {
                    value = row.getID_RILEVANZA();
                } else if ( "SEQUENZA".equals(name) ) {
                    value = row.getSEQUENZA();
                } else if ( "DATA_RIFERIMENTO".equals(name) ) {
                    value = row.getDATA_RIFERIMENTO();
                } else if ( "INIZIO_PUBBLICAZIONE".equals(name) ) {
                    value = row.getINIZIO_PUBBLICAZIONE();
                } else if ( "FINE_PUBBLICAZIONE".equals(name) ) {
                    value = row.getFINE_PUBBLICAZIONE();
                } else if ( "TIPO_TESTO".equals(name) ) {
                    value = row.getTIPO_TESTO();
                } else if ( "TESTO".equals(name) ) {
                    value = row.getTESTO();
                } else if ( "TESTOXQUERY".equals(name) ) {
                    value = row.getTESTOXQUERY();
                } else if ( "LINKURL".equals(name) ) {
                    value = row.getLINKURL();
                } else if ( "CR".equals(name) ) {
                    value = row.getCR();
                } else if ( "LINK".equals(name) ) {
                    value = row.getLINK();
                } else if ( "XML".equals(name) ) {
                    value = row.getXML();
                } else if ( "ABSTRACT".equals(name) ) {
                    value = row.getABSTRACT();
                } else if ( "LINKMR".equals(name) ) {
                    value = row.getLINKMR();
                } else if ( "LINKMA".equals(name) ) {
                    value = row.getLINKMA();
                } else if ( "LINK_ITER".equals(name) ) {
                    value = row.getLINK_ITER();
                } else if ( "LINK_INOLTRO".equals(name) ) {
                    value = row.getLINK_INOLTRO();
                } else if ( "LINKDATASOURCE".equals(name) ) {
                    value = row.getLINKDATASOURCE();
                } else if ( "IMMAGINE".equals(name) ) {
                    value = row.getIMMAGINE();
                } else if ( "ICONA".equals(name) ) {
                    value = row.getICONA();
                } else if ( "ALLEGATI".equals(name) ) {
                    value = row.getALLEGATI();
                } else if ( "FILE_UPLOAD".equals(name) ) {
                    value = row.getFILE_UPLOAD();
                } else if ( "ALLEGATO".equals(name) ) {
                    value = row.getALLEGATO();
                }
                return value;
            }
//End AMV_DOCUMENTI Record: getRowFieldByName

void InsertAction() { //AMV_DOCUMENTI Record: method insert @5-11643485

//AMV_DOCUMENTI Record: method insert head @5-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End AMV_DOCUMENTI Record: method insert head

//AMV_DOCUMENTI Record: method insert body @5-EF083BE9
            if (!model.isAllowInsert()) return;
            boolean isErrors = false;
            AMV_DOCUMENTIDataObject ds = new AMV_DOCUMENTIDataObject(page);
            ds.setComponent( model );
            AMV_DOCUMENTIRow row = new AMV_DOCUMENTIRow();
            ds.setRow(row);
            try {
                ds.setUrlP_ID_DOCUMENTO( page.getHttpGetParams().getParameter("P_ID_DOCUMENTO"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'P_ID_DOCUMENTO'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'P_ID_DOCUMENTO'" );
            }
            try {
                ds.setPostID_TIPOLOGIA( page.getHttpPostParams().getParameter("ID_TIPOLOGIA"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID_TIPOLOGIA'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID_TIPOLOGIA'" );
            }
            try {
                ds.setPostID_CATEGORIA( page.getHttpPostParams().getParameter("ID_CATEGORIA"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID_CATEGORIA'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID_CATEGORIA'" );
            }
            try {
                ds.setPostID_ARGOMENTO( page.getHttpPostParams().getParameter("ID_ARGOMENTO"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID_ARGOMENTO'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID_ARGOMENTO'" );
            }
            try {
                ds.setPostID_RILEVANZA( page.getHttpPostParams().getParameter("ID_RILEVANZA"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID_RILEVANZA'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID_RILEVANZA'" );
            }
            try {
                ds.setPostID_AREA( page.getHttpPostParams().getParameter("ID_AREA"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID_AREA'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID_AREA'" );
            }
            ds.setPostTITOLO( page.getHttpPostParams().getParameter("TITOLO") );
            ds.setPostTIPO_TESTO( page.getHttpPostParams().getParameter("TIPO_TESTO") );
            ds.setUrlTESTO( page.getHttpGetParams().getParameter("TESTO") );
            row.setABSTRACT(Utils.convertToString(model.getControl("ABSTRACT").getValue()));
            row.setLINK(Utils.convertToString(model.getControl("LINK").getValue()));
            ds.setPostIMMAGINE( page.getHttpPostParams().getParameter("IMMAGINE") );
            ds.setPostICONA( page.getHttpPostParams().getParameter("ICONA") );
            try {
                ds.setPostDATA_RIFERIMENTO( page.getHttpPostParams().getParameter("DATA_RIFERIMENTO"), new java.text.SimpleDateFormat("dd/MM/yyyy", page.getLocale()) );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'DATA_RIFERIMENTO'" );
            }
            try {
                ds.setPostINIZIO_PUBBLICAZIONE( page.getHttpPostParams().getParameter("INIZIO_PUBBLICAZIONE"), new java.text.SimpleDateFormat("dd/MM/yyyy", page.getLocale()) );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'INIZIO_PUBBLICAZIONE'" );
            }
            try {
                ds.setPostFINE_PUBBLICAZIONE( page.getHttpPostParams().getParameter("FINE_PUBBLICAZIONE"), new java.text.SimpleDateFormat("dd/MM/yyyy", page.getLocale()) );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'FINE_PUBBLICAZIONE'" );
            }
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            try {
                ds.setPostREVISIONE( page.getHttpPostParams().getParameter("REVISIONE"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'REVISIONE'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'REVISIONE'" );
            }
            try {
                ds.setPostID_SEZIONE( page.getHttpPostParams().getParameter("ID_SEZIONE"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID_SEZIONE'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID_SEZIONE'" );
            }
            try {
                ds.setPostSEQUENZA( page.getHttpPostParams().getParameter("SEQUENZA"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'SEQUENZA'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'SEQUENZA'" );
            }
//End AMV_DOCUMENTI Record: method insert body

//AMV_DOCUMENTI Record: ds.insert @5-9320B03B
//Rev.1 : gestione parametri output della procedure custom AFC 
			Collection cParam = null;		
            cParam = ds.insert();
			req.setAttribute("INSERIMENTO","ok");
            //ds.insert();
            if ( ! ds.hasErrors() ) {
	  			Object params[] = cParam.toArray();
        		//ID_DOCUMENTO
				if ( params[0] != null ) {
		        	req.setAttribute("ID_DOCUMENTO", ((Parameter)params[0]).getObjectValue());
				}
            }
//Rev.1 : fine 
            model.fireAfterInsertEvent();
            action = true;
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
                this.valid = false;
            }
//End AMV_DOCUMENTI Record: ds.insert

} //AMV_DOCUMENTI Record: method insert tail @5-FCB6E20C

void UpdateAction() { //AMV_DOCUMENTI Record: method update @5-5771D0AA

//AMV_DOCUMENTI Record: method update head @5-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AMV_DOCUMENTI Record: method update head

//AMV_DOCUMENTI Record: method update body @5-A4C45D85
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AMV_DOCUMENTIDataObject ds = new AMV_DOCUMENTIDataObject(page);
            ds.setComponent( model );
            AMV_DOCUMENTIRow row = new AMV_DOCUMENTIRow();
            ds.setRow(row);
            try {
                ds.setPostID_DOCUMENTO( page.getHttpPostParams().getParameter("ID_DOCUMENTO"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID_DOCUMENTO'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID_DOCUMENTO'" );
            }
            try {
                ds.setPostID_TIPOLOGIA( page.getHttpPostParams().getParameter("ID_TIPOLOGIA"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID_TIPOLOGIA'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID_TIPOLOGIA'" );
            }
            try {
                ds.setPostID_CATEGORIA( page.getHttpPostParams().getParameter("ID_CATEGORIA"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID_CATEGORIA'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID_CATEGORIA'" );
            }
            try {
                ds.setPostID_ARGOMENTO( page.getHttpPostParams().getParameter("ID_ARGOMENTO"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID_ARGOMENTO'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID_ARGOMENTO'" );
            }
            try {
                ds.setPostID_RILEVANZA( page.getHttpPostParams().getParameter("ID_RILEVANZA"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID_RILEVANZA'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID_RILEVANZA'" );
            }
            try {
                ds.setPostID_AREA( page.getHttpPostParams().getParameter("ID_AREA"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID_AREA'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID_AREA'" );
            }
            ds.setPostTITOLO( page.getHttpPostParams().getParameter("TITOLO") );
            ds.setPostTIPO_TESTO( page.getHttpPostParams().getParameter("TIPO_TESTO") );
            ds.setUrlTESTO( page.getHttpGetParams().getParameter("TESTO") );
            row.setABSTRACT(Utils.convertToString(model.getControl("ABSTRACT").getValue()));
            row.setLINK(Utils.convertToString(model.getControl("LINK").getValue()));
            ds.setPostIMMAGINE( page.getHttpPostParams().getParameter("IMMAGINE") );
            row.setICONA(Utils.convertToString(model.getControl("ICONA").getValue()));
            try {
                ds.setPostALLEGATO( page.getHttpPostParams().getParameter("ALLEGATO"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ALLEGATO'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ALLEGATO'" );
            }
            try {
                ds.setPostDATA_RIFERIMENTO( page.getHttpPostParams().getParameter("DATA_RIFERIMENTO"), new java.text.SimpleDateFormat("dd/MM/yyyy", page.getLocale()) );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'DATA_RIFERIMENTO'" );
            }
            try {
                ds.setPostINIZIO_PUBBLICAZIONE( page.getHttpPostParams().getParameter("INIZIO_PUBBLICAZIONE"), new java.text.SimpleDateFormat("dd/MM/yyyy", page.getLocale()) );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'INIZIO_PUBBLICAZIONE'" );
            }
            try {
                ds.setPostFINE_PUBBLICAZIONE( page.getHttpPostParams().getParameter("FINE_PUBBLICAZIONE"), new java.text.SimpleDateFormat("dd/MM/yyyy", page.getLocale()) );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'FINE_PUBBLICAZIONE'" );
            }
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            try {
                ds.setPostREVISIONE( page.getHttpPostParams().getParameter("REVISIONE"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'REVISIONE'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'REVISIONE'" );
            }
            try {
                ds.setPostID_SEZIONE( page.getHttpPostParams().getParameter("ID_SEZIONE"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID_SEZIONE'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID_SEZIONE'" );
            }
            try {
                ds.setPostSEQUENZA( page.getHttpPostParams().getParameter("SEQUENZA"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'SEQUENZA'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'SEQUENZA'" );
            }
//End AMV_DOCUMENTI Record: method update body

//AMV_DOCUMENTI Record: ds.update @5-6E956EDC
            ds.update();
            if ( ! ds.hasErrors() ) {
            }
            model.fireAfterUpdateEvent();
            action = true;
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
                this.valid = false;
            }
//End AMV_DOCUMENTI Record: ds.update

} //AMV_DOCUMENTI Record: method update tail @5-FCB6E20C

void DeleteAction() { //AMV_DOCUMENTI Record: method delete @5-11FC2E1E

//AMV_DOCUMENTI Record: method delete head @5-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End AMV_DOCUMENTI Record: method delete head

//AMV_DOCUMENTI Record: method delete body @5-F9A294FF
            if (!model.isAllowDelete()) return;
            boolean isErrors = false;
            AMV_DOCUMENTIDataObject ds = new AMV_DOCUMENTIDataObject(page);
            ds.setComponent( model );
            AMV_DOCUMENTIRow row = new AMV_DOCUMENTIRow();
            ds.setRow(row);
            try {
                ds.setPostID_DOCUMENTO( page.getHttpPostParams().getParameter("ID_DOCUMENTO"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID_DOCUMENTO'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID_DOCUMENTO'" );
            }
            try {
                ds.setPostREVISIONE( page.getHttpPostParams().getParameter("REVISIONE"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'REVISIONE'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'REVISIONE'" );
            }
            ds.setPostSTATO( page.getHttpPostParams().getParameter("STATO") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
//End AMV_DOCUMENTI Record: method delete body

//AMV_DOCUMENTI Record: ds.delete @5-3584344F
            ds.delete();
            if ( ! ds.hasErrors() ) {
            }
            model.fireAfterDeleteEvent();
            action = true;
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
                this.valid = false;
            }
//End AMV_DOCUMENTI Record: ds.delete

} //AMV_DOCUMENTI Record: method delete tail @5-FCB6E20C

//AMV_DOCUMENTI Record: method validate @5-21B5D10F
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.Hidden ID_DOCUMENTO = (com.codecharge.components.Hidden) model.getChild( "ID_DOCUMENTO" );
            if (! ID_DOCUMENTO.validate()) { isControlError = true; }

            com.codecharge.components.Hidden REVISIONE = (com.codecharge.components.Hidden) model.getChild( "REVISIONE" );
            if (! REVISIONE.validate()) { isControlError = true; }

            com.codecharge.components.Hidden STATO = (com.codecharge.components.Hidden) model.getChild( "STATO" );
            if (! STATO.validate()) { isControlError = true; }

            com.codecharge.components.TextBox TITOLO = (com.codecharge.components.TextBox) model.getChild( "TITOLO" );
            if (! TITOLO.validate()) { isControlError = true; }

            com.codecharge.components.TextBox DATA_INSERIMENTO = (com.codecharge.components.TextBox) model.getChild( "DATA_INSERIMENTO" );
            if (! DATA_INSERIMENTO.validate()) { isControlError = true; }

            com.codecharge.components.TextBox AUTORE = (com.codecharge.components.TextBox) model.getChild( "AUTORE" );
            if (! AUTORE.validate()) { isControlError = true; }

            com.codecharge.components.TextBox DATA_AGGIORNAMENTO = (com.codecharge.components.TextBox) model.getChild( "DATA_AGGIORNAMENTO" );
            if (! DATA_AGGIORNAMENTO.validate()) { isControlError = true; }

            com.codecharge.components.TextBox UTENTE_AGGIORNAMENTO = (com.codecharge.components.TextBox) model.getChild( "UTENTE_AGGIORNAMENTO" );
            if (! UTENTE_AGGIORNAMENTO.validate()) { isControlError = true; }

            com.codecharge.components.ListBox ID_AREA = (com.codecharge.components.ListBox) model.getChild( "ID_AREA" );
            if (! ID_AREA.validate()) { isControlError = true; }

            com.codecharge.components.Hidden ID_AREA_SEL = (com.codecharge.components.Hidden) model.getChild( "ID_AREA_SEL" );
            if (! ID_AREA_SEL.validate()) { isControlError = true; }

            com.codecharge.components.ListBox ID_TIPOLOGIA = (com.codecharge.components.ListBox) model.getChild( "ID_TIPOLOGIA" );
            if (! ID_TIPOLOGIA.validate()) { isControlError = true; }

            com.codecharge.components.ListBox ID_CATEGORIA = (com.codecharge.components.ListBox) model.getChild( "ID_CATEGORIA" );
            if (! ID_CATEGORIA.validate()) { isControlError = true; }

            com.codecharge.components.ListBox ID_ARGOMENTO = (com.codecharge.components.ListBox) model.getChild( "ID_ARGOMENTO" );
            if (! ID_ARGOMENTO.validate()) { isControlError = true; }

            com.codecharge.components.ListBox ID_SEZIONE = (com.codecharge.components.ListBox) model.getChild( "ID_SEZIONE" );
            if (! ID_SEZIONE.validate()) { isControlError = true; }

            com.codecharge.components.ListBox ID_RILEVANZA = (com.codecharge.components.ListBox) model.getChild( "ID_RILEVANZA" );
            if (! ID_RILEVANZA.validate()) { isControlError = true; }

            com.codecharge.components.TextBox SEQUENZA = (com.codecharge.components.TextBox) model.getChild( "SEQUENZA" );
            if (! SEQUENZA.validate()) { isControlError = true; }

            com.codecharge.components.TextBox DATA_RIFERIMENTO = (com.codecharge.components.TextBox) model.getChild( "DATA_RIFERIMENTO" );
            if (! DATA_RIFERIMENTO.validate()) { isControlError = true; }

            com.codecharge.components.TextBox INIZIO_PUBBLICAZIONE = (com.codecharge.components.TextBox) model.getChild( "INIZIO_PUBBLICAZIONE" );
            if (! INIZIO_PUBBLICAZIONE.validate()) { isControlError = true; }

            com.codecharge.components.TextBox FINE_PUBBLICAZIONE = (com.codecharge.components.TextBox) model.getChild( "FINE_PUBBLICAZIONE" );
            if (! FINE_PUBBLICAZIONE.validate()) { isControlError = true; }

            com.codecharge.components.RadioButton TIPO_TESTO = (com.codecharge.components.RadioButton) model.getChild( "TIPO_TESTO" );
            if (! TIPO_TESTO.validate()) { isControlError = true; }

            com.codecharge.components.TextArea TESTO = (com.codecharge.components.TextArea) model.getChild( "TESTO" );
            if (! TESTO.validate()) { isControlError = true; }

            com.codecharge.components.TextArea TESTOXQUERY = (com.codecharge.components.TextArea) model.getChild( "TESTOXQUERY" );
            if (! TESTOXQUERY.validate()) { isControlError = true; }

            com.codecharge.components.TextBox LINKURL = (com.codecharge.components.TextBox) model.getChild( "LINKURL" );
            if (! LINKURL.validate()) { isControlError = true; }

            com.codecharge.components.Hidden CR = (com.codecharge.components.Hidden) model.getChild( "CR" );
            if (! CR.validate()) { isControlError = true; }

            com.codecharge.components.Hidden LINK = (com.codecharge.components.Hidden) model.getChild( "LINK" );
            if (! LINK.validate()) { isControlError = true; }

            com.codecharge.components.TextArea XML = (com.codecharge.components.TextArea) model.getChild( "XML" );
            if (! XML.validate()) { isControlError = true; }

            com.codecharge.components.TextArea ABSTRACT = (com.codecharge.components.TextArea) model.getChild( "ABSTRACT" );
            if (! ABSTRACT.validate()) { isControlError = true; }

            com.codecharge.components.TextBox LINKMR = (com.codecharge.components.TextBox) model.getChild( "LINKMR" );
            if (! LINKMR.validate()) { isControlError = true; }

            com.codecharge.components.TextBox LINKMA = (com.codecharge.components.TextBox) model.getChild( "LINKMA" );
            if (! LINKMA.validate()) { isControlError = true; }

            com.codecharge.components.RadioButton LINK_ITER = (com.codecharge.components.RadioButton) model.getChild( "LINK_ITER" );
            if (! LINK_ITER.validate()) { isControlError = true; }

            com.codecharge.components.RadioButton LINK_INOLTRO = (com.codecharge.components.RadioButton) model.getChild( "LINK_INOLTRO" );
            if (! LINK_INOLTRO.validate()) { isControlError = true; }

            com.codecharge.components.TextBox LINKDATASOURCE = (com.codecharge.components.TextBox) model.getChild( "LINKDATASOURCE" );
            if (! LINKDATASOURCE.validate()) { isControlError = true; }

            com.codecharge.components.TextBox IMMAGINE = (com.codecharge.components.TextBox) model.getChild( "IMMAGINE" );
            if (! IMMAGINE.validate()) { isControlError = true; }

            com.codecharge.components.TextBox ICONA = (com.codecharge.components.TextBox) model.getChild( "ICONA" );
            if (! ICONA.validate()) { isControlError = true; }

            com.codecharge.components.ListBox ALLEGATO = (com.codecharge.components.ListBox) model.getChild( "ALLEGATO" );
            if (! ALLEGATO.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AMV_DOCUMENTI Record: method validate

//AMV_DOCUMENTI Record Tail @5-FCB6E20C
    }
//End AMV_DOCUMENTI Record Tail

//AdmDocumento Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmDocumento Page: method validate

//AdmDocumentoAction Tail @1-FCB6E20C
}
//End AdmDocumentoAction Tail
