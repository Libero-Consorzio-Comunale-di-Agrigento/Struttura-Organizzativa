//AdmRevisioneApprovaAction imports @1-8D46D7CA
package amvadm.AdmRevisioneApprova;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmRevisioneApprovaAction imports

//AdmRevisioneApprovaAction class @1-CC0C3070
public class AdmRevisioneApprovaAction extends Action {

//End AdmRevisioneApprovaAction class

//AdmRevisioneApprovaAction: method perform @1-FE6F43AB
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmRevisioneApprovaModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmRevisioneApprovaModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmRevisioneApprovaAction: method perform

//AdmRevisioneApprovaAction: call children actions @1-0145502C
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
            AMV_DOCUMENTO_APPROVAClass AMV_DOCUMENTO_APPROVA = new AMV_DOCUMENTO_APPROVAClass();
            if ( ( redirect = AMV_DOCUMENTO_APPROVA.perform( page.getRecord("AMV_DOCUMENTO_APPROVA")) ) != null ) result = redirect;
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
//End AdmRevisioneApprovaAction: call children actions

//AMV_DOCUMENTO_APPROVA Record @6-76BD3807
    final class AMV_DOCUMENTO_APPROVAClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AMV_DOCUMENTO_APPROVA Record

//AMV_DOCUMENTO_APPROVA Record: method perform @6-65349B7B
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( page.getActionPageName() + Names.ACTION_SUFFIX );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowUpdate() ) model.getChild( "Update" ).setVisible( false );
//End AMV_DOCUMENTO_APPROVA Record: method perform

//AMV_DOCUMENTO_APPROVA Record: children actions @6-AE799D41
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AMV_DOCUMENTO_APPROVA".equals(formName)) {
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
//End AMV_DOCUMENTO_APPROVA Record: children actions

//AMV_DOCUMENTO_APPROVA Record: method perform tail @6-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AMV_DOCUMENTO_APPROVA Record: method perform tail

//Update Button @11-7E652B80
        void Update11Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Update");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( page.getActionPageName() + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
            UpdateAction();
        }
//End Update Button

//Cancel Button @13-4923644A
        void Cancel13Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Cancel");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( page.getActionPageName() + Names.ACTION_SUFFIX );
            buttonModel.fireOnClickEvent();
        }
//End Cancel Button

void read() { //AMV_DOCUMENTO_APPROVA Record: method read @6-7F8AAE5A

//AMV_DOCUMENTO_APPROVA Record: method read head @6-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AMV_DOCUMENTO_APPROVA Record: method read head

//AMV_DOCUMENTO_APPROVA Record: init DataSource @6-F63A96C4
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AMV_DOCUMENTO_APPROVADataObject ds = new AMV_DOCUMENTO_APPROVADataObject(page);
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
//End AMV_DOCUMENTO_APPROVA Record: init DataSource

//AMV_DOCUMENTO_APPROVA Record: check errors @6-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AMV_DOCUMENTO_APPROVA Record: check errors

} //AMV_DOCUMENTO_APPROVA Record: method read tail @6-FCB6E20C

//AMV_DOCUMENTO_APPROVA Record: bind @6-74C55613
            public void bind(com.codecharge.components.Component model, AMV_DOCUMENTO_APPROVARow row ) {
                if ( model == null || row == null ) return;
                model.getControl("TITOLO").setValue(row.getTITOLO());
                model.getControl("DATA_INSERIMENTO").setValue(row.getDATA_INSERIMENTO());
                model.getControl("AUTORE").setValue(row.getAUTORE());
                model.getControl("DATA_AGGIORNAMENTO").setValue(row.getDATA_AGGIORNAMENTO());
                model.getControl("UTENTE_AGGIORNAMENTO").setValue(row.getUTENTE_AGGIORNAMENTO());
                model.getControl("CRONOLOGIA").setValue(row.getCRONOLOGIA());
                model.getControl("NOTE_LABEL").setValue(row.getNOTE_LABEL());
                if ( this.valid ) {
                    model.getControl("MVPAGES").setValue(row.getMVPAGES());
                    model.getControl("REVISIONE").setValue(row.getREVISIONE());
                    model.getControl("ID_DOCUMENTO").setValue(row.getID_DOCUMENTO());
                }
            }
//End AMV_DOCUMENTO_APPROVA Record: bind

