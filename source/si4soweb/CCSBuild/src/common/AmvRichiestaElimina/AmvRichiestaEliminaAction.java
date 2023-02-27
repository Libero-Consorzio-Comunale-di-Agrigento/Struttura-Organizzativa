//AmvRichiestaEliminaAction imports @1-40AF88F2
package common.AmvRichiestaElimina;

import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import com.codecharge.*;
import com.codecharge.events.*;
import com.codecharge.db.*;
import com.codecharge.validation.*;
import com.codecharge.util.*;
import com.codecharge.util.multipart.*;
//End AmvRichiestaEliminaAction imports

//AmvRichiestaEliminaAction class @1-2ACA4025
public class AmvRichiestaEliminaAction extends Action {

//End AmvRichiestaEliminaAction class

//AmvRichiestaEliminaAction: method perform @1-CF316A61
    public String perform( HttpServletRequest req, HttpServletResponse resp, ServletContext context ) {
        String result = null;
        String redirect;
        this.req = req;
        this.resp = resp;
        this.context = context;
        page = new AmvRichiestaEliminaModel( (CCSLocale) SessionStorage.getInstance( req ).getAttribute(Names.CCS_LOCALE_KEY));
        if (req.getAttribute(page.getName()+"Parent")==null) page.setCharacterEncoding("windows-1252");
        page.setResponse(resp);
        page.setRequest(req);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
        req.setAttribute( "AmvRichiestaEliminaModel", page );
        //e = new ActionEvent( page, page );
        if ( ! StringUtils.isEmpty( pageName ) ) page.setName( pageName );
        setProperties( page, Action.GET );
        setProperties( page, Action.POST );
        page.fireAfterInitializeEvent();
        if (! StringUtils.isEmpty(page.getRedirectString())) return page.getRedirectString();
//End AmvRichiestaEliminaAction: method perform

//AmvRichiestaEliminaAction: call children actions @1-324435BE
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
            AMV_DOCUMENTO_RESPINGIClass AMV_DOCUMENTO_RESPINGI = new AMV_DOCUMENTO_RESPINGIClass();
            if ( ( redirect = AMV_DOCUMENTO_RESPINGI.perform( page.getRecord("AMV_DOCUMENTO_RESPINGI")) ) != null ) result = redirect;
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
//End AmvRichiestaEliminaAction: call children actions

//AMV_DOCUMENTO_RESPINGI Record @6-341C0DFA
    final class AMV_DOCUMENTO_RESPINGIClass {
        com.codecharge.components.Record model;
        boolean valid = true;
        boolean action = false;
        Vector errors = new Vector();
        //ActionEvent e;

//End AMV_DOCUMENTO_RESPINGI Record

//AMV_DOCUMENTO_RESPINGI Record: method perform @6-4D6F9031
        String perform(com.codecharge.components.Record model) {
            //e = new ActionEvent( model, page );
            this.model = model;
            if ( ! model.isVisible() ) { return null;}
            StringBuffer performReturnPage = new StringBuffer( "AmvRichieste" + Names.ACTION_SUFFIX );
            performReturnPage.append( "?" + page.getHttpGetParams().toString( model.getExcludeParams() ) );
            page.setRedirectString( performReturnPage.toString() );
            if ( ! model.isAllowDelete() ) model.getChild( "Delete" ).setVisible( false );
//End AMV_DOCUMENTO_RESPINGI Record: method perform

//AMV_DOCUMENTO_RESPINGI Record: children actions @6-FD654DC9
            String formName = page.getHttpGetParams().getParameterAsString("ccsForm");
            int mode = formName.indexOf(":Edit");
            if (mode != -1) {
                formName = formName.substring(0, mode);
            }
            model.setMode(com.codecharge.components.Record.INSERT_MODE);
            if ("AMV_DOCUMENTO_RESPINGI".equals(formName)) {
                setProperties(model, Action.POST);
                if (mode != -1) { // Update mode
                    model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                    if (page.getParameter("Delete") != null) {
                        if (validate()) {
                            Delete41Action();
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
//End AMV_DOCUMENTO_RESPINGI Record: children actions

//AMV_DOCUMENTO_RESPINGI Record: method perform tail @6-71EF9E38
            page.setRedirectString(null);
            return page.getRedirectString();
        }
//End AMV_DOCUMENTO_RESPINGI Record: method perform tail

//Delete Button @41-703F9B87
        void Delete41Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Delete");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvRichieste" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
            DeleteAction();
        }
//End Delete Button

//Cancel Button @13-004D2845
        void Cancel13Action() {
            com.codecharge.components.Button buttonModel = (com.codecharge.components.Button) model.getChild("Cancel");
            Vector excludeParams = new Vector(buttonModel.getExcludeParams());
            excludeParams.addAll(model.getExcludeParams());
            page.setRedirectString( "AmvRichieste" + Names.ACTION_SUFFIX + "?" + page.getHttpGetParams().toString( excludeParams ) );
            buttonModel.fireOnClickEvent();
        }
//End Cancel Button

void read() { //AMV_DOCUMENTO_RESPINGI Record: method read @6-7F8AAE5A

//AMV_DOCUMENTO_RESPINGI Record: method read head @6-DB74C422
            if (!model.isAllowRead()) return;
            model.fireBeforeSelectEvent();
//End AMV_DOCUMENTO_RESPINGI Record: method read head

//AMV_DOCUMENTO_RESPINGI Record: init DataSource @6-A421E96A
            if (!model.isAllowRead()) return;
            boolean isErrors = false;
            AMV_DOCUMENTO_RESPINGIDataObject ds = new AMV_DOCUMENTO_RESPINGIDataObject(page);
            ds.setComponent( model );
            try {
                ds.setSesMVIDRIC( SessionStorage.getInstance(req).getAttribute("MVIDRIC"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVIDRIC'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVIDRIC'" );
            }
            try {
                ds.setSesMVREVRIC( SessionStorage.getInstance(req).getAttribute("MVREVRIC"), null );
            } catch ( java.text.ParseException pe ) {
                model.addError( "Invalid parameter 'MVREVRIC'" );
            } catch ( NumberFormatException nfe ) {
                model.addError( "Invalid parameter 'MVREVRIC'" );
            }
            ds.load();
            if ( ds.isEmpty() ) {
                model.setMode(com.codecharge.components.Record.INSERT_MODE);
            } else {
                model.setMode(com.codecharge.components.Record.UPDATE_MODE);
                bind( model, ds.getRow() );
            }
//End AMV_DOCUMENTO_RESPINGI Record: init DataSource

//AMV_DOCUMENTO_RESPINGI Record: check errors @6-5C658222
            isErrors = ds.hasErrors();
            if ( isErrors ) {
                model.addErrors( ds.getErrors() );
                page.setRedirectString( null );
            }
//End AMV_DOCUMENTO_RESPINGI Record: check errors

} //AMV_DOCUMENTO_RESPINGI Record: method read tail @6-FCB6E20C

//AMV_DOCUMENTO_RESPINGI Record: bind @6-E7E4A2B3
            public void bind(com.codecharge.components.Component model, AMV_DOCUMENTO_RESPINGIRow row ) {
                if ( model == null || row == null ) return;
                model.getControl("TITOLO").setValue(row.getTITOLO());
                model.getControl("DATA_INSERIMENTO").setValue(row.getDATA_INSERIMENTO());
                model.getControl("NOMINATIVO_AUTORE").setValue(row.getNOMINATIVO_AUTORE());
                model.getControl("DATA_AGGIORNAMENTO").setValue(row.getDATA_AGGIORNAMENTO());
                model.getControl("NOMINATIVO_AGGIORNAMENTO").setValue(row.getNOMINATIVO_AGGIORNAMENTO());
                model.getControl("CRONOLOGIA").setValue(row.getCRONOLOGIA());
                model.getControl("NOTE_LABEL").setValue(row.getNOTE_LABEL());
                if ( this.valid ) {
                    model.getControl("NOTE").setValue(row.getNOTE());
                    model.getControl("REVISIONE").setValue(row.getREVISIONE());
                    model.getControl("ID_DOCUMENTO").setValue(row.getID_DOCUMENTO());
                }
            }
//End AMV_DOCUMENTO_RESPINGI Record: bind

//AMV_DOCUMENTO_RESPINGI Record: getRowFieldByName @6-2AAEE66F
            public Object getRowFieldByName( String name, AMV_DOCUMENTO_RESPINGIRow row ) {
                Object value = null;
                if ( "TITOLO".equals(name) ) {
                    value = row.getTITOLO();
                } else if ( "DATA_INSERIMENTO".equals(name) ) {
                    value = row.getDATA_INSERIMENTO();
                } else if ( "NOMINATIVO_AUTORE".equals(name) ) {
                    value = row.getNOMINATIVO_AUTORE();
                } else if ( "DATA_AGGIORNAMENTO".equals(name) ) {
                    value = row.getDATA_AGGIORNAMENTO();
                } else if ( "NOMINATIVO_AGGIORNAMENTO".equals(name) ) {
                    value = row.getNOMINATIVO_AGGIORNAMENTO();
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
//End AMV_DOCUMENTO_RESPINGI Record: getRowFieldByName

void InsertAction() { //AMV_DOCUMENTO_RESPINGI Record: method insert @6-11643485

//AMV_DOCUMENTO_RESPINGI Record: components insert actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AMV_DOCUMENTO_RESPINGI Record: components insert actions

} //AMV_DOCUMENTO_RESPINGI Record: method insert tail @6-FCB6E20C

void UpdateAction() { //AMV_DOCUMENTO_RESPINGI Record: method update @6-5771D0AA

//AMV_DOCUMENTO_RESPINGI Record: components update actions @6-68525650
            if (! model.hasErrors()) {
            }
//End AMV_DOCUMENTO_RESPINGI Record: components update actions

} //AMV_DOCUMENTO_RESPINGI Record: method update tail @6-FCB6E20C

void DeleteAction() { //AMV_DOCUMENTO_RESPINGI Record: method delete @6-11FC2E1E

//AMV_DOCUMENTO_RESPINGI Record: method delete head @6-9435BE8B
            if (!model.isAllowDelete()) return;
            model.fireBeforeDeleteEvent();
//End AMV_DOCUMENTO_RESPINGI Record: method delete head

//AMV_DOCUMENTO_RESPINGI Record: method delete body @6-D18E9ADB
            if (!model.isAllowDelete()) return;
            boolean isErrors = false;
            AMV_DOCUMENTO_RESPINGIDataObject ds = new AMV_DOCUMENTO_RESPINGIDataObject(page);
            ds.setComponent( model );
            AMV_DOCUMENTO_RESPINGIRow row = new AMV_DOCUMENTO_RESPINGIRow();
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
            ds.setExprKey45( ( "F" ) );
            ds.setPostNOTE( page.getHttpPostParams().getParameter("NOTE") );
            ds.setSesUtente( SessionStorage.getInstance(req).getAttribute("Utente") );
            ds.setPostUTENTE_REDAZIONE( page.getHttpPostParams().getParameter("UTENTE_REDAZIONE") );
//End AMV_DOCUMENTO_RESPINGI Record: method delete body

//AMV_DOCUMENTO_RESPINGI Record: ds.delete @6-3584344F
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
//End AMV_DOCUMENTO_RESPINGI Record: ds.delete

} //AMV_DOCUMENTO_RESPINGI Record: method delete tail @6-FCB6E20C

//AMV_DOCUMENTO_RESPINGI Record: method validate @6-D4A077B9
        boolean validate() {
            model.fireOnValidateEvent();
            boolean isControlError = false;

            com.codecharge.components.TextArea NOTE = (com.codecharge.components.TextArea) model.getChild( "NOTE" );
            if (! NOTE.validate()) { isControlError = true; }

            com.codecharge.components.Hidden REVISIONE = (com.codecharge.components.Hidden) model.getChild( "REVISIONE" );
            if (! REVISIONE.validate()) { isControlError = true; }

            com.codecharge.components.Hidden ID_DOCUMENTO = (com.codecharge.components.Hidden) model.getChild( "ID_DOCUMENTO" );
            if (! ID_DOCUMENTO.validate()) { isControlError = true; }
            this.valid = ( ! (model.hasErrors() || isControlError) );
            return ( ! (model.hasErrors() || isControlError) );
        }
//End AMV_DOCUMENTO_RESPINGI Record: method validate

//AMV_DOCUMENTO_RESPINGI Record Tail @6-FCB6E20C
    }
//End AMV_DOCUMENTO_RESPINGI Record Tail

//AmvRichiestaElimina Page: method validate @1-104025BA
    boolean validate() {
        return true;
    }
//End AmvRichiestaElimina Page: method validate

//AmvRichiestaEliminaAction Tail @1-FCB6E20C
}
//End AmvRichiestaEliminaAction Tail
