//AdmRevisioneNuovaAction imports @1-B75A57F9
package amvadm.AdmRevisioneNuova;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmRevisioneNuovaAction imports

//AdmRevisioneNuovaAction class @1-14E287B3
public class AdmRevisioneNuovaAction extends Action {

//End AdmRevisioneNuovaAction class

//AdmRevisioneNuovaAction: method perform @1-0447D061
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmRevisioneNuovaModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmRevisioneNuovaModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmRevisioneNuovaAction: method perform

//AdmRevisioneNuovaAction: call children actions @1-6DDFB007
        if ( page.getChild( "Header" ).isVisible() ) {
            page.getRequest().setAttribute("HeaderParent",page);
            common.Header.HeaderAction Header = new common.Header.HeaderAction();
            result = result != null ? result : Header.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "Left" ).isVisible() ) {
            page.getRequest().setAttribute("LeftParent",page);
            common.Left.LeftAction Left = new common.Left.LeftAction();
            result = result != null ? result : Left.perform( req, resp,  context );
            page.setCookies();
        }
        if ( page.getChild( "Guida" ).isVisible() ) {
            page.getRequest().setAttribute("GuidaParent",page);
            common.Guida.GuidaAction Guida = new common.Guida.GuidaAction();
            result = result != null ? result : Guida.perform( req, resp,  context );
            page.setCookies();
        }
        if (result == null) {
            NUOVA_REVISIONEClass NUOVA_REVISIONE = new NUOVA_REVISIONEClass();
            if ( ( redirect = NUOVA_REVISIONE.perform( page.getRecord("NUOVA_REVISIONE")) ) != null ) result = redirect;
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
//End AdmRevisioneNuovaAction: call children actions

//NUOVA_REVISIONE Record @6-1FBA55B5
    final class NUOVA_REVISIONEClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End NUOVA_REVISIONE Record

//NUOVA_REVISIONE Record: method perform @6-A6FC1AD9
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AdmRevisioniElenco" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowInsert() ) model.getChild( "Button_Insert" ).setVisible( false );
            if ( ! model.isAllowUpdate() ) model.getChild( "Button_Update" ).setVisible( false );
            if ( ! model.isAllowDelete() ) model.getChild( "Button_Delete" ).setVisible( false );
//End NUOVA_REVISIONE Record: method perform

//NUOVA_REVISIONE Record: children actions @6-76913EBD
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("NUOVA_REVISIONE".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Button_Update") != null) {
                        if (validate()) {
                            Button_UpdateAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Button_Delete") != null) {
                        Button_DeleteAction();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Button_Insert") != null) {
                        if (validate()) {
                            Button_InsertAction();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                }
            }
            setProperties(model, Action.GET, true );
            read();
            readREDAZIONE(model.getListBox("REDAZIONE"));
            readVERIFICA(model.getListBox("VERIFICA"));
            readAPPROVAZIONE(model.getListBox("APPROVAZIONE"));
//End NUOVA_REVISIONE Record: children actions

//NUOVA_REVISIONE Record: method perform tail @6-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End NUOVA_REVISIONE Record: method perform tail

//Button_Insert Button @9-313A43D8
        void Button_InsertAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Insert");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmRevisioniElenco" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            InsertAction();
        }
//End Button_Insert Button

//Button_Update Button @10-01AB4AC6
        void Button_UpdateAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmRevisioniElenco" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Button_Update Button

//Button_Delete Button @11-FF55C7DA
        void Button_DeleteAction() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Button_Delete");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AdmRevisioniElenco" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            DeleteAction();
        }
//End Button_Delete Button

