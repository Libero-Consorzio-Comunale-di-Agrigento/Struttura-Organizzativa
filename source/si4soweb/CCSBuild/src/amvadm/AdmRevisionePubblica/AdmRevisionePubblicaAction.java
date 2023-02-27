//AdmRevisionePubblicaAction imports @1-911F11F4
package amvadm.AdmRevisionePubblica;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AdmRevisionePubblicaAction imports

//AdmRevisionePubblicaAction class @1-88B66E53
public class AdmRevisionePubblicaAction extends Action {

//End AdmRevisionePubblicaAction class

//AdmRevisionePubblicaAction: method perform @1-0AD388CF
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AdmRevisionePubblicaModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AdmRevisionePubblicaModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AdmRevisionePubblicaAction: method perform

//AdmRevisionePubblicaAction: call children actions @1-E77088ED
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
            AMV_DOCUMENTO_PUBBLICAClass AMV_DOCUMENTO_PUBBLICA = new AMV_DOCUMENTO_PUBBLICAClass();
            if ( ( redirect = AMV_DOCUMENTO_PUBBLICA.perform( page.getRecord("AMV_DOCUMENTO_PUBBLICA")) ) != null ) result = redirect;
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
//End AdmRevisionePubblicaAction: call children actions

//AMV_DOCUMENTO_PUBBLICA Record @6-7F0ACA97
    final class AMV_DOCUMENTO_PUBBLICAClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AMV_DOCUMENTO_PUBBLICA Record

//AMV_DOCUMENTO_PUBBLICA Record: method perform @6-DAD7B3FA
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( page.getActionPageName() + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowUpdate() ) model.getChild( "Update" ).setVisible( false );
//End AMV_DOCUMENTO_PUBBLICA Record: method perform

//AMV_DOCUMENTO_PUBBLICA Record: children actions @6-5E6DE311
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AMV_DOCUMENTO_PUBBLICA".equals(formName)) {
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
//End AMV_DOCUMENTO_PUBBLICA Record: children actions

//AMV_DOCUMENTO_PUBBLICA Record: method perform tail @6-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AMV_DOCUMENTO_PUBBLICA Record: method perform tail

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

void read() { //AMV_DOCUMENTO_PUBBLICA Record: method read @6-7F8AAE5A

//AMV_DOCUMENTO_PUBBLICA Record: method read head @6-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AMV_DOCUMENTO_PUBBLICA Record: method read head

//AMV_DOCUMENTO_PUBBLICA Record: init DataSource @6-A638F6BD
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AMV_DOCUMENTO_PUBBLICADataObject ds = new AMV_DOCUMENTO_PUBBLICADataObject(page);
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
            ds.setSesMVPP( SessionStorage.getInstance(req).getAttribute("MVPP") );
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End AMV_DOCUMENTO_PUBBLICA Record: init DataSource

//AMV_DOCUMENTO_PUBBLICA Record: check errors @6-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AMV_DOCUMENTO_PUBBLICA Record: check errors

} //AMV_DOCUMENTO_PUBBLICA Record: method read tail @6-FCB6E20C

//AMV_DOCUMENTO_PUBBLICA Record: bind @6-C8CD2372
            public void bind(com.codecharge.components.Component model, AMV_DOCUMENTO_PUBBLICARow row ) {
                if ( model == null || row == null ) return;
                model.getControl("TITOLO").setValue(row.getTITOLO());
                model.getControl("DATA_INSERIMENTO").setValue(row.getDATA_INSERIMENTO());
                model.getControl("NOMINATIVO_AUTORE").setValue(row.getNOMINATIVO_AUTORE());
                model.getControl("DATA_AGGIORNAMENTO").setValue(row.getDATA_AGGIORNAMENTO());
                model.getControl("NOMINATIVO_AGGIORNAMENTO").setValue(row.getNOMINATIVO_AGGIORNAMENTO());
                model.getControl("CRONOLOGIA").setValue(row.getCRONOLOGIA());
                model.getControl("NOTE").setValue(row.getNOTE());
                if ( this.valid ) {
                    model.getControl("MVPAGES").setValue(row.getMVPAGES());
                    model.getControl("INIZIO_PUBBLICAZIONE").setValue(row.getINIZIO_PUBBLICAZIONE());
                    model.getControl("FINE_PUBBLICAZIONE").setValue(row.getFINE_PUBBLICAZIONE());
                    model.getControl("REVISIONE").setValue(row.getREVISIONE());
                    model.getControl("ID_DOCUMENTO").setValue(row.getID_DOCUMENTO());
                }
            }
//End AMV_DOCUMENTO_PUBBLICA Record: bind

//AMV_DOCUMENTO_PUBBLICA Record: getRowFieldByName @6-EF6CF067
            public Object getRowFieldByName( String name, AMV_DOCUMENTO_PUBBLICARow row ) {
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
                } else if ( "INIZIO_PUBBLICAZIONE".equals(name) ) {
                    value = row.getINIZIO_PUBBLICAZIONE();
                } else if ( "FINE_PUBBLICAZIONE".equals(name) ) {
                    value = row.getFINE_PUBBLICAZIONE();
                } else if ( "CRONOLOGIA".equals(name) ) {
                    value = row.getCRONOLOGIA();
                } else if ( "NOTE".equals(name) ) {
                    value = row.getNOTE();
                } else if ( "REVISIONE".equals(name) ) {
                    value = row.getREVISIONE();
                } else if ( "ID_DOCUMENTO".equals(name) ) {
                    value = row.getID_DOCUMENTO();
                }
                return value;
            }
