//AdmRevisioneVerificaAction imports @1-C8DB0CBE
package amvadm.AdmRevisioneVerifica;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmRevisioneVerificaAction imports

//AdmRevisioneVerificaAction class @1-6BFC4565
public class AdmRevisioneVerificaAction extends Action {

//End AdmRevisioneVerificaAction class

//AdmRevisioneVerificaAction: method perform @1-AC9B668D
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmRevisioneVerificaModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmRevisioneVerificaModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmRevisioneVerificaAction: method perform

//AdmRevisioneVerificaAction: call children actions @1-8794E261
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
            AMV_DOCUMENTO_VERIFICAClass AMV_DOCUMENTO_VERIFICA = new AMV_DOCUMENTO_VERIFICAClass();
            if ( ( redirect = AMV_DOCUMENTO_VERIFICA.perform( page.getRecord("AMV_DOCUMENTO_VERIFICA")) ) != null ) result = redirect;
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
//End AdmRevisioneVerificaAction: call children actions

//AMV_DOCUMENTO_VERIFICA Record @6-576DCF25
    final class AMV_DOCUMENTO_VERIFICAClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AMV_DOCUMENTO_VERIFICA Record

//AMV_DOCUMENTO_VERIFICA Record: method perform @6-DAD7B3FA
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( page.getActionPageName() + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowUpdate() ) model.getChild( "Update" ).setVisible( false );
//End AMV_DOCUMENTO_VERIFICA Record: method perform

//AMV_DOCUMENTO_VERIFICA Record: children actions @6-0B7DD775
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AMV_DOCUMENTO_VERIFICA".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Update") != null) {
                        if (validate()) {
                            Update11Action();
                            if ( !model.hasErrors()) return page.getRedirectString();
                        }
                    }
                    if (page.getParameter("Cancel") != null) {
                        Cancel13Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                } else { // Insert mode
                    model.setMode(com.codecharge.components.Record.INSERT_MODE);
                    if (page.getParameter("Cancel") != null) {
                        Cancel13Action();
                        if ( !model.hasErrors()) return page.getRedirectString();
                    }
                }
            }
            setProperties(model, Action.GET, true );
            read();
            readUTENTE_APPROVAZIONE(model.getListBox("UTENTE_APPROVAZIONE"));
//End AMV_DOCUMENTO_VERIFICA Record: children actions

//AMV_DOCUMENTO_VERIFICA Record: method perform tail @6-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AMV_DOCUMENTO_VERIFICA Record: method perform tail

//Update Button @11-C98790AD
        void Update11Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( page.getActionPageName() + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Update Button

//Cancel Button @13-202A9739
        void Cancel13Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Cancel");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( page.getActionPageName() + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
        }
//End Cancel Button