//ListBoxAction @12-C7B668AC
        protected void readREDAZIONE(com.codecharge.components.ListBox model) {

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

            command.setSql( "SELECT distinct u.UTENTE UTENTE, u.NOMINATIVO NOMINATIVO "
                        + "FROM AMV_DIRITTI d,  "
                        + "AD4_UTENTI_GRUPPO ug, AD4_UTENTI u,  "
                        + "AMV_DOCUMENTI doc  "
                        + "WHERE "
                        + "d.GRUPPO = ug.GRUPPO "
                        + "and u.UTENTE = ug.UTENTE "
                        + "and doc.ID_DOCUMENTO = {ID} "
                        + "and d.ID_AREA = doc.id_area "
                        + "and amv_documento.get_diritto(ug.GRUPPO,d.ID_AREA,doc.ID_TIPOLOGIA) in ('C','V','A','U') "
                        + "" );
            if ( urlID.getObjectValue() == null ) urlID.setValue( -1 );
            command.addParameter( "ID", urlID, null );
            command.setOrder( "NOMINATIVO" );

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

//ListBoxAction @17-725CAA65
        protected void readVERIFICA(com.codecharge.components.ListBox model) {

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

            command.setSql( "SELECT distinct u.UTENTE UTENTE, u.NOMINATIVO NOMINATIVO "
                        + "FROM AMV_DIRITTI d,  "
                        + "AD4_UTENTI_GRUPPO ug, AD4_UTENTI u,  "
                        + "AMV_DOCUMENTI doc  "
                        + "WHERE "
                        + "d.GRUPPO = ug.GRUPPO "
                        + "and u.UTENTE = ug.UTENTE "
                        + "and doc.ID_DOCUMENTO = {ID} "
                        + "and d.ID_AREA = doc.id_area "
                        + "and amv_documento.get_diritto(ug.GRUPPO,d.ID_AREA,doc.ID_TIPOLOGIA) in ('V','A','U') "
                        + "" );
            if ( urlID.getObjectValue() == null ) urlID.setValue( -1 );
            command.addParameter( "ID", urlID, null );
            command.setOrder( "NOMINATIVO" );

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

//ListBoxAction @22-E5F9129F
        protected void readAPPROVAZIONE(com.codecharge.components.ListBox model) {

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

            command.setSql( "SELECT distinct u.UTENTE UTENTE, u.NOMINATIVO NOMINATIVO "
                        + "FROM AMV_DIRITTI d,  "
                        + "AD4_UTENTI_GRUPPO ug, AD4_UTENTI u,  "
                        + "AMV_DOCUMENTI doc  "
                        + "WHERE "
                        + "d.GRUPPO = ug.GRUPPO "
                        + "and u.UTENTE = ug.UTENTE "
                        + "and doc.ID_DOCUMENTO = {ID} "
                        + "and d.ID_AREA = doc.id_area "
                        + "and amv_documento.get_diritto(ug.GRUPPO,d.ID_AREA,doc.ID_TIPOLOGIA) in ('A','U') "
                        + "" );
            if ( urlID.getObjectValue() == null ) urlID.setValue( -1 );
            command.addParameter( "ID", urlID, null );
            command.setOrder( "NOMINATIVO" );

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

void read() { //NUOVA_REVISIONE Record: method read @6-7F8AAE5A

//NUOVA_REVISIONE Record: method read head @6-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End NUOVA_REVISIONE Record: method read head

//NUOVA_REVISIONE Record: init DataSource @6-F4E2E3EF
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            NUOVA_REVISIONEDataObject ds = new NUOVA_REVISIONEDataObject(page);
            ds.setComponent( model );
            try {
                ds.setUrlID( page.getHttpGetParams().getParameter("ID"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'ID'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'ID'" );
            }
            try {
                ds.setUrlREV( page.getHttpGetParams().getParameter("REV"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'REV'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'REV'" );
            }
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End NUOVA_REVISIONE Record: init DataSource

//NUOVA_REVISIONE Record: check errors @6-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End NUOVA_REVISIONE Record: check errors

} //NUOVA_REVISIONE Record: method read tail @6-FCB6E20C

//NUOVA_REVISIONE Record: bind @6-A012EDA6
            public void bind(com.codecharge.components.Component model, NUOVA_REVISIONERow row ) {
                if ( model == null || row == null ) return;
                model.getControl("TITOLO").setValue(row.getTITOLO());
                model.getControl("DES_TIPOLOGIA").setValue(row.getDES_TIPOLOGIA());
                model.getControl("DES_CATEGORIA").setValue(row.getDES_CATEGORIA());
                model.getControl("DES_ARGOMENTO").setValue(row.getDES_ARGOMENTO());
                model.getControl("NOME_AUTORE").setValue(row.getNOME_AUTORE());
                model.getControl("DATA_INSERIMENTO").setValue(row.getDATA_INSERIMENTO());
                model.getControl("INIZIO_PUBBLICAZIONE_LABEL").setValue(row.getINIZIO_PUBBLICAZIONE_LABEL());
                model.getControl("FINE_PUBBLICAZIONE_LABEL").setValue(row.getFINE_PUBBLICAZIONE_LABEL());
                if ( this.valid ) {
                    model.getControl("REVISIONE").setValue(row.getREVISIONE());
                    model.getControl("ID_DOCUMENTO").setValue(row.getID_DOCUMENTO());
                }
            }
//End NUOVA_REVISIONE Record: bind

//NUOVA_REVISIONE Record: getRowFieldByName @6-1D43E55E
            public Object getRowFieldByName( String name, NUOVA_REVISIONERow row ) {
                Object value = null;
                if ( "TITOLO".equals(name) ) {
                    value = row.getTITOLO();
                } else if ( "DES_TIPOLOGIA".equals(name) ) {
                    value = row.getDES_TIPOLOGIA();
                } else if ( "DES_CATEGORIA".equals(name) ) {
                    value = row.getDES_CATEGORIA();
                } else if ( "DES_ARGOMENTO".equals(name) ) {
                    value = row.getDES_ARGOMENTO();
                } else if ( "NOME_AUTORE".equals(name) ) {
                    value = row.getNOME_AUTORE();
                } else if ( "DATA_INSERIMENTO".equals(name) ) {
                    value = row.getDATA_INSERIMENTO();
                } else if ( "INIZIO_PUBBLICAZIONE_LABEL".equals(name) ) {
                    value = row.getINIZIO_PUBBLICAZIONE_LABEL();
                } else if ( "FINE_PUBBLICAZIONE_LABEL".equals(name) ) {
                    value = row.getFINE_PUBBLICAZIONE_LABEL();
                } else if ( "REDAZIONE".equals(name) ) {
                    value = row.getREDAZIONE();
                } else if ( "VERIFICA".equals(name) ) {
                    value = row.getVERIFICA();
                } else if ( "APPROVAZIONE".equals(name) ) {
                    value = row.getAPPROVAZIONE();
                } else if ( "INIZIO_PUBBLICAZIONE".equals(name) ) {
                    value = row.getINIZIO_PUBBLICAZIONE();
                } else if ( "FINE_PUBBLICAZIONE".equals(name) ) {
                    value = row.getFINE_PUBBLICAZIONE();
                } else if ( "REVISIONE".equals(name) ) {
                    value = row.getREVISIONE();
                } else if ( "ID_DOCUMENTO".equals(name) ) {
                    value = row.getID_DOCUMENTO();
                }
                return value;
            }
//End NUOVA_REVISIONE Record: getRowFieldByName

void InsertAction() { //NUOVA_REVISIONE Record: method insert @6-11643485

//NUOVA_REVISIONE Record: method insert head @6-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End NUOVA_REVISIONE Record: method insert head

//NUOVA_REVISIONE Record: components insert actions @6-68525650
            if (! model.hasErrors()) {
            }
//End NUOVA_REVISIONE Record: components insert actions

} //NUOVA_REVISIONE Record: method insert tail @6-FCB6E20C

void UpdateAction() { //NUOVA_REVISIONE Record: method update @6-5771D0AA

//NUOVA_REVISIONE Record: method update head @6-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End NUOVA_REVISIONE Record: method update head

//NUOVA_REVISIONE Record: method update body @6-E88BE086
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            NUOVA_REVISIONEDataObject ds = new NUOVA_REVISIONEDataObject(page);
            ds.setComponent( model );
            NUOVA_REVISIONERow row = new NUOVA_REVISIONERow();
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
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setPostREDAZIONE( page.getHttpPostParams().getParameter("REDAZIONE") );
            ds.setPostVERIFICA( page.getHttpPostParams().getParameter("VERIFICA") );
            ds.setPostAPPROVAZIONE( page.getHttpPostParams().getParameter("APPROVAZIONE") );
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
//End NUOVA_REVISIONE Record: method update body

//NUOVA_REVISIONE Record: ds.update @6-6E956EDC
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
//End NUOVA_REVISIONE Record: ds.update

} //NUOVA_REVISIONE Record: method update tail @6-FCB6E20C

void DeleteAction() { //NUOVA_REVISIONE Record: method delete @6-11FC2E1E

//NUOVA_REVISIONE Record: method delete head @6-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End NUOVA_REVISIONE Record: method delete head

//NUOVA_REVISIONE Record: components delete actions @6-68525650
            if (! model.hasErrors()) {
            }
//End NUOVA_REVISIONE Record: components delete actions

} //NUOVA_REVISIONE Record: method delete tail @6-FCB6E20C

//NUOVA_REVISIONE Record: method validate @6-7A113063
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.ListBox REDAZIONE = (com.codecharge.components.ListBox) model.getChild( "REDAZIONE" );
            if (! REDAZIONE.validate()) { isControlError = true; }

            com.codecharge.components.ListBox VERIFICA = (com.codecharge.components.ListBox) model.getChild( "VERIFICA" );
            if (! VERIFICA.validate()) { isControlError = true; }

            com.codecharge.components.ListBox APPROVAZIONE = (com.codecharge.components.ListBox) model.getChild( "APPROVAZIONE" );
            if (! APPROVAZIONE.validate()) { isControlError = true; }

            com.codecharge.components.TextBox INIZIO_PUBBLICAZIONE = (com.codecharge.components.TextBox) model.getChild( "INIZIO_PUBBLICAZIONE" );
            if (! INIZIO_PUBBLICAZIONE.validate()) { isControlError = true; }

            com.codecharge.components.TextBox FINE_PUBBLICAZIONE = (com.codecharge.components.TextBox) model.getChild( "FINE_PUBBLICAZIONE" );
            if (! FINE_PUBBLICAZIONE.validate()) { isControlError = true; }

            com.codecharge.components.Hidden REVISIONE = (com.codecharge.components.Hidden) model.getChild( "REVISIONE" );
            if (! REVISIONE.validate()) { isControlError = true; }

            com.codecharge.components.Hidden ID_DOCUMENTO = (com.codecharge.components.Hidden) model.getChild( "ID_DOCUMENTO" );
            if (! ID_DOCUMENTO.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End NUOVA_REVISIONE Record: method validate

//NUOVA_REVISIONE Record Tail @6-FCB6E20C
    }
//End NUOVA_REVISIONE Record Tail

//AdmRevisioneNuova Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmRevisioneNuova Page: method validate

//AdmRevisioneNuovaAction Tail @1-FCB6E20C
}
//End AdmRevisioneNuovaAction Tail