//AMV_DOCUMENTO_APPROVA Record: getRowFieldByName @6-6A53ADB4
            public Object getRowFieldByName( String name, AMV_DOCUMENTO_APPROVARow row ) {
                Object value = null;
                if ( "TITOLO".equals(name) ) {
                    value = row.getTITOLO();
                } else if ( "MVPAGES".equals(name) ) {
                    value = row.getMVPAGES();
                } else if ( "DATA_INSERIMENTO".equals(name) ) {
                    value = row.getDATA_INSERIMENTO();
                } else if ( "AUTORE".equals(name) ) {
                    value = row.getAUTORE();
                } else if ( "DATA_AGGIORNAMENTO".equals(name) ) {
                    value = row.getDATA_AGGIORNAMENTO();
                } else if ( "UTENTE_AGGIORNAMENTO".equals(name) ) {
                    value = row.getUTENTE_AGGIORNAMENTO();
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
//End AMV_DOCUMENTO_APPROVA Record: getRowFieldByName

void InsertAction() { //AMV_DOCUMENTO_APPROVA Record: method insert @6-11643485

//AMV_DOCUMENTO_APPROVA Record: method insert head @6-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End AMV_DOCUMENTO_APPROVA Record: method insert head

//AMV_DOCUMENTO_APPROVA Record: components insert actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AMV_DOCUMENTO_APPROVA Record: components insert actions

} //AMV_DOCUMENTO_APPROVA Record: method insert tail @6-FCB6E20C

void UpdateAction() { //AMV_DOCUMENTO_APPROVA Record: method update @6-5771D0AA

//AMV_DOCUMENTO_APPROVA Record: method update head @6-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AMV_DOCUMENTO_APPROVA Record: method update head

//AMV_DOCUMENTO_APPROVA Record: method update body @6-C608C1F8
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AMV_DOCUMENTO_APPROVADataObject ds = new AMV_DOCUMENTO_APPROVADataObject(page);
            ds.setComponent( model );
            AMV_DOCUMENTO_APPROVARow row = new AMV_DOCUMENTO_APPROVARow();
            ds.setRow(row);
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
            ds.setExprKey34( ( "A" ) );
            ds.setPostNOTE( page.getHttpPostParams().getParameter("NOTE") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setUrlP_DESTINATARIO( page.getHttpGetParams().getParameter("P_DESTINATARIO") );
//End AMV_DOCUMENTO_APPROVA Record: method update body

//AMV_DOCUMENTO_APPROVA Record: ds.update @6-6E956EDC
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
//End AMV_DOCUMENTO_APPROVA Record: ds.update

} //AMV_DOCUMENTO_APPROVA Record: method update tail @6-FCB6E20C

void DeleteAction() { //AMV_DOCUMENTO_APPROVA Record: method delete @6-11FC2E1E

//AMV_DOCUMENTO_APPROVA Record: method delete head @6-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End AMV_DOCUMENTO_APPROVA Record: method delete head

//AMV_DOCUMENTO_APPROVA Record: components delete actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AMV_DOCUMENTO_APPROVA Record: components delete actions

} //AMV_DOCUMENTO_APPROVA Record: method delete tail @6-FCB6E20C

//AMV_DOCUMENTO_APPROVA Record: method validate @6-04678125
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.Hidden MVPAGES = (com.codecharge.components.Hidden) model.getChild( "MVPAGES" );
            if (! MVPAGES.validate()) { isControlError = true; }

            com.codecharge.components.TextArea NOTE = (com.codecharge.components.TextArea) model.getChild( "NOTE" );
            if (! NOTE.validate()) { isControlError = true; }

            com.codecharge.components.Hidden REVISIONE = (com.codecharge.components.Hidden) model.getChild( "REVISIONE" );
            if (! REVISIONE.validate()) { isControlError = true; }

            com.codecharge.components.Hidden ID_DOCUMENTO = (com.codecharge.components.Hidden) model.getChild( "ID_DOCUMENTO" );
            if (! ID_DOCUMENTO.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AMV_DOCUMENTO_APPROVA Record: method validate

//AMV_DOCUMENTO_APPROVA Record Tail @6-FCB6E20C
    }
//End AMV_DOCUMENTO_APPROVA Record Tail

//AdmRevisioneApprova Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmRevisioneApprova Page: method validate

//AdmRevisioneApprovaAction Tail @1-FCB6E20C
}
//End AdmRevisioneApprovaAction Tail