//ListBoxAction @16-F82A1E99
        protected void readUTENTE_APPROVAZIONE(com.codecharge.components.ListBox model) {

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
            LongField postID_TIPOLOGIA = new LongField(null, null);
            
            try {
                postID_TIPOLOGIA.setValue( page.getHttpPostParams().getParameter("ID_TIPOLOGIA"), page.getCCSLocale().getFormat("Integer") );
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
            if ( postID_AREA.getObjectValue() == null ) postID_AREA.setValue( null );
            command.addParameter( "ID_AREA", postID_AREA, null );
            if ( urlID.getObjectValue() == null ) urlID.setValue( -1 );
            command.addParameter( "ID", urlID, null );
            if ( postID_TIPOLOGIA.getObjectValue() == null ) postID_TIPOLOGIA.setValue( 0 );
            command.addParameter( "ID_TIPOLOGIA", postID_TIPOLOGIA, null );
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

void read() { //AMV_DOCUMENTO_VERIFICA Record: method read @6-7F8AAE5A

//AMV_DOCUMENTO_VERIFICA Record: method read head @6-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AMV_DOCUMENTO_VERIFICA Record: method read head

//AMV_DOCUMENTO_VERIFICA Record: init DataSource @6-D44F9399
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AMV_DOCUMENTO_VERIFICADataObject ds = new AMV_DOCUMENTO_VERIFICADataObject(page);
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
            ds.setSesMVPP( SessionStorage.getInstance(req).getAttribute("MVPP") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End AMV_DOCUMENTO_VERIFICA Record: init DataSource

//AMV_DOCUMENTO_VERIFICA Record: check errors @6-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AMV_DOCUMENTO_VERIFICA Record: check errors

} //AMV_DOCUMENTO_VERIFICA Record: method read tail @6-FCB6E20C

//AMV_DOCUMENTO_VERIFICA Record: bind @6-CFF35B02
            public void bind(com.codecharge.components.Component model, AMV_DOCUMENTO_VERIFICARow row ) {
                if ( model == null || row == null ) return;
                model.getControl("TITOLO").setValue(row.getTITOLO());
                model.getControl("DATA_INSERIMENTO").setValue(row.getDATA_INSERIMENTO());
                model.getControl("NOMINATIVO_AUTORE").setValue(row.getNOMINATIVO_AUTORE());
                model.getControl("DATA_AGGIORNAMENTO").setValue(row.getDATA_AGGIORNAMENTO());
                model.getControl("NOMINATIVO_AGGIORNAMENTO").setValue(row.getNOMINATIVO_AGGIORNAMENTO());
                model.getControl("CRONOLOGIA").setValue(row.getCRONOLOGIA());
                model.getControl("NOTE_LABEL").setValue(row.getNOTE_LABEL());
                if ( this.valid ) {
                    model.getControl("MVPAGES").setValue(row.getMVPAGES());
                    model.getControl("UTENTE_APPROVAZIONE").setValue(row.getUTENTE_APPROVAZIONE());
                    model.getControl("REVISIONE").setValue(row.getREVISIONE());
                    model.getControl("ID_DOCUMENTO").setValue(row.getID_DOCUMENTO());
                }
            }
//End AMV_DOCUMENTO_VERIFICA Record: bind

//AMV_DOCUMENTO_VERIFICA Record: getRowFieldByName @6-BB07B715
            public Object getRowFieldByName( String name, AMV_DOCUMENTO_VERIFICARow row ) {
                Object value = null;
                if ( "TITOLO".equals(name) ) {
                    value = row.getTITOLO();
                } else if ( "MVPAGES".equals(name) ) {
                    value = row.getMVPAGES();
                } else if ( "DATA_INSERIMENTO".equals(name) ) {
                    value = row.getDATA_INSERIMENTO();
                } else if ( "NOMINATIVO_AUTORE".equals(name) ) {
                    value = row.getNOMINATIVO_AUTORE();
                } else if ( "DATA_AGGIORNAMENTO".equals(name) ) {
                    value = row.getDATA_AGGIORNAMENTO();
                } else if ( "NOMINATIVO_AGGIORNAMENTO".equals(name) ) {
                    value = row.getNOMINATIVO_AGGIORNAMENTO();
                } else if ( "UTENTE_APPROVAZIONE".equals(name) ) {
                    value = row.getUTENTE_APPROVAZIONE();
                } else if ( "NOTE".equals(name) ) {
                    value = row.getNOTE();
                } else if ( "CRONOLOGIA".equals(name) ) {
                    value = row.getCRONOLOGIA();
                } else if ( "NOTE_LABEL".equals(name) ) {
                    value = row.getNOTE_LABEL();
                } else if ( "REVISIONE".equals(name) ) {
                    value = row.getREVISIONE();
                } else if ( "ID_DOCUMENTO".equals(name) ) {
                    value = row.getID_DOCUMENTO();
                }
                return value;
            }
//End AMV_DOCUMENTO_VERIFICA Record: getRowFieldByName

void InsertAction() { //AMV_DOCUMENTO_VERIFICA Record: method insert @6-11643485

//AMV_DOCUMENTO_VERIFICA Record: method insert head @6-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End AMV_DOCUMENTO_VERIFICA Record: method insert head

//AMV_DOCUMENTO_VERIFICA Record: components insert actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AMV_DOCUMENTO_VERIFICA Record: components insert actions

} //AMV_DOCUMENTO_VERIFICA Record: method insert tail @6-FCB6E20C

void UpdateAction() { //AMV_DOCUMENTO_VERIFICA Record: method update @6-5771D0AA

//AMV_DOCUMENTO_VERIFICA Record: method update head @6-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AMV_DOCUMENTO_VERIFICA Record: method update head

//AMV_DOCUMENTO_VERIFICA Record: method update body @6-846B9B51
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AMV_DOCUMENTO_VERIFICADataObject ds = new AMV_DOCUMENTO_VERIFICADataObject(page);
            ds.setComponent( model );
            AMV_DOCUMENTO_VERIFICARow row = new AMV_DOCUMENTO_VERIFICARow();
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
            ds.setExprKey35( ( "V" ) );
            ds.setPostNOTE( page.getHttpPostParams().getParameter("NOTE") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setPostUTENTE_APPROVAZIONE( page.getHttpPostParams().getParameter("UTENTE_APPROVAZIONE") );
//End AMV_DOCUMENTO_VERIFICA Record: method update body

//AMV_DOCUMENTO_VERIFICA Record: ds.update @6-6E956EDC
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
//End AMV_DOCUMENTO_VERIFICA Record: ds.update

} //AMV_DOCUMENTO_VERIFICA Record: method update tail @6-FCB6E20C

void DeleteAction() { //AMV_DOCUMENTO_VERIFICA Record: method delete @6-11FC2E1E

//AMV_DOCUMENTO_VERIFICA Record: method delete head @6-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End AMV_DOCUMENTO_VERIFICA Record: method delete head

//AMV_DOCUMENTO_VERIFICA Record: components delete actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AMV_DOCUMENTO_VERIFICA Record: components delete actions

} //AMV_DOCUMENTO_VERIFICA Record: method delete tail @6-FCB6E20C

//AMV_DOCUMENTO_VERIFICA Record: method validate @6-5B5F0C60
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.Hidden MVPAGES = (com.codecharge.components.Hidden) model.getChild( "MVPAGES" );
            if (! MVPAGES.validate()) { isControlError = true; }

            com.codecharge.components.ListBox UTENTE_APPROVAZIONE = (com.codecharge.components.ListBox) model.getChild( "UTENTE_APPROVAZIONE" );
            if (! UTENTE_APPROVAZIONE.validate()) { isControlError = true; }

            com.codecharge.components.TextArea NOTE = (com.codecharge.components.TextArea) model.getChild( "NOTE" );
            if (! NOTE.validate()) { isControlError = true; }

            com.codecharge.components.Hidden REVISIONE = (com.codecharge.components.Hidden) model.getChild( "REVISIONE" );
            if (! REVISIONE.validate()) { isControlError = true; }

            com.codecharge.components.Hidden ID_DOCUMENTO = (com.codecharge.components.Hidden) model.getChild( "ID_DOCUMENTO" );
            if (! ID_DOCUMENTO.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AMV_DOCUMENTO_VERIFICA Record: method validate

//AMV_DOCUMENTO_VERIFICA Record Tail @6-FCB6E20C
    }
//End AMV_DOCUMENTO_VERIFICA Record Tail

//AdmRevisioneVerifica Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmRevisioneVerifica Page: method validate

//AdmRevisioneVerificaAction Tail @1-FCB6E20C
}
//End AdmRevisioneVerificaAction Tail