//End AMV_DOCUMENTO_PUBBLICA Record: getRowFieldByName

void InsertAction() { //AMV_DOCUMENTO_PUBBLICA Record: method insert @6-11643485

//AMV_DOCUMENTO_PUBBLICA Record: method insert head @6-6D5B77FE
            if (!model.isAllowInsert()) return;
            model.fireBeforeInsertEvent();
//End AMV_DOCUMENTO_PUBBLICA Record: method insert head

//AMV_DOCUMENTO_PUBBLICA Record: components insert actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AMV_DOCUMENTO_PUBBLICA Record: components insert actions

} //AMV_DOCUMENTO_PUBBLICA Record: method insert tail @6-FCB6E20C

void UpdateAction() { //AMV_DOCUMENTO_PUBBLICA Record: method update @6-5771D0AA

//AMV_DOCUMENTO_PUBBLICA Record: method update head @6-AA7E708E
            if (!model.isAllowUpdate()) return;
            model.fireBeforeUpdateEvent();
//End AMV_DOCUMENTO_PUBBLICA Record: method update head

//AMV_DOCUMENTO_PUBBLICA Record: method update body @6-CDF8B52C
            if (!model.isAllowUpdate()) return;
            boolean isErrors = false;
            AMV_DOCUMENTO_PUBBLICADataObject ds = new AMV_DOCUMENTO_PUBBLICADataObject(page);
            ds.setComponent( model );
            AMV_DOCUMENTO_PUBBLICARow row = new AMV_DOCUMENTO_PUBBLICARow();
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
//End AMV_DOCUMENTO_PUBBLICA Record: method update body

//AMV_DOCUMENTO_PUBBLICA Record: ds.update @6-6E956EDC
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
//End AMV_DOCUMENTO_PUBBLICA Record: ds.update

} //AMV_DOCUMENTO_PUBBLICA Record: method update tail @6-FCB6E20C

void DeleteAction() { //AMV_DOCUMENTO_PUBBLICA Record: method delete @6-11FC2E1E

//AMV_DOCUMENTO_PUBBLICA Record: method delete head @6-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End AMV_DOCUMENTO_PUBBLICA Record: method delete head

//AMV_DOCUMENTO_PUBBLICA Record: components delete actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AMV_DOCUMENTO_PUBBLICA Record: components delete actions

} //AMV_DOCUMENTO_PUBBLICA Record: method delete tail @6-FCB6E20C

//AMV_DOCUMENTO_PUBBLICA Record: method validate @6-85D32705
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.Hidden MVPAGES = (com.codecharge.components.Hidden) model.getChild( "MVPAGES" );
            if (! MVPAGES.validate()) { isControlError = true; }

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
//End AMV_DOCUMENTO_PUBBLICA Record: method validate

//AMV_DOCUMENTO_PUBBLICA Record Tail @6-FCB6E20C
    }
//End AMV_DOCUMENTO_PUBBLICA Record Tail

//AdmRevisionePubblica Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AdmRevisionePubblica Page: method validate

//AdmRevisionePubblicaAction Tail @1-FCB6E20C
}
//End AdmRevisionePubblicaAction Tail
